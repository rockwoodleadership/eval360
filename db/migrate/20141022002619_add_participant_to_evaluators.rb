class AddParticipantToEvaluators < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluators, :participant_id, :integer  
  end
end
