class AddSectionToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :section_id, :integer
  end
end
