class RemoveColumnsFromStudentfromexcel < ActiveRecord::Migration
  def up
    remove_column :student_from_excels, [:birth_day, :gender, :current_grade, :status]
  end

  def down
    add_column :student_from_excels, [:birth_day, :gender, :current_grade, :status]
  end
end
