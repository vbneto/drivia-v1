class StudentFromExcel < ActiveRecord::Base
  attr_accessible :birth_day, :cpf, :current_grade, :gender, :student_name, :school_id
  validates :cpf, uniqueness: true
  validates :school_id, presence: true
  validates :cpf, :cpf => true
  
  belongs_to :school
  has_many :student_parents
  has_many :parents, through: :student_parents
  
  def self.import(file,school_id)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      student = find_by_id(row["id"]) || new
      student.attributes = row.to_hash.slice(*accessible_attributes)
      student.school_id = school_id
      return false if student.cpf.nil?
      student.save!
    end
    return true
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
