class AddDeclinedToEvaluators < ActiveRecord::Migration
  def change
    add_column :evaluators, :declined, :boolean, default: false
  end
end
