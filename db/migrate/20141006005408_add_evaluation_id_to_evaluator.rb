class AddEvaluationIdToEvaluator < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluators, :evaluation_id, :integer
  end
end
