class Grade < ActiveRecord::Base
  has_many :subjects
  attr_accessible :name
  
  def self.initialize_graph(hash_of_data)
    hash_of_data.to_a.insert(0,["Months","Grade"])
  end
  
  def self.find_all_student_grade student
    all_student_id_of_current_grade = StudentFromExcel.find_all_student_id_of_current_grade student
    MonthlyGrade.select{|grade| all_student_id_of_current_grade.include?(grade.student_from_excel_id)}
  end
  
end
