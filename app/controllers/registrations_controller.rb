class RegistrationsController < Devise::RegistrationsController
  
  def new
    @user_role = params[:user]
    if @user_role != User.find_professor_role
      cpf = params[:cpf]
      @student = StudentFromExcel.find_by_cpf(cpf)
    else
      email = params[:email]
      @professor = ProfessorRecord.find_by_email(email)
    end  
    super
  end
  
  def create
    @user_role = params[:user][:role]
    params[:user].delete :role
    if @user_role != User.find_professor_role
      cpf = params[:user][:cpf]
      @student = StudentFromExcel.where(:cpf=>cpf).first 
      params[:user].delete :cpf
    else
      @professor = ProfessorRecord.find_by_email(params[:user][:email])  
    end  
    if @user_role == User.find_parent_role || @user_role == User.find_professor_role 
      gender = params[:user][:gender]
      birth_day = params[:user][:birth_day]
      params[:user].delete :gender
      params[:user].delete :birth_day
    end
      
    build_resource(params[:user])
    #resource.tag_list = params[:tags]   #******** here resource is user 
    resource.role = @user_role
    if resource.save
      if @user_role == User.find_student_role
        Student.create(:user_id => resource.id, :school_id => @student.school_id, :student_from_excel_id => @student.id) 
      elsif @user_role == User.find_parent_role
        parent = Parent.create(:user_id => resource.id, :gender => gender, :birth_day => birth_day)
        parent.student_parents.create(student_from_excel_id: @student.id)
      elsif @user_role == User.find_professor_role
        Professor.create(user_id: resource.id, gender: gender, birth_day: birth_day, professor_record_id: @professor.id)  
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
      clean_up_passwords resource
      #respond_with resource
      redirect_to new_user_registration_path(cpf: cpf, user: @user_role), :notice=> "Please completly fill the form"
    end
  end
    
end
