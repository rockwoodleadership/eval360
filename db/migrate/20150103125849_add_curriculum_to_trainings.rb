class AddCurriculumToTrainings < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :curriculum, :string
    add_column :trainings, :site_name, :string
  end
end
