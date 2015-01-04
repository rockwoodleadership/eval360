class AddCurriculumToTrainings < ActiveRecord::Migration
  def change
    add_column :trainings, :curriculum, :string
    add_column :trainings, :site_name, :string
  end
end
