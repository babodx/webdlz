class PTR < Record
  attr_accessible :ttl, :host, :zone, :data
  before_save :check_blank_value
  validates :data, :presence => true
  #, :format => /^[a-zA-Z0-9][a-zA-Z0-9-]{1,61}[a-zA-Z0-9]\.[a-zA-Z]{2,4}\.$/
  private
  def check_blank_value
    if self.host.blank?
      self.host = '@'
    end
  end
end