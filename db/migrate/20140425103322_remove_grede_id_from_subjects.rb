class RemoveGredeIdFromSubjects < ActiveRecord::Migration
  def up
    remove_column :subjects, :grade_id
  end

  def down
    add_column :subjects, :grade_id
  end
end
