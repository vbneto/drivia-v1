class CreateSchoolGrades < ActiveRecord::Migration
  def change
    create_table :school_grades do |t|
      t.integer :grade_name_id
      t.integer :subject_id
      t.integer :professor_school_id
      t.string :grade_class
      t.float :subject_average

      t.timestamps
    end
  end
end
