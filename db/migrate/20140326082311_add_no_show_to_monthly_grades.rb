class AddNoShowToMonthlyGrades < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :no_show, :integer
  end
end
