class FixcolumnsToStudentParent < ActiveRecord::Migration
  def up
    rename_column :student_parents, :student_from_excel, :student_from_excel_id
  end

  def down
  end
end
