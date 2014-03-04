class UsersController < ApplicationController
  before_filter :authenticate_user!, :except => [:home]
  
  def home
  end
  
  def index
  end
  
end
