class AddDeclinedToEvaluators < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluators, :declined, :boolean, default: false
  end
end
