class AddDontRemindToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :do_not_remind, :boolean, default: false
  end
end
