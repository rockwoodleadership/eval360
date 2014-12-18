class LegacyMeanScores < ActiveRecord::Base

  def self.mean_scores(key)
    return unless key
    self.where(key: key).map {|score| score.value.to_f}
  end
end
