class RemovePrograms < ActiveRecord::Migration[5.0]
  def up
    remove_column :questionnaires, :program_id
    remove_column :trainings, :program_id
    drop_table :programs
  end

  def down
    create_table :programs do |t|
      t.string :name
    end 
    add_column :questionnaires, :program_id
    add_column :trainings, :program_id
  end
end
