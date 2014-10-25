class RemoveParticipantFromEvaluators < ActiveRecord::Migration
  def change
    remove_column :evaluators, :participant_id, :string
  end
end
