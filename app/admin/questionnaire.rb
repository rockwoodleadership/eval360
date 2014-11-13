ActiveAdmin.register Questionnaire do
  permit_params :program_id, :header, :self_intro_text, :intro_text

  config.filters = false
  index do
    selectable_column
    column :program
    actions
  end


  show title: :admin_title do |questionnaire|
    attributes_table do
      row :program
      row :header
      row :self_intro_text
      row :intro_text
    end

    panel "Questions" do
      table_for questionnaire.questions do
        column "Question Text" do |question|
          question.description
        end 
        column "Actions" do |question|
          link_to("View", admin_question_path(question)) + "   " + link_to("Edit", edit_admin_question_path(question))
        end
      end

    end
  end


end
