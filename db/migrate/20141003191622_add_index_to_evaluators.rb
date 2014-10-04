class AddIndexToEvaluators < ActiveRecord::Migration
  def change
    add_index :evaluators, [:meta_id, :meta_type]
  end
end
