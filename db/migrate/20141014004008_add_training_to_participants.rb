class AddTrainingToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :training_id, :integer
  end
end
