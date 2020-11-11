class RemoveHeaderFromQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    remove_column :questionnaires, :header, :string
  end
end
