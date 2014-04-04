class AddColoumnToStudentFromExcels < ActiveRecord::Migration
  def change
    add_column :student_from_excels, :status, :string
  end
end
