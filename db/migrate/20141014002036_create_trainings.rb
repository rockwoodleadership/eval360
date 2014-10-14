class CreateTrainings < ActiveRecord::Migration
  def change
    create_table :trainings do |t|
      t.integer :program_id

      t.timestamps
    end
  end
end
