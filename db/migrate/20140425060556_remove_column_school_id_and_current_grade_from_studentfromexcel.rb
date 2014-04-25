class RemoveColumnSchoolIdAndCurrentGradeFromStudentfromexcel < ActiveRecord::Migration
  def up
    remove_column :student_from_excels, :school_id
    remove_column :student_from_excels, :current_grade
  end

  def down
    add_column :student_from_excels, :school_id
    add_column :student_from_excels, :current_grade
  end
end
