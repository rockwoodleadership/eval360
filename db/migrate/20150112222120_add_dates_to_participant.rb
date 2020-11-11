class AddDatesToParticipant < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :assessment_sent_date, :date
    add_column :participants, :peer_assessment_sent_date, :date
    add_column :participants, :reminder_for_peer_assessment_sent_date, :date
    add_column :participants, :assessment_reminder_sent_date, :date
    add_column :participants, :assessment_complete_date, :date
  end
end
