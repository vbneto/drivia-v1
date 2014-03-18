class GradeFromExcel < ActiveRecord::Base
  attr_accessible :grade_name, :professor_name, :subject_average, :subject_name, :professor_email
  def self.grade_list(file,school_id)
    spreadsheet = open_spreadsheet(file)
    already_present_grades = []
    notice = ""
    begin
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        grade = find_by_id(row["id"]) || new
        grade.attributes = row.to_hash.slice(*accessible_attributes)
        grade.school_id = school_id
        begin
          grade.save!
        rescue
          already_present_grades << grade.grade_name
        end  
      end
    rescue
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
