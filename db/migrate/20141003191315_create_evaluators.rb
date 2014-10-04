class CreateEvaluators < ActiveRecord::Migration
  def change
    create_table :evaluators do |t|
      t.string :email
      t.integer :meta_id
      t.string :meta_type

      t.timestamps
    end
  end
end
