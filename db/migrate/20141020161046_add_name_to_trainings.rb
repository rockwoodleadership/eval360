class AddNameToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :name, :string
  end
end
