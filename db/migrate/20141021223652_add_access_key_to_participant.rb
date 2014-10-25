class AddAccessKeyToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :access_key, :string
    add_index :participants, :access_key
  end
end
