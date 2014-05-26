class SchoolGrade < ActiveRecord::Base
  attr_accessible :grade_class, :grade_name_id, :professor_school_id, :subject_average, :subject_id
  belongs_to :subject
  belongs_to :grade_name
  belongs_to :professor_school
  has_one :school, through: :professor_school
  has_many :professor_records, through: :professor_school
  
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
end
