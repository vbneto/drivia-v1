class AddYeatToMonthlyGrades < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :year, :integer
  end
end
