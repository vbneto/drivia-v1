class ChangeDataTypeOfProfessorsGradeId < ActiveRecord::Migration
  def up
    change_column :professors, :grade_from_excel_id, 'integer USING CAST(grade_from_excel_id AS integer)'
  end

  def down
    change_column :professors, :grade_from_excel_id, :string
  end
end
