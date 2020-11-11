class AddEvaluatorToEvaluations < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :evaluator_id, :integer
  end
end
