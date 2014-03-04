class SOA < Record
  attr_accessible :data, :zone, :host, :ttl, :resp_person, :serial, :refresh, :retry, :expire, :minimum
  ### Temporary disabled for zone importing
  after_create :creation_ns_records
  ###
  private
    def creation_ns_records
      @zone = self.zonename
      Nameserver.all.each do |nameserv|
        @zone.ns_records.build(:data => nameserv.name, :ttl => self.ttl, :host => '@', :zone => @zone.name)
        @zone.save
      end
    end
end