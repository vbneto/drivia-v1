class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  ROLES = ["student", "parent", "school administration", "professor"]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessor :gender, :birth_day
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :phoneprefix, :phone
  attr_accessible :role, :name, :email, :password, :password_confirmation, :as => [:admin]
  validates :name, :presence => true
  has_one :parent
  has_one :professor
  has_one :student
  
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
  
  def self.find_user_role(role)
    case role
      when "student"
        ROLES[0]
      when "parent"
        ROLES[1]
      when "school administration"
        ROLES[2]
      when "professor"
        ROLES[3]
    end
  end
  
  def self.find_student_role
    find_user_role("student")
  end
  
  def self.find_parent_role
    find_user_role("parent")
  end
  
  def self.find_school_administration_role
    find_user_role("school administration")
  end
  
  def self.find_professor_role
    find_user_role "professor"
  end
  
  def self.check_cpf cpf
    if cpf.size == 11
      {'3' => '.', '7' => '.', '11' => '-'}.each{|k,v| cpf.insert(k.to_i, v)}
    end
    cpf
  end
  
  def student_monthly_grades student
    #student.monthly_grades.where(:year=>Date.today.year)
    student.monthly_grades.group_by {|grade| grade.year}.sort.last[1]
  end
  
  def professor_grades
    GradeFromExcel.where(:professor_email => self.email)
  end
  
end
