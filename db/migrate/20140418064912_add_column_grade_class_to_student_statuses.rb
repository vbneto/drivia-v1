class AddColumnGradeClassToStudentStatuses < ActiveRecord::Migration
  def change
    add_column :student_statuses, :grade_class, :string, :null => false, :default => ''
  end
end
