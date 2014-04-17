class AddColumnToMonthlyGrades < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :student_status_id, :integer
  end
end
