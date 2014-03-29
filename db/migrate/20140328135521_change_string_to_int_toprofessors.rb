class ChangeStringToIntToprofessors < ActiveRecord::Migration
  def up
    change_column :professors, :user_id, 'integer USING CAST(user_id AS integer)'
  end

  def down
    change_column :professors, :user_id, :string
  end
end
