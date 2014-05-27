ActiveAdmin.register School do
  member_action :upload_student_csv do
  end
  
  member_action :upload_grade_csv do
  end
  
  member_action :student_first_access_sheet do
    @student_details = School.students(params[:id])
  end
  
  member_action :professor_first_access_sheet do
    @professor_details = School.professor_details(params[:id]).select([:name, :code]).uniq
  end
  
  member_action :download_student_first_access_sheet do
    @student_details = School.students(params[:id])
    respond_to do |format|
      format.xls
    end
  end
  
  member_action :download_professor_first_access_sheet do
    @professor_details = School.professor_details(params[:id]).select([:name, :code]).uniq
    respond_to do |format|
      format.xls
    end
  end
  
  member_action :import_school_csv, :method => :post do
    already_present_students = StudentFromExcel.student_list(params[:file], params[:id])
    flash[:notice] = "List of students imported."
    if already_present_students.size > 0
      flash[:notice] = "This are the Students which is either already present or invalid "+ already_present_students.join(", ")
    end
    redirect_to student_first_access_sheet_admin_school_path
  end
  
  member_action :import_grade_csv, :method => :post do
    already_present_grades = SchoolGrade.grade_list(params[:file], params[:id])
    flash[:notice] = "List of grades imported."
    if already_present_grades.size > 0
      flash[:notice] = "This are the grades which is already present "+ already_present_grades.join(", ")
    end
    redirect_to professor_first_access_sheet_admin_school_path
  end
  
  index do
    column :name
    column "Upload Students" do |school|
      link_to "Upload students CSV", upload_student_csv_admin_school_path(school)
    end
    column "Upload Grade/professors List" do |school|
      link_to "Upload Grade/professors CSV", upload_grade_csv_admin_school_path(school)
    end
    column "student first access sheet" do |school|
      link_to "Display student first access sheet",student_first_access_sheet_admin_school_path(school)
    end
    column "professor first access sheet" do |school|
      link_to "professor first access sheet", professor_first_access_sheet_admin_school_path(school)
    end
    default_actions
  end
  
  form do |f|
    f.inputs "Details" do
      f.input :name
      f.input :school_average
    end
    f.has_many :student_from_excels do |student|
      student.inputs "Students" do
        student.input :student_name 
        student.input :code 
        student.input :birth_day
        student.inputs "gender" do
          student.collection_select :gender, ['male','female'], :to_s, :humanize
        end  
        student.input :current_grade
        student.inputs "status" do
          student.collection_select :status, STUDENT_STATUS, :to_s, :humanize
        end  
        #repeat as necessary for all fields
      end
      student.buttons
    end
    f.buttons
  end
  
  filter :name
  
end

