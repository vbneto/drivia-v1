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
  attr_accessible :email, :password, :password_confirmation, :remember_me, :parent_attributes
  attr_accessible :name, :phoneprefix, :phone
  attr_accessible :role, :name, :email, :password, :password_confirmation, :as => [:admin]
  validates :name, :presence => true
  validates :phoneprefix, length: { is: 2}, :presence => true
  validates :phone, length: { is: 9}, :presence => true
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  has_one :parent
  has_one :professor
  has_one :student
  has_one :school_administration
  has_one :student_from_excel, :through => :student
  
  accepts_nested_attributes_for :parent #for updation in parent
  #accepts_nested_attributes_for :student, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
=begin
  #Remove comment when not allowing deactivate student and parent to signin. 
  def active_for_authentication?
    if self.is_student? 
      super && check_student_status(self) 
    elsif self.is_parent?
      super && check_parent_status(self)
    else
      super  
    end
  end

  def inactive_message
    if self.is_student? || self.is_parent?
      "Sorry, this account has been deactivated, please contact to school administration."
    else
      super
    end  
  end
  
  def check_student_status user
    user.student.student_from_excel.status == User.student_active ? true : false  
  end
  
  def check_parent_status user
    user.parent.student_from_excels.map(&:status).select{|status| status == User.student_active}.size > 0 ? true : false
  end
=end  
  
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
  
  def is_school_administration?
    self.role=="school administration"
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
  
  def student_monthly_grades(student,student_status)
    unless student_status.blank?
      student_monthly_grade = student_status.monthly_grades 
      student_monthly_grade.group_by {|grade| grade.year}.sort.last[1] unless student_monthly_grade.blank?  
    end
  end
  
  def professor_grades
    GradeFromExcel.where(:professor_email => self.email)
  end
  
  def self.student_active
    STUDENT_STATUS[0]
  end
  
  def self.student_deactive
    STUDENT_STATUS[1]
  end
end
