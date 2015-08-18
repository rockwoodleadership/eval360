class AddNoInviteToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :no_invite, :boolean, default: false
  end
end
