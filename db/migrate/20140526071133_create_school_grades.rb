class CreateSchoolGrades < ActiveRecord::Migration
  def change
    create_table :school_grades do |t|
      t.string :grade_class
      t.integer :grade_name_id
      t.integer :professor_school_id
      t.float :subject_average
      t.integer :subject_id

      t.timestamps
    end
  end
end
