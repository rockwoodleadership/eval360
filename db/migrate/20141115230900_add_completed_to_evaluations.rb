class AddCompletedToEvaluations < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :completed, :boolean
    remove_column :evaluations, :status
  end
end
