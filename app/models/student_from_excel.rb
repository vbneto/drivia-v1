class StudentFromExcel < ActiveRecord::Base

  attr_accessible :birth_day, :cpf, :current_grade, :gender, :student_name, :school_id, :user_attributes, :status, :student_statuses_attributes
  validates :cpf, uniqueness: true
  attr_accessible :status, :cpf, :as => [:admin]
  attr_accessor :grade_class
  #validates :school_id, presence: true
  validates :cpf, :cpf => true
  validates :student_name, presence: true, format: { with: /\A[a-zA-Z]+\z/, message: "Only letters allowed" }
  validates :birth_day, presence: true
  
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
  
  def is_active_cpf?
    !(self.status == User.student_deactive || StudentFromExcel.where("cpf = ? and status = ?",self.cpf, User.student_active).blank?)
  end

  def self.student_list(file,school_id)
    spreadsheet = open_spreadsheet(file)
    already_present_students = []
    begin
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        student = find_by_id(row["id"]) || new
        student.attributes = row.to_hash.slice(*accessible_attributes)
        student_from_excel = StudentFromExcel.find_by_cpf(student.cpf)
        student.grade_class = row['grade_class'].blank? ? '' : row['grade_class']
        if student_from_excel
          student_status = student_from_excel.student_statuses
          if student_status.map(&:status).include? User.student_active or student_status.map(&:school_id).include?school_id.to_i
            already_present_students << student.cpf 
          else 
            student_status.create(school_id: school_id, status: User.student_active, current_grade: student.current_grade, year: Date.today.year, grade_class: student.grade_class )  
          end  
        else
          student.school_id = school_id
          student.status = User.student_active
          begin
            student.save!
          rescue
            already_present_students << student.cpf
          end
        end    
      end
    rescue  
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
  
  def student_grade(subject, month)
    self.get_active_status.monthly_grades.select{|grade| grade.subject_name == subject and grade.month==Date::MONTHNAMES.index(month) and grade.year == Date.today.year }.first
  end

  def find_fellow_students_monthly_grade(year=nil, student_status)
    students_of_current_grade = StudentStatus.where(school_id: student_status.school_id, current_grade: student_status.current_grade, grade_class: student_status.grade_class , year: student_status.year).includes(:monthly_grades)
    #students_of_current_grade = StudentFromExcel.find_students_of_current_grade self
    
    if year.blank?
      students_of_current_grade.map {|student| student.monthly_grades}.flatten  
    else  
      students_of_current_grade.map {|student| student.monthly_grades}.flatten.select{|grade| grade.year==year}
    end
      
  end
  
  def is_active_student?
    self.student_statuses.map(&:status).include?User.student_active
    #self.student_statuses.first.status == User.student_active
  end
  
  def is_deactive_student?
    !self.student_statuses.map(&:status).include?User.student_active
    #self.student_statuses.first.status == User.student_deactive
  end
  
  def find_age
    now = Time.now.utc
    now.year - self.birth_day.year - (self.birth_day.to_time.change(:year => now.year) > now ? 1 : 0)
  end
  
  def update_student_parent_fields
    student_from_excel = StudentFromExcel.where(:cpf=>self.cpf).sort_by(&:created_at)
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
    unless self.grade_class.blank?
      student_from_excel = StudentFromExcel.find_by_cpf(self.cpf)
      student_from_excel.student_statuses.create(school_id: self.school_id, status: User.student_active, current_grade: self.current_grade, year: Date.today.year, grade_class: self.grade_class) if student_from_excel
    end  
  end
  
  def get_active_status
    student_status = self.student_statuses.find_by_status(User.student_active)
    student_status unless student_status.blank?
  end
  
end
