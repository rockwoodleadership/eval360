class RemoveCompletedFromEvaluation < ActiveRecord::Migration[5.0]
  def change
    remove_column :evaluations, :complete, :string
  end
end
