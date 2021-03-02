ActiveAdmin.register Questionnaire, as: "Assessment" do
  permit_params :name, sections_attributes: [:id, :header, questions_attributes: [:id, :answer_type, :description, :self_description ]]  

  actions :index, :show, :edit, :update, :new, :create, :destroy

  config.filters = false
  index do
    selectable_column
    column :name
    column :id
    column :created_at
    actions
  end

  menu priority: 5, label: "Assessments"

  form do |f|
    f.inputs do
      f.input :name, label: "Title of Assessment"
    end

    f.actions
  end


  show title: :name do |questionnaire|
    attributes_table do
      row :name
      row :created_at
    end
    panel "Adding Sections" do
      para link_to("New Section", new_admin_questionnaire_section_path(questionnaire))
      para link_to("Add an Existing Section", admin_questionnaire_sections_path(questionnaire))
    end 
    i = 0
    questionnaire.sections.each do |section|
      
      panel section.header do
        div do
          link_to("Edit Section Title", edit_admin_questionnaire_section_path(questionnaire, section))
        end
        table_for section.questions do
          column "Question Text" do |question|
            "#{(i=i+1).to_s}. #{question.description}"
          end 
          column "Question Type" do |question|
            question.answer_type
          end
          column "Actions" do |question|
            link_to("View", admin_questionnaire_section_question_path(questionnaire,section, question)) + "   " + link_to("Edit", edit_admin_questionnaire_section_question_path(questionnaire, section, question))  + "   " + link_to("Delete", admin_questionnaire_section_question_path(questionnaire, section, question))
          end
        end
        para link_to("New Question", new_admin_questionnaire_section_question_path(questionnaire,section))
      end
    end
      para link_to("Back to all Sections", admin_sections_path)
      para link_to("Back to all Assessments", admin_assessments_path)
  end
end
