class Evaluation < ActiveRecord::Base
  belongs_to :evaluator
  belongs_to :participant
  validates_uniqueness_of :access_key

  before_validation :set_access_key, on: :create
  
  def to_param
    access_key
  end
  

  private
  
    def set_access_key
      return if access_key.present?

      begin
        self.access_key = SecureRandom.hex(8)
      end while self.class.exists?(access_key: self.access_key)
    end

end
