class ChangeStringToIntegerAtStudents < ActiveRecord::Migration
  def up
    change_column :students, :student_from_excel_id, 'integer USING CAST(student_from_excel_id AS integer)'
  end

  def down
    change_column :students, :student_from_excel_id, :string
  end
end
