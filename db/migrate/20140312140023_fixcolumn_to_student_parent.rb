class FixcolumnToStudentParent < ActiveRecord::Migration
  def up
    rename_column :student_parents, :student_id, :student_from_excel
  end

  def down
  end
end
