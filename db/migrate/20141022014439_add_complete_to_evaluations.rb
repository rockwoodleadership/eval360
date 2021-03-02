class AddCompleteToEvaluations < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :complete, :boolean
  end
end
