class CreateStudentParents < ActiveRecord::Migration
  def change
    create_table :student_parents do |t|
      t.integer :student_from_excel_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
