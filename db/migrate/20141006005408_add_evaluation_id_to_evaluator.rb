class AddEvaluationIdToEvaluator < ActiveRecord::Migration
  def change
    add_column :evaluators, :evaluation_id, :integer
  end
end
