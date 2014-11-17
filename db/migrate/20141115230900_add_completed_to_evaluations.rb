class AddCompletedToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :completed, :boolean
    remove_column :evaluations, :status
  end
end
