class RemoveLocationFromTrainings < ActiveRecord::Migration[5.0]
  def change
    remove_column :trainings, :location, :string
  end
end
