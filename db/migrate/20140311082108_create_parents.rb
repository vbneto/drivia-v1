class CreateParents < ActiveRecord::Migration
  def change
    create_table :parents do |t|
      t.belongs_to :user
      t.string :gender
      t.date :birth_day

      t.timestamps
    end
  end
end
