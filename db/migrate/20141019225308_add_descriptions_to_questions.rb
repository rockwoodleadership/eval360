class AddDescriptionsToQuestions < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :description, :text
    add_column :questions, :self_description, :text
  end
end
