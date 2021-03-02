class CreateQuestionnaires < ActiveRecord::Migration[5.0]
  def change
    create_table :questionnaires do |t|
      t.integer :program_id

      t.timestamps
    end
  end
end
