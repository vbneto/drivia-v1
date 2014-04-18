class AddColumnToGradeFromExcels < ActiveRecord::Migration
  def change
    add_column :grade_from_excels, :grade_class, :string, :null => false, :default => ''
  end
end
