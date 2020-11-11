class AddActableToEvaluators < ActiveRecord::Migration[5.0]
  def change
    change_table :evaluators do |t|
      t.actable
    end
  end
end
