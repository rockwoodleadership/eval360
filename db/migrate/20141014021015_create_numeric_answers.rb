class CreateNumericAnswers < ActiveRecord::Migration
  def change
    create_table :numeric_answers do |t|
      t.integer :response

      t.timestamps
    end
  end
end
