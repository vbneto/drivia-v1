class AddGradeDescriptionToMonthlyGrade < ActiveRecord::Migration
  def change
    add_column :monthly_grades, :grade_description, :string
  end
end
