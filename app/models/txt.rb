class TXT < Record
  attr_accessible :ttl, :host, :zone, :data
  before_save :check_blank_value
  private
  def check_blank_value
    if self.host.blank?
      self.host = '@'
    end
  end
end