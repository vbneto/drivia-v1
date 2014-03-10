ActiveAdmin.register User do
    index do
      column "Name", :sortable => :name do |user|
        user.name
      end
      column :email, :sortable => :email do |user|
        user.email
      end
      column :role, :sortable => :role do |user|
        user.role
      end
      default_actions
    end
  
  form do |f|
    f.inputs "User Details" do
      f.input :name
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.inputs "Role" do
      f.collection_select :role, User::ROLES, :to_s, :humanize
    end  
    f.buttons
  end
  
  show do |user|
    attributes_table do
      row :name do
        user.name
      end
      row :email
    end
    active_admin_comments
  end
  
  ActiveAdmin.register User do
    controller { with_role :admin }
  end
  
  filter :name
  filter :email

end
