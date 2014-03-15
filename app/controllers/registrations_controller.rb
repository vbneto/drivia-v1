class RegistrationsController < Devise::RegistrationsController
  
  def new
    cpf = params[:cpf]
    @user_role = params[:user]
    @student = StudentFromExcel.find_by_cpf(cpf)
    if @user_role == "parent"
      if @student.student_parents.size == 2
        redirect_to root_path, :notice => "There is already two parents are there for this student" 
        return
      end
    end
    if @user_role == "student"
      if Student.find_by_student_from_excel_id(@student.id.to_s)
        redirect_to root_path, :notice => "There is already one student present for this cpf" 
        return
      end
    end
    super
  end
  
  def create
    user_role = params[:user][:role]
    cpf = params[:user][:cpf]
    @student = StudentFromExcel.where(:cpf=>cpf).first 
    params[:user].delete :role
    params[:user].delete :cpf
    if user_role=="parent"
      gender = params[:user][:gender]
      birth_day = params[:user][:birth_day]
      params[:user].delete :gender
      params[:user].delete :birth_day
    end
    build_resource(params[:user])
    #resource.tag_list = params[:tags]   #******** here resource is user 
    resource.role = user_role
    if resource.save
      if user_role == "student"
        Student.create(:user_id => resource.id, :school_id => @student.school_id, :student_from_excel_id => @student.id) 
      elsif user_role == "parent"
        parent = Parent.create(:user_id => resource.id, :gender => gender, :birth_day => birth_day)
        #StudentParent.create(:student_from_excel_id => @student.id, :parent_id => parent.id)
        parent.student_parents.create(student_from_excel_id: @student.id)
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
      redirect_to new_registration_with_cpf_users_path, :notice=> "Please fill the form correctly"
    end
  end
    
end
