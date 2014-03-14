class CreateGradeFromExcels < ActiveRecord::Migration
  def change
    create_table :grade_from_excels do |t|
      t.integer :school_id
      t.string :grade_name
      t.string :subject_name
      t.float :subject_average
      t.string :professor_name

      t.timestamps
    end
  end
end
