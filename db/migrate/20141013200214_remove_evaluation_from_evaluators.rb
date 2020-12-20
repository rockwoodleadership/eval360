class RemoveEvaluationFromEvaluators < ActiveRecord::Migration[5.0]
  def change
    remove_column :evaluators, :evaluation_id, :string
  end
end
