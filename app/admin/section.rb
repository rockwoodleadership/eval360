ActiveAdmin.register Section do
  config.create_another = true
  permit_params :id,  :header, questionnaire_templates_attributes: [:id, :questionnaire_id, :section_id, :_destroy], questions_attributes: [:id, :answer_type, :description, :self_description]

  navigation_menu :default
  menu false
  config.breadcrumb = false

  config.filters = false

actions :index, :show, :edit, :update, :new, :create, :destroy

  form do |f|
    f.semantic_errors *f.object.errors.keys
    f.inputs 'New Section Details' do
      f.input :header, label: "Title of Section"
      f.has_many :questionnaire_templates, allow_destroy: true do |n_f|
        n_f.input :questionnaire, label: "Add to which existing questionnaire?"
        #n_f.actions :submit, label: "Add to Questionnaire" 
        #Can We figure out how to rename these action buttons? 
        #Figure out how to hide 'Create another section" checkbox' 
        #When it's clicked, the section gets created, but then it's brought back to the new section page
      end
    end
     f.actions
  end

  index do
    selectable_column
    column "Section Name" do |section|
      section.header
    end
    column :id 
    column :created_at
    column "Appears on: " do |section|
        section.questionnaires.map { |q| q.name }.join(", ").html_safe
    end
    #column "Add to Questionnaire" do |questionnaire|
     # link_to questionnaire_id, admin_assessment_path(questionnaire)
    #check_box works
    #end
    actions
  end

  show  do |section|
    attributes_table do
      row "Name" do
        section.header
      end
      row "Appears on: " do |section|
        section.questionnaires.map { |q| q.name }.join(", ").html_safe
      end
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
          link_to("View", admin_questionnaire_section_question_path(section, question)) + "   " + link_to("Edit", edit_admin_questionnaire_section_question_path(section, question))
          #  + "   " + link_to("Delete", admin_questionnaire_section_question_path(section, question), data: { confirm: "Are you sure you want to delete this section?" }, method: :delete)
          #working on adding this
        end
      end
    end

    panel "Links" do

      para link_to("Back to Sections", admin_sections_path)
      para link_to("Back to Assessments", admin_assessments_path)
    end
  end

end
