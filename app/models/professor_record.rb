class ProfessorRecord < ActiveRecord::Base
  attr_accessible :code, :name, :school_grades_attributes, :current_school_id
  attr_accessor :current_school_id

  has_many :professor_schools
  has_many :schools, :through => :professor_schools
  has_many :school_grades, :through => :professor_schools
  has_one :professor
  validates_presence_of :name
  validates_uniqueness_of :name, :if => :is_professor_name_present?, :on => :update
  
  accepts_nested_attributes_for :school_grades
  validates :name, presence: true, format: { with: /^[^0-9!@#\$%\^&*+_=]+$/, message: "Only letters allowed" }

  def self.create_professor_record(params,school_id)
    professor_name = params[:professor_record][:name]
    already_present_grades = []
    params[:professor_record][:school_grades_attributes].each do |school_grade|
      school_grade[1].delete('_destroy')
      row = school_grade[1]
      grade = SchoolGrade.new(row)
      grade_name = GradeName.find_or_create_by_id(row["grade_name_id"])
      grade.grade_name_id = grade_name.id
      subject = Subject.find_or_create_by_name(row["subject_id"])
      grade.subject_id = subject.id
      professor_record = School.find(school_id).professor_records.where(name: professor_name).first
      if professor_record.blank?
        professor = ProfessorRecord.create(name: professor_name, code: User.generate_unique_code)
        grade.professor_school_id = ProfessorSchool.create(professor_record_id: professor.id, school_id: school_id).id
      else
        professor = ProfessorSchool.where("professor_record_id=? and school_id= ?", professor_record.id, school_id)
        grade.professor_school_id = professor.first.id
      end
      begin
        grade.save!
      rescue
        grade.errors.full_messages.each{|msg| already_present_grades << msg}
        #already_present_grades << grade.subject.name+" "+grade.grade_name.name+" "+grade.grade_class
      end   
    end
    already_present_grades
  end 
  
  def update_professor_school(old_professor)
    self.professor_schools.each do |grade|
      grade.professor_record_id = old_professor.id
      grade.save
    end
    self.destroy
  end  

  private
 
  def is_professor_name_present?
    School.find(self.current_school_id).professor_records.where(:name=>self.name).reject{|p| p.id==self.id}.present?
  end 
end
