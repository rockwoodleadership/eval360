class AddSelfEvalToEvaluation < ActiveRecord::Migration
  def change
    add_column :evaluations, :self_eval, :boolean, default: false
  end
end
