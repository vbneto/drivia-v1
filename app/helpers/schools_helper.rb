module SchoolsHelper

  def uniq_school_grade_name
    current_school_administration.school.grade_from_excels.map(&:grade_name).uniq.sort
  end

end
