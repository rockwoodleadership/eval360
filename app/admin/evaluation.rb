ActiveAdmin.register Evaluation do
  controller do
    defaults finder: :find_by_access_key
  end

  filter :evaluator, :as => :string, label: "Evaluator Email", :collection => Evaluator.all.map(&:email)
  filter :participant
  filter :status

  index do 
    selectable_column
    column "Evaluator" do |evaluation|
      evaluation.evaluator.email
    end
    column "Participant" do |evaluation|
      evaluation.participant.full_name
    end
    column "Type" do |evaluation|
      if evaluation.self_eval?
        "Self Evaluation"
      else
        "Peer Evaluation"
      end
    end
    column :status
    column :updated_at
    actions
  end

  show do |evaluation|
    attributes_table do
      row :participant do
        link_to evaluation.participant.full_name, admin_participant_path(evaluation.participant)
      end
      row :evaluator
      row :status
      row "Type" do
        if evaluation.self_eval?
          "Self Evaluation"
        else
          "Peer Evaluation"
        end
      end
      row "Evaluation Url" do
        evaluation_edit_url(evaluation)
      end
    end
    panel "Evaluation Responses" do
      evaluation.answers.each do |answer|
        if evaluation.self_eval?
          h5 answer.question.self_description
        else
          h5 answer.question.description
        end 
        div :class => "response" do
          answer.response 
        end
      end
    end
  end




end
