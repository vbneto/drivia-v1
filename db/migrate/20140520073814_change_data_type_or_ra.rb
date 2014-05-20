class ChangeDataTypeOrRa < ActiveRecord::Migration
  def up
    change_column :student_statuses, :ra, 'integer USING CAST(ra AS integer)'
  end

  def down
    change_column :student_statuses, :ra, :string
  end
end
