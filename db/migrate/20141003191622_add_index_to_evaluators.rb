class AddIndexToEvaluators < ActiveRecord::Migration[5.0]
  def change
    add_index :evaluators, [:meta_id, :meta_type]
  end
end
