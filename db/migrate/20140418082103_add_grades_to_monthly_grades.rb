class AddGradesToMonthlyGrades < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :grade_name, :string, :null => false, :default => ''
    add_column :monthly_grades, :grade_class, :string, :null => false, :default => ''
  end
end
