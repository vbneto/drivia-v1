class RegistrationsController < Devise::RegistrationsController
  before_filter :check_attribute, :only => [:create, :update]
  
  def check_attribute
    unless params[:user][:role] == nil
      redirect_to root_path, notice:"You were not authorize to assign role"
      return
    end
  end
  
end
