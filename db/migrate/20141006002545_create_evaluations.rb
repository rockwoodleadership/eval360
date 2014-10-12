class CreateEvaluations < ActiveRecord::Migration
  def change
    create_table :evaluations do |t|
      t.integer :participant_id
      t.integer :evaluator_id
      t.string :access_key

      t.timestamps
    end
  end
end
