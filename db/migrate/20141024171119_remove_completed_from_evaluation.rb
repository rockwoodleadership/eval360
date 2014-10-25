class RemoveCompletedFromEvaluation < ActiveRecord::Migration
  def change
    remove_column :evaluations, :complete, :string
  end
end
