class AddStatusToParent < ActiveRecord::Migration
  def change
    add_column :parents, :status, :string
  end
end
