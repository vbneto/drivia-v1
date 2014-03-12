class CreateStudentFromExcels < ActiveRecord::Migration
  def change
    create_table :student_from_excels do |t|
      t.belongs_to :school
      t.string :cpf
      t.string :student_name
      t.date :birth_day
      t.string :gender
      t.string :current_grade

      t.timestamps
    end
  end
end
