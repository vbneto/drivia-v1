class AddColumnStatusToSchoolGrades < ActiveRecord::Migration
  def change
    add_column :school_grades, :status, :string
  end
end
