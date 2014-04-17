class AddColumnToStudentStatuses < ActiveRecord::Migration
  def change
    add_column :student_statuses, :current_grade, :string
    add_column :student_statuses, :year, :string
  end
end
