class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.belongs_to :user
      t.string :cpf
      t.string :gender
      t.date :birth_day
      t.string :current_grade

      t.timestamps
    end
  end
end
