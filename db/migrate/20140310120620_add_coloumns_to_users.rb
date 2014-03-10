class AddColoumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cpf, :string
    add_column :users, :gender, :string
    add_column :users, :birth_day, :date
    add_column :users, :current_grade, :string
  end
end
