class NS < Record
  attr_accessible :ttl, :host, :zone, :data
  before_save :check_blank_value
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