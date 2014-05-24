class RenameCpfToCodeToStudentfromexcel < ActiveRecord::Migration
  def up
    rename_column :student_from_excels, :cpf, :code
  end

  def down
    rename_column :student_from_excels, :code, :cpf
  end
end
