class AddDontRemindToParticipants < ActiveRecord::Migration[5.0]
  def change
    add_column :participants, :do_not_remind, :boolean, default: false
  end
end
