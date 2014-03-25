class StudentFromExcel < ActiveRecord::Base
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :student_name, :school_id
  validates :cpf, uniqueness: true
  validates :school_id, presence: true
  validates :cpf, :cpf => true
  
  belongs_to :school
  has_many :student_parents
  has_many :monthly_grades
  has_many :parents, through: :student_parents
  
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
    self.monthly_grades.select{|grade| grade.subject_name == subject and grade.month==Date::MONTHNAMES.index(month)}.first
  end
  
  def self.find_all_student_id_of_current_grade student
    self.where("school_id=? and current_grade=?",student.school_id, student.current_grade).map(&:id)
  end
  
end
