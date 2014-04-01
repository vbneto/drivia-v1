class CreateSchoolAdministrations < ActiveRecord::Migration
  def change
    create_table :school_administrations do |t|
      t.integer :user_id
      t.integer :school_id

      t.timestamps
    end
  end
end
