ActiveAdmin.register Program do
  permit_params :name

  actions :index, :show

  menu priority: 4

  config.filters = false
  index do
    selectable_column
    column :name
    actions
  end 

  show do |program|
    panel "Training Events" do
      table_for program.trainings do
        column :name
        column :start_date
        column "# of Participants" do |training|
          training.participants.count
        end
        column "Actions " do |training|
          link_to "View", admin_training_path(training)
        end
      end
    end
  end
end
