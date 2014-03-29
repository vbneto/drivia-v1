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
  
  def self.check_cpf cpf
    if cpf.size == 11
      {'3' => '.', '7' => '.', '11' => '-'}.each{|k,v| cpf.insert(k.to_i, v)}
    end
    cpf
  end
  
  def get_student_grades
    case role
    when "student"
      self.find_student.monthly_grades.where(:year=>Date.today.year)
    when "parent"
      self.find_students.first.monthly_grades.where(:year=>Date.today.year)
    when "professor"
      GradeFromExcel.where(:professor_email => self.email)
    else
      []
    end
  end
  
  def find_student
    self.student.student_from_excel
  end 
  
  def find_students
    self.parent.student_from_excels
  end

end
