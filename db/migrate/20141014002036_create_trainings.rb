class CreateTrainings < ActiveRecord::Migration[5.0]
  def change
    create_table :trainings do |t|
      t.integer :program_id

      t.timestamps
    end
  end
end
