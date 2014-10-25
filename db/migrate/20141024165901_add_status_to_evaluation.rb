class AddStatusToEvaluation < ActiveRecord::Migration
  def change
    add_column :evaluations, :status, :string
  end
end
