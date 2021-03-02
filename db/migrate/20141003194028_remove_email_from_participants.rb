class RemoveEmailFromParticipants < ActiveRecord::Migration[5.0]
  def change
    remove_column :participants, :email, :string
  end
end
