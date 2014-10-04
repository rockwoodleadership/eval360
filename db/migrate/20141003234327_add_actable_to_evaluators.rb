class AddActableToEvaluators < ActiveRecord::Migration
  def change
    change_table :evaluators do |t|
      t.actable
    end
  end
end
