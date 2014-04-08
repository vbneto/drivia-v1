class StudentFromExcel < ActiveRecord::Base

  attr_accessible :birth_day, :cpf, :current_grade, :gender, :student_name, :school_id, :user_attributes, :status
  validates :cpf, uniqueness: true, :if => :is_active_cpf?

  validates :school_id, presence: true
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
  
  scope :find_students_of_current_grade, lambda{|student| find :all, :include=>[:monthly_grades], :conditions => ['school_id=? and current_grade=?',student.school_id, student.current_grade] }
  accepts_nested_attributes_for :user

  after_create :update_student_parent_fields
  
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
        student.school_id = school_id
        student.status = User.student_active
        begin
          student.save!
        rescue
          already_present_students << student.cpf
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
    self.monthly_grades.select{|grade| grade.subject_name == subject and grade.month==Date::MONTHNAMES.index(month) and grade.year == Date.today.year }.first
  end

  def find_fellow_students_monthly_grade year=nil
    students_of_current_grade = StudentFromExcel.find_students_of_current_grade self
    if year.blank?
      students_of_current_grade.map {|student| student.monthly_grades}.flatten  
    else  
      students_of_current_grade.map {|student| student.monthly_grades}.flatten.select{|grade| grade.year==year}
    end  
  end
  
  def is_active_student?
    self.status == User.student_active
  end
  
  def is_deactive_student?
    self.status == User.student_deactive
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

end
