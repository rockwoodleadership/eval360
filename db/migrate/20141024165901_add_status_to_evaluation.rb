class AddStatusToEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :status, :string
  end
end
