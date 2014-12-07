class RemoveHeaderFromQuestionnaire < ActiveRecord::Migration
  def change
    remove_column :questionnaires, :header, :string
  end
end
