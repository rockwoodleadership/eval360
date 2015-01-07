class RemoveLocationFromTrainings < ActiveRecord::Migration
  def change
    remove_column :trainings, :location, :string
  end
end
