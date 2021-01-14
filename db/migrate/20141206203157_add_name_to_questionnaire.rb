class AddNameToQuestionnaire < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :name, :string
  end
end
