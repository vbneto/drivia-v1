class AddColumnKnowledgeAreaToGradefromexcel < ActiveRecord::Migration
  def change
    add_column :grade_from_excels, :knowledge_area, :string
  end
end
