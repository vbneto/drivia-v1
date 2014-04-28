class CreateProfessorSchools < ActiveRecord::Migration
  def change
    create_table :professor_schools do |t|
      t.integer :professor_record_id
      t.integer :school_id

      t.timestamps
    end
  end
end
