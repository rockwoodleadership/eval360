class RemoveEvaluatorIdFromEvaluation < ActiveRecord::Migration[5.0]
  def change
    remove_column :evaluations, :evaluator_id, :string
  end
end
