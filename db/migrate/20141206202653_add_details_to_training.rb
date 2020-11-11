class AddDetailsToTraining < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :end_date, :datetime
    add_column :trainings, :location, :string
    add_column :trainings, :status, :string
  end
end
