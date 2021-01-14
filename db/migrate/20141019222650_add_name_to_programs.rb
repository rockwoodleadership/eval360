class AddNameToPrograms < ActiveRecord::Migration[5.0]
  def change
    add_column :programs, :name, :string
  end
end
