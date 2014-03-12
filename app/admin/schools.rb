ActiveAdmin.register School do
  action_item :only => [:new, :edit] do
    link_to 'Upload CSV', :action => 'upload_csv'
  end

  collection_action :upload_csv do
    
  end
  
  collection_action :import_csv, :method => :post do
    User.import(params)
    redirect_to :action => :index, :notice => "CSV imported successfully!"
  end
end

