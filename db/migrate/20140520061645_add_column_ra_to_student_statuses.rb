class AddColumnRaToStudentStatuses < ActiveRecord::Migration
  def change
    add_column :student_statuses, :ra, :string
  end
end
