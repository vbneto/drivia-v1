class StudentFromExcelsController < ApplicationController
  StudentFromExcel.skip_callback("create",:after)
  def new
    @student = StudentFromExcel.new
    @student.student_statuses.build
  end
  
  def create
    @student = StudentFromExcel.find_by_cpf(params[:student_from_excel][:cpf])
    school_id = current_school_administration.school_id
    if @student
      student_status = @student.student_statuses
      if @student.get_active_status
        flash[:error] = 'student is already present or active in other school'
        render 'new'
      else 
        student_status.create(params[:student_from_excel][:student_statuses_attributes]["0"].merge!(:school_id=> school_id, :status=> User.student_active))
        flash[:notice] = "Student is added successfylly"
        redirect_to show_users_school_administrations_path  
      end
    else
      params[:student_from_excel][:student_statuses_attributes]["0"].merge!(:school_id=>school_id, :status=>User.student_active)
      params[:student_from_excel][:current_grade] = params[:student_from_excel][:student_statuses_attributes]["0"][:current_grade]
      @student = StudentFromExcel.new(params[:student_from_excel])
      if @student.save
        flash[:notice] = "Student is added successfylly"
        redirect_to show_users_school_administrations_path
      else
        render 'new'
      end
    end    
  end
end
