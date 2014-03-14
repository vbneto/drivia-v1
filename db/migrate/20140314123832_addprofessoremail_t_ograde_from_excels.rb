class AddprofessoremailTOgradeFromExcels < ActiveRecord::Migration
  def up
    add_column :grade_from_excels, :professor_email, :string
  end

  def down
    remove_column :grade_from_excels, :professor_email, :string
  end
end
