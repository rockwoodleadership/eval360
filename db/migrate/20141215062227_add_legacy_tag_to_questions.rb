class AddLegacyTagToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :legacy_tag, :string
  end
end
