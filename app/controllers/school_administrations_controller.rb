class SchoolAdministrationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_school_administration!
  
  def show_students
    @all_students = current_school_administration.student_from_excels
  end
  
end
