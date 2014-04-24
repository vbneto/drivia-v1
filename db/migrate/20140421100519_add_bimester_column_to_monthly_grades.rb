class AddBimesterColumnToMonthlyGrades < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :bimester, :string
  end
end
