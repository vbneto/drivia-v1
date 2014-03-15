ActiveAdmin.register School do
  member_action :upload_student_csv do
  end
  
  member_action :upload_grade_csv do
  end
  
  member_action :import_school_csv, :method => :post do
    already_present_students = StudentFromExcel.student_list(params[:file],params[:id])
    flash[:notice] = "List of students imported."
    if already_present_students.size > 0
      flash[:notice] = "This are the CPF which is either already present or invalid "+ already_present_students.join(", ")
    end
    redirect_to action: :index
  end
  
  member_action :import_grade_csv, :method => :post do
    already_present_grades = GradeFromExcel.grade_list(params[:file],params[:id])
    flash[:notice] = "List of grades imported."
    if already_present_grades.size > 0
      flash[:notice] = "This are the grades which is already present "+ already_present_grades.join(", ")
    end
    redirect_to action: :index
  end
  
  index do
    column :name
    column "Upload Students" do |school|
      link_to "Upload students CSV", upload_student_csv_admin_school_path(school)
    end
    column "Upload Grade/professors List" do |school|
      link_to "Upload Grade/professors CSV", upload_grade_csv_admin_school_path(school)
    end
    default_actions
  end
  filter :name
  
end

