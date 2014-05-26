class ProfessorRecord < ActiveRecord::Base
  attr_accessible :code, :name, :school_grades_attributes
  
  has_many :professor_schools
  has_many :schools, :through => :professor_schools
  has_many :school_grades, :through => :professor_schools
  has_one :professor
  accepts_nested_attributes_for :school_grades
  
  def self.create_professor_record(params,school_id)
    professor_name = params[:professor_record][:name]
    already_present_grades = []
    params[:professor_record][:school_grades_attributes].each do |school_grade|
      school_grade[1].delete('_destroy')
      row = school_grade[1]
      grade = SchoolGrade.new(row)
      grade_name = GradeName.find_or_create_by_name(row["grade_name_id"])
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
        already_present_grades << grade.subject.name+" "+grade.grade_name.name+" "+grade.grade_class
      end   
    end
    already_present_grades
  end 
  
end
