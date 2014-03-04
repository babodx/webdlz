class A < Record
  attr_accessible :data, :zone, :host, :ttl
  before_save :check_blank_value
  validates :data, :presence => true, :format => /^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/
  private
  def check_blank_value
    if self.host.blank?
      self.host = '@'
    end
  end
end