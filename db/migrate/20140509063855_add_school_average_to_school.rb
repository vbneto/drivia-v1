class AddSchoolAverageToSchool < ActiveRecord::Migration
  def change
    add_column :schools, :school_average, :float
  end
end
