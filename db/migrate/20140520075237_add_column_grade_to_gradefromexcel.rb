class AddColumnGradeToGradefromexcel < ActiveRecord::Migration
  def change
    add_column :grade_from_excels, :code, :string
  end
end
