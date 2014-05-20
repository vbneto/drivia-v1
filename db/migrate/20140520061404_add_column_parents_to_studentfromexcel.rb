class AddColumnParentsToStudentfromexcel < ActiveRecord::Migration
  def change
    add_column :student_from_excels, :parent_name_1, :string
    add_column :student_from_excels, :parent_name_2, :string
  end
end
