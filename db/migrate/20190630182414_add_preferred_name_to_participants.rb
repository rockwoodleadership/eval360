class AddPreferredNameToParticipants < ActiveRecord::Migration[5.1]
  def change
    add_column :participants, :preferred_name, :string
  end
end
