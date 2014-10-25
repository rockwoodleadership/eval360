module AccessKeys
  extend ActiveSupport::Concerns


  def to_param
    access_key
  end

  def set_access_key
    return if access_key.present?

    begin
      self.access_key = SecureRandom.hex(8)
    end while self.class.exists?(access_key: self.access_key)
  end
end
