class AAAA < Record
  attr_accessible :data, :zone, :host, :ttl
  before_save :check_blank_value
  private
  def check_blank_value
    if self.host.blank?
      self.host = '@'
    end
  end
end