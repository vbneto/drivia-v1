class AddColumnToStudent < ActiveRecord::Migration
  def change
    add_column :students, :student_from_excel_id, :string
  end
end
