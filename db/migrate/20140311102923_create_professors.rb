class CreateProfessors < ActiveRecord::Migration
  def change
    create_table :professors do |t|
      t.belongs_to :school
      t.belongs_to :subject
      t.string :name

      t.timestamps
    end
  end
end
