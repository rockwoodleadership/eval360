class AddNoInviteToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :no_invite, :boolean, default: false
  end
end
