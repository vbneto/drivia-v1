class RegistrationsController < Devise::RegistrationsController
  
  def new
    @user_role = params[:user]
    if @user_role != User.find_professor_role
      code = params[:code]
      @student = StudentFromExcel.find_by_code(code)
    else
      code = params[:code]
      @professor = GradeFromExcel.find_by_code(code)
    end  
    super
  end
  
  def create
    @user_role = params[:user].delete(:role)
    #Todo
    if User.where(email: params[:user][:email]).first
      redirect_to new_user_session_path, :flash => {:error => "This e-mail is already used. Please, log in to your Drivia account and update your account (My account > Update account)"} and return
    end
    if @user_role == User.find_professor_role
      code = params[:user].delete(:code)
      @professor = GradeFromExcel.find_by_code(code)
    else
      code = params[:user].delete(:code)
      @student = StudentFromExcel.find_by_code(code)
    end  
    if @user_role == User.find_parent_role || @user_role == User.find_professor_role 
      gender = params[:user].delete(:gender)
      birth_day = params[:user].delete(:birth_day)
    end
    build_resource(params[:user])
    resource.role = @user_role
    resource.name = @professor.professor_name if @professor
    if resource.save
      if @user_role == User.find_student_role
        Student.create(:user_id => resource.id, :school_id => @student.school_id, :student_from_excel_id => @student.id) 
      elsif @user_role == User.find_parent_role
        parent = Parent.create(:user_id => resource.id, :gender => gender, :birth_day => birth_day)
        parent.student_parents.create(student_from_excel_id: @student.id)
      elsif @user_role == User.find_professor_role
        Professor.create(user_id: resource.id, gender: gender, birth_day: birth_day, grade_from_excel_id: @professor.id)  
      end  
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      flash[:error] = resource.errors.full_messages
      clean_up_passwords resource
      redirect_to new_user_registration_path(code: code, user: @user_role)
    end
  end
    
end
