class CreateNumericAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :numeric_answers do |t|
      t.integer :response

      t.timestamps
    end
  end
end
