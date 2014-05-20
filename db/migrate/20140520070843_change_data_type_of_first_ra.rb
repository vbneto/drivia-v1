class ChangeDataTypeOfFirstRa < ActiveRecord::Migration
  def up
    change_column :student_from_excels, :first_ra, 'integer USING CAST(first_ra AS integer)'
  end

  def down
    change_column :student_from_excels, :first_ra, :string
  end
end
