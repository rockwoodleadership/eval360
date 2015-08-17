ActiveAdmin.register Section do
  permit_params :header
  navigation_menu :default
  menu false
  config.breadcrumb = false

  config.filters = false

  actions :index, :show, :edit, :update

  form do |f|
    f.inputs do
      f.input :header
    end
    f.actions
  end

  index do
    column :header
    actions
  end

  show  do |section|
    attributes_table do
      row :header
    end
     
    panel "Questions" do
      table_for section.questions do
        column "Question Text" do |question|
          question.description
        end 
        column "Question Type" do |question|
          question.answer_type
        end
        column "Actions" do |question|
          link_to("View", admin_questionnaire_section_question_path(section.questionnaire, section, question)) + "   " + link_to("Edit", edit_admin_questionnaire_section_question_path(section.questionnaire, section, question)) 
        end
      end
    end

  end

end
