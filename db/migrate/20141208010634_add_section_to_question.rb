class AddSectionToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :section_id, :integer
  end
end
