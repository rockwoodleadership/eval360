class AddNameToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :name, :string
  end
end
