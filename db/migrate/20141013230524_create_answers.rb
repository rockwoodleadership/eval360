class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.integer :evaluation_id
      t.integer :actable_id
      t.string :actable_type

      t.timestamps
    end
  end
end
