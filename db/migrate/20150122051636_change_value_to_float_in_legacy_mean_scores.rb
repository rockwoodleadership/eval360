class ChangeValueToFloatInLegacyMeanScores < ActiveRecord::Migration
  def up
   change_column :legacy_mean_scores, :value, 'float USING CAST(value AS float)' 
  end

  def down
    change_column :leagcy_mean_scores, :value, 'string USING CAST(value AS string)'
  end
end
