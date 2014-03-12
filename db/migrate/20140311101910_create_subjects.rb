class CreateSubjects < ActiveRecord::Migration
  def change
    create_table :subjects do |t|
      t.belongs_to :grade
      t.string :name

      t.timestamps
    end
  end
end
