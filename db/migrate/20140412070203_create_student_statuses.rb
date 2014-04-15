class CreateStudentStatuses < ActiveRecord::Migration
  def change
    create_table :student_statuses do |t|
      t.integer :student_from_excel_id
      t.integer :school_id
      t.string :status

      t.timestamps
    end
  end
end
