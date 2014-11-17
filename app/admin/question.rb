ActiveAdmin.register Question do
  menu false
  permit_params :questionnaire, :answer_type, :decription, :self_description

  show do |question|
    attributes_table do
      row :questionnaire
      row :answer_type
      row :description
      row :self_description
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :questionnaire, :as => :select, :collection =>Hash[Questionnaire.all.map{|q| [q.program.name, q.id]}] 
      f.input :answer_type, :as => :select, :collection => ["numeric", "text"]
      f.input :description
      f.input :self_description
    end
    f.actions
  end


end
