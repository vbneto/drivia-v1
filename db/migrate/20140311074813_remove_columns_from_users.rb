class RemoveColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :cpf
    remove_column :users, :gender
    remove_column :users, :birth_day
    remove_column :users, :current_grade
  end

  def down
    add_column :users, :current_grade, :string
    add_column :users, :birth_day, :date
    add_column :users, :gender, :string
    add_column :users, :cpf, :string
  end
end
