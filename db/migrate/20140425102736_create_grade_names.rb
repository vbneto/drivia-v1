class CreateGradeNames < ActiveRecord::Migration
  def change
    create_table :grade_names do |t|
      t.string :name

      t.timestamps
    end
  end
end
