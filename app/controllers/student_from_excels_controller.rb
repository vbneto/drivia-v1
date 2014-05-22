class StudentFromExcelsController < ApplicationController
  StudentFromExcel.skip_callback("create",:after)
  before_filter :authenticate_user!
  
  def new
    @student = StudentFromExcel.new
    @student.student_statuses.build
  end
  
  def create
    school_id = current_school_administration.school_id
    params[:student_from_excel][:student_statuses_attributes]["0"].merge!(:school_id=>school_id, :status=>User.student_active)
    @student = StudentFromExcel.new(params[:student_from_excel])
    @student.cpf = User.generate_unique_code
    @student.student_statuses.first.ra = @student.first_ra
    if @student.save
      flash[:notice] = "Student is added successfylly"
      redirect_to show_users_school_administrations_path
    else
      render 'new'
    end
  end
  
  def ask_for_code
  end
  
  def merge_student_account
    new_student = StudentFromExcel.find_by_cpf(params[:code])
    if new_student
      new_student_status = new_student.student_statuses.first
      old_student = current_student.student_from_excel
      new_student_status.student_from_excel_id = old_student.id
      if new_student_status.save
        new_student.destroy
        old_student.cpf = params[:code]
        old_student.save
        flash[:notice] = "Student is added successfylly"
      else
        flash[:error] = "Student is already active in any other school please contact to school administration"
      end
      redirect_to users_path
    else
      flash[:error] = "Student with given code is not available please contact to school administration"
      redirect_to new_student_parents_path
    end  
  end
  
end
