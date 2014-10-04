class RemoveMetaFromEvaluators < ActiveRecord::Migration
  def change
    remove_index :evaluators, [:meta_id, :meta_type]
    remove_column :evaluators, :meta_id, :string
    remove_column :evaluators, :meta_type, :string
  end
end
