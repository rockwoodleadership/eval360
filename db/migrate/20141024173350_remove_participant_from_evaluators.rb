class RemoveParticipantFromEvaluators < ActiveRecord::Migration[5.0]
  def change
    remove_column :evaluators, :participant_id, :string
  end
end
