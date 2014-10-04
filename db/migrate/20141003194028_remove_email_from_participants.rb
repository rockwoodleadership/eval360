class RemoveEmailFromParticipants < ActiveRecord::Migration
  def change
    remove_column :participants, :email, :string
  end
end
