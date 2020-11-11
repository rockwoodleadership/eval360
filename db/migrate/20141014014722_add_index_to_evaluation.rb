class AddIndexToEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_index :evaluations, :access_key
  end
end
