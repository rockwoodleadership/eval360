class AddIntroTextToQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    add_column :questionnaires, :self_intro_text, :text
    add_column :questionnaires, :intro_text, :text
  end
end
