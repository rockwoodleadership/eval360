class AddTrainingToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :training_id, :integer
  end
end
