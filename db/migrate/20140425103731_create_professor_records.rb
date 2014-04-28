class CreateProfessorRecords < ActiveRecord::Migration
  def change
    create_table :professor_records do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
