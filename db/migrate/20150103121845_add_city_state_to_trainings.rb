class AddCityStateToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :city, :string
    add_column :trainings, :state, :string
    add_column :trainings, :deadline, :datetime
  end
end
