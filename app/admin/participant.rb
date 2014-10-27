ActiveAdmin.register Participant do
  permit_params :training_id, :first_name, :last_name, :email

  controller do
    def resource
      Participant.find_by_access_key(params[:id])
    end
  end
  form do |f|
    f.inputs do
      f.input :training
      f.input :first_name
      f.input :last_name
      f.input :email
    end
    f.actions
  end


  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if resource.something?
  #   permitted
  # end


end
