class Zonename < ActiveRecord::Base
  attr_accessible :name, :last_edit_user_id, :ttl
  has_and_belongs_to_many :users
  has_many :xfr
  has_many :records
  has_one :soa_record, :class_name => 'SOA', :dependent => :destroy
  has_many :ns_records, :class_name => 'NS'
  has_many :a_records, :class_name => 'A'
  has_many :aaaa_records, :class_name => 'AAAA'
  has_many :mx_records, :class_name => 'MX'
  has_many :cname_records, :class_name => 'CNAME'
  has_many :txt_records, :class_name => 'TXT'
  has_many :ptr_records, :class_name => 'PTR'
  has_many :disabled_records
### Temporary disabled for importing zones
  validates :name, :presence => true, :uniqueness => true, :format => /^[a-z,0-9,\-,_]+\.*[a-z,0-9,\-,_]+\.*[a-z,0-9,\-,_]*\.*[a-z,0-9,\-,_]*\.*[a-z,0-9,\-,_]*\.[a-z,0-9,\-,_]*$/
###
  after_update  :check_changes
  after_create :create_xfr
  after_update :update_ref
  private

  def create_xfr
    ips = []
    i = 1
    while i < 255 do
      ips << "172.16.1.#{i}"
      i = i + 1
    end
    ips.each do |ip|
      self.xfr.create(:zone => self.name, :client => ip)
    end
  end

  def check_changes
    if self.name != self.name_was
      zone = self
      soa = zone.soa_record
      soa.zone = self.name
      soa.serial = Time.now.to_i
      soa.save!
      records = zone.records.where("record_type != 'SOA'")
      records.each do |rec|
        rec.zone = self.name
        rec.save!
      end
    end
  end

  def update_ref
    zone = self
    zone.records.each do |rec|
      ttl = zone.soa_record.ttl
      zone.records.each do |rec|
        if rec.ttl.to_i != ttl.to_i
          rec.update_column(:ttl, ttl)
          rec.update_column(:zone, zone.name)
        end
      end
    end
    soa = zone.soa_record
    soa.update_column(:serial, Time.now.to_i)
    HardWorker.perform_async(zone.id)
  end
end
