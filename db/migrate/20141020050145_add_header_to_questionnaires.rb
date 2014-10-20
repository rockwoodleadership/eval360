class AddHeaderToQuestionnaires < ActiveRecord::Migration
  def change
    add_column :questionnaires, :header, :text
  end
end
