class AddSelfEvalToEvaluation < ActiveRecord::Migration[5.0]
  def change
    add_column :evaluations, :self_eval, :boolean, default: false
  end
end
