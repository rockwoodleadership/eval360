class AddStartDateToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :start_date, :datetime
  end
end
