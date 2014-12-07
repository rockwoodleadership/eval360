class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.text :header

      t.timestamps
    end
  end
end
