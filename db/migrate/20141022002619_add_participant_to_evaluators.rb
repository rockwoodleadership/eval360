class AddParticipantToEvaluators < ActiveRecord::Migration
  def change
    add_column :evaluators, :participant_id, :integer  
  end
end
