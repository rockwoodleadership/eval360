class RemoveEvaluationFromEvaluators < ActiveRecord::Migration
  def change
    remove_column :evaluators, :evaluation_id, :string
  end
end
