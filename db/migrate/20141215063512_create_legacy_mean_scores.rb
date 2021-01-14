class CreateLegacyMeanScores < ActiveRecord::Migration[5.0]
  def change
    create_table :legacy_mean_scores do |t|
      t.string :key
      t.string :value
      t.string :questionnaire_tag

      t.timestamps
    end

    add_index(:legacy_mean_scores, :key, using: 'btree')
  end
end
