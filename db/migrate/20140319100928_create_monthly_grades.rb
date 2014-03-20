class CreateMonthlyGrades < ActiveRecord::Migration
  def change
    create_table :monthly_grades do |t|
      t.date :record_date
      t.integer :student_from_excel_id
      t.float :grade
      t.string :subject_name

      t.timestamps
    end
  end
end
