class StudentFromExcel < ActiveRecord::Base

  attr_accessible :student_name, :school_id, :first_ra, :user_attributes, :student_statuses_attributes, :parent_name_1, :parent_name_2
  validates :code, uniqueness: true
  attr_accessible :status, :code, :as => [:admin]
  attr_accessor :grade_class, :current_grade, :birth_day, :gender, :status, :ra
  #validates :school_id, presence: true
  validates :student_name, presence: true, format: { with: /^[^0-9!@#\$%\^&*+_=]+$/, message: "Only letters allowed" }

  belongs_to :school
  has_many :student_parents
  has_many :monthly_grades
  has_many :parents, through: :student_parents
  has_one :student
  has_one :school_administration, :through => :school
  has_one :user, :through => :student
  has_many :student_statuses
  
  scope :find_students_of_current_grade, lambda{|student| find :all, :include=>[:monthly_grades], :conditions => ['school_id=? and current_grade=?',student.school_id, student.current_grade] }
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :student_statuses
  
  #after_create :update_student_parent_fields
  after_create :update_student_status
  
  def is_active_code?
    !(self.status == User.student_deactive || StudentFromExcel.where("code = ? and status = ?",self.code, User.student_active).blank?)
  end

  def self.student_list(file,school_id)
    spreadsheet = open_spreadsheet(file)
    already_present_students = []
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      student = find_by_first_ra(row["ra"].to_i) || new
      student.attributes = row.to_hash.slice(*accessible_attributes)
      student.grade_class = row['grade_class'].blank? ? '' : row['grade_class']
      student.current_grade = row['current_grade']
      student.ra = row['ra']
      if student.new_record?
        student.first_ra = row["ra"].to_i
        student.code = User.generate_unique_code 
      end
      student.new_record? ? (student.parent_name_1 = row['parent_name']) : (student.parent_name_2 = row['parent_name'])
      student.school_id = school_id
      student.valid? ? student.save! : already_present_students << student.code
    end
    already_present_students  
  end

  def self.open_spreadsheet(file)
    begin
      case File.extname(file.original_filename)
      when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
      when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
      when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
      else nil #raise "Unknown file type: #{file.original_filename}"
      end
    rescue
      nil
    end  
  end
  
  def student_grade(subject, bimester)
    self.get_active_status.monthly_grades.select{|grade| grade.subject_name == subject and grade.bimester == bimester and grade.year == Date.today.year }.first
  end

  def find_fellow_students_monthly_grade(year=nil, student_status)
    students_of_current_grade = StudentStatus.where(school_id: student_status.school_id, current_grade: student_status.current_grade, grade_class: student_status.grade_class , year: student_status.year).includes(:monthly_grades)
    
    if year.blank?
      students_of_current_grade.map {|student| student.monthly_grades}.flatten  
    else  
      students_of_current_grade.map {|student| student.monthly_grades}.flatten.select{|grade| grade.year==year}
    end
      
  end
  
  def is_active_student?
    self.student_statuses.map(&:status).include?User.student_active
  end
  
  def is_deactive_student?
    !self.student_statuses.map(&:status).include?User.student_active
  end
  
  def is_deactive_student_for_school? school
    self.student_statuses.where(school_id: school.id, status: User.student_active).blank? ? "true" : "false"
  end
  
  def find_age
    now = Time.now.utc
    now.year - self.birth_day.year - (self.birth_day.to_time.change(:year => now.year) > now ? 1 : 0)
  end
  
  def update_student_parent_fields
    student_from_excel = StudentFromExcel.where(:code=>self.code).sort_by(&:created_at)
    if student_from_excel.size > 1
      #previous_record = student_from_excel[-2]
      previous_record = student_from_excel.select{|student| student.student.present?}.first
      student = previous_record.student
      student_parent = previous_record.student_parents
      student.update_attributes(student_from_excel_id: self.id) if student
      student_parent.each{|parent| parent.update_attributes(student_from_excel_id: self.id)} if student_parent.present?
    end
  end
  
  def update_student_status
    student_from_excel = StudentFromExcel.find_by_code(self.code)
    if self.grade_class.blank?
      student_from_excel.student_statuses.create(school_id: self.school_id, ra: self.ra.to_i, status: User.student_active, current_grade: self.current_grade, year: Date.today.year) if student_from_excel
    else
      student_from_excel.student_statuses.create(school_id: self.school_id, ra: self.ra.to_i, status: User.student_active, current_grade: self.current_grade, year: Date.today.year, grade_class: self.grade_class) if student_from_excel
    end  
  end
  
  def get_active_status
    student_status = self.student_statuses.find_by_status(User.student_active)
    student_status unless student_status.blank?
  end
  
  def active_school
    get_active_status.school
  end
  
  def status_for_school school_id
    self.student_statuses.find_by_school_id(school_id)
  end
  
  def current_school_status school_id
    self.student_statuses.where(school_id: school_id).first 
  end
  
  def parent_names
    parent_names = []
    parent_names << self.parent_name_1 if self.parent_name_1
    parent_names << self.parent_name_2 if self.parent_name_1
    parent_names
  end
  
end
