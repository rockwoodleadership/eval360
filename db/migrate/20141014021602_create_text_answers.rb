class CreateTextAnswers < ActiveRecord::Migration
  def change
    create_table :text_answers do |t|
      t.text :response

      t.timestamps
    end
  end
end
