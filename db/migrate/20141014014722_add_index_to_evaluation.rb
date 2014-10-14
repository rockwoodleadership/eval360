class AddIndexToEvaluation < ActiveRecord::Migration
  def change
    add_index :evaluations, :access_key
  end
end
