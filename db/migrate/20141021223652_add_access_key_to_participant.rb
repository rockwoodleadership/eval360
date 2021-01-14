class AddAccessKeyToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :access_key, :string
    add_index :participants, :access_key
  end
end
