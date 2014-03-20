class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  ROLES = ["Student", "Parent", "School Administration", "professor"]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :gender, :birth_day
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :phoneprefix, :phone
  attr_accessible :role, :name, :email, :password, :password_confirmation, :as => [:admin]
  validates :name, :presence => true
  
  #accepts_nested_attributes_for :student, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def is_student?
    self.role=="student"
  end
  
  def is_parent?
    self.role=="parent"
  end
  
  def is_admin?
    self.role=="admin"
  end
  
  def is_professor?
    self.role=="professor"
  end
  
  def self.check_cpf cpf
    if cpf.size == 11
      cpf.insert(3,'.')
      cpf.insert(7,'.')
      cpf.insert(11,'-')
    end
    cpf
  end
  
  
end
