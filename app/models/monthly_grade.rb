class MonthlyGrade < ActiveRecord::Base
  attr_accessible :grade, :record_date, :student_from_excel_id, :subject_name, :month, :no_show, :year, :student_status_id, :grade_description
  attr_accessible :grade_name, :grade_class, :bimester
  validates :grade, numericality: true, inclusion: 0..10, allow_nil: true
  validates :no_show, numericality: true, inclusion: 0..31, allow_nil: true
  
  belongs_to :student_from_excel
  
  def self.uniq_grade grades
    grades.map(&:subject_name).uniq
  end

  def self.uniq_subjects grades
    grades.map(&:subject_name).uniq unless grades.blank?
  end
  
  def self.particular_subject(grades, subject) 
    grades.select{|grade| grade.subject_name==subject}
  end
  
  def self.import_grade_list(school, params)
    available_ra = []
    students = school.select_student_of_current_grade(params[:grade_name], params[:grade_class])
    students.each{|student| available_ra << student.active_ra}
    spreadsheet = SchoolGrade.open_spreadsheet(params[:file])
    mapped_row ={"RA" => "ra", "Nome" => "student_name", "Turma" => "grade_name", "Classe" => "grade_class", "Nota do bimester" => "grade", "descricio da nota" => "grade_description", "Faltas do bimester" => "no_show"}
    if spreadsheet
      header = spreadsheet.row(1)
      mapped_row.each{|k,v| header.each_with_index{|value,index| header[index] = v if value == k}}
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        next unless available_ra.include?row["ra"].to_i
        student = StudentStatus.find_by_ra(row["ra"]).student_from_excel
        student_grade = student.student_grade(params[:subject], params[:bimester])
        student_grade = new if student_grade.blank?
        student_grade.attributes = row.to_hash.slice(*accessible_attributes)
        student_grade.student_from_excel_id = student.id
        student_grade.subject_name = params[:subject]
        student_grade.student_status_id = student.get_active_status.id
        student_grade.bimester = params[:bimester]
        student_grade.year = Date.today.year
        student_grade.save
      end  
    else
      return "Please save the excel sheet in .xls formate"
    end
  end
  
end



