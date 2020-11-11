class AddLegacyTagToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :legacy_tag, :string
  end
end
