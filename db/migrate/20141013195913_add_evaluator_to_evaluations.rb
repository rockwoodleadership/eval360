class AddEvaluatorToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :evaluator_id, :integer
  end
end
