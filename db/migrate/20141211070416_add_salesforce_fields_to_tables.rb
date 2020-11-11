class AddSalesforceFieldsToTables < ActiveRecord::Migration[5.0]
  def change
    add_column :trainings, :sf_training_id, :string
    add_column :participants, :sf_registration_id, :string
    add_column :participants, :sf_contact_id, :string 
  end
end
