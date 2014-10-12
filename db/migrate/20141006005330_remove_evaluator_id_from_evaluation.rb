class RemoveEvaluatorIdFromEvaluation < ActiveRecord::Migration
  def change
    remove_column :evaluations, :evaluator_id, :string
  end
end
