class AddMonthToMonthlyGrade < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :month, :integer
  end
end
