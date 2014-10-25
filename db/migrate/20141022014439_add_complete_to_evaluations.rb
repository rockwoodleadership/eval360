class AddCompleteToEvaluations < ActiveRecord::Migration
  def change
    add_column :evaluations, :complete, :boolean
  end
end
