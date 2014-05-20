class AddColumnFirstRaToStudentfromexcel < ActiveRecord::Migration
  def change
    add_column :student_from_excels, :first_ra, :string
  end
end
