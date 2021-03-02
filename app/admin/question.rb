ActiveAdmin.register Question do
  permit_params :section_id, :answer_type, :description, :self_description

  actions :index, :show, :edit, :update, :new, :create, :destroy

  controller do
    nested_belongs_to :questionnaire, :section
  end
  config.filters = false
  navigation_menu :default
  menu false

  config.breadcrumb = false 

  index do
    column "Question Text" do |question|
      question.description
    end 
    column "Question Type" do |question|
      question.answer_type
    end
    actions
  end

  show do |question|
    attributes_table do
      row :answer_type
      row :description
      row :self_description
      row :legacy_tag
    end
    div do
      link_to("Back to Assessment", admin_assessment_path(questionnaire))
    end
  end

  form do |f|
    f.inputs "Details" do
      f.input :answer_type, :as => :select, :collection => ["numeric", "text"]
      f.input :description
      f.input :self_description
    end
    f.actions
  end


end
