class AddResponsesToAnswers < ActiveRecord::Migration[5.0]
  def change
    add_column :answers, :numeric_response, :integer
    add_column :answers, :text_response, :text
    remove_column :answers, :actable_id
    remove_column :answers, :actable_type
  end
end
