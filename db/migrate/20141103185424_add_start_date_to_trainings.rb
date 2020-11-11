class AddStartDateToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :start_date, :datetime
  end
end
