module SchoolsHelper

  def uniq_school_grade_name
    @student_record.school.grade_from_excels.map(&:grade_name).uniq.sort
  end

end
