class RenameColumnToProfessorRecordInProfessor < ActiveRecord::Migration
  def up
    rename_column :professors, :grade_from_excel_id, :professor_record_id
  end

  def down
    rename_column :professors, :professor_record_id, :grade_from_excel_id
  end
end
