class AddHeaderToQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :header, :text
  end
end
