class MX < Record
  attr_accessible :ttl, :host, :zone, :mx_priority, :data
  before_save :check_blank_value
  validates :data, :presence => true
  validates :data, :presence => true, :format => /^\d+$/
  private
  def check_blank_value
    if self.host.blank?
      self.host = '@'
    end
    if self.data.split("").last != '.'
      self.data = "#{self.data}."
    end
  end
end