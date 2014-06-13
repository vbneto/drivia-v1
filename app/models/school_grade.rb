class SchoolGrade < ActiveRecord::Base
  attr_accessible :grade_class, :grade_name_id, :professor_school_id, :subject_average, :subject_id, :status, :professor_record_attributes, :grade_name_attributes, :user_attributes
  belongs_to :subject
  belongs_to :grade_name
  belongs_to :professor_school
  has_one :professor_record, through: :professor_school
  has_one :professor,through: :professor_record
  has_one :user,through: :professor
  has_one :school, through: :professor_school
  validates_uniqueness_of :grade_name_id, :scope => [:professor_school_id, :grade_class, :subject_id], :on => :create
  validates_presence_of :grade_class, :grade_name_id, :subject_id, :subject_average
  validate :unique_professor, :on => :create
  before_create :unique_professor
  validate :unique_professor_for_update, :on => :update
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :grade_name
  accepts_nested_attributes_for :professor_record
  
  def self.grade_list(file,school_id)
    spreadsheet = open_spreadsheet(file)
    already_present_grades = []
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      grade = find_by_id(row["id"]) || new
      grade.attributes = row.to_hash.slice(*accessible_attributes)
      grade_name = GradeName.find_or_create_by_name(row["grade_name"])
      grade.grade_name_id = grade_name.id 
      subject = Subject.find_or_create_by_name(row["subject_name"])
      grade.subject_id = subject.id
      professor_record = School.find(school_id).professor_records.where(name: row["professor_name"]).first
      if professor_record.blank?
        professor = ProfessorRecord.create(name: row["professor_name"], code: User.generate_unique_code)
        grade.professor_school_id = ProfessorSchool.create(professor_record_id: professor.id, school_id: school_id).id
      else
        professor = ProfessorSchool.where("professor_record_id=? and school_id= ?", professor_record.id, school_id)
        grade.professor_school_id = professor.first.id
      end
      begin
        grade.save!
      rescue
        already_present_grades << grade.grade_name
      end  
    end
    already_present_grades  
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

  def professor_name
    self.professor_record.name
  end

  def professor_grade_name
    self.grade_name.name
  end

  def join_grade_name_and_class
    professor_grade_name + " " + self.grade_class
  end

  def professor_subject_name
    self.subject.name
  end

  def is_professor_sign_up?
    !professor_record.professor.nil?
  end
  
  private
  
  def unique_professor
    unless school.school_grades.where("grade_name_id=? and grade_class=? and subject_id=? and status = ?", grade_name_id, grade_class, subject_id, User.student_active).blank?
      errors.add(:grade_name_id, 'Other professor is already teaching this '+Subject.find(subject_id).name+' in this school')
    end
  end

  def unique_professor_for_update
    unless SchoolGrade.where("grade_class = ? and grade_name_id = ? and subject_id = ? and id != ? and status = ?", grade_class, grade_name_id, subject_id, id, User.student_active).blank?
      errors.add(:grade_name_id, 'Other professor is already teaching this '+Subject.find(subject_id).name+' in this school')
    end
  end  
  
end
