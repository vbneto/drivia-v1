class CreateProfessors < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.string :grade_from_excel_id
      t.string :user_id
      t.string :gender
      t.date :birth_day

      t.timestamps
    end
  end
end
