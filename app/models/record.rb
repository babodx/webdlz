class Record < ActiveRecord::Base
  attr_accessible :zone, :host, :ttl, :mx_priority, :data, :resp_person, :serial, :refresh, :retry, :expire, :minimum, :record_type, :user_id, :last_edit_time, :created_time, :zonename_id
  belongs_to :zonename
  set_inheritance_column :record_type
  attr_accessible :data, :record_type
  after_update :update_serial
  after_create :update_serial
  after_destroy :update_serial
  default_scope order: 'host ASC'

  #validates :data, :presence => true, :format => /^[a-z,0-9,\-,_@]+\.*[a-z,0-9,\-,_]+\.*$/
  #validates :data, :presence => true, :format => /^[a-z,0-9,\-,_@\.]+$/

  #####
  ##validates :data, :presence => true, :format => /^[a-z,0-9,\-,_]+\.*[a-z,0-9,\-,_]+\.*[a-z,0-9,\-,_]*\.*[a-z,0-9,\-,_]*\.*[a-z,0-9,\-,_]*\.[a-z,0-9,\-,_]*$/
  #####

  #validates :host, :presence => true, :format => /^[a-z,0-9,\-,_@]+\.*[a-z,0-9,\-,_]+\.*$/
  #validates :host, :format => /^[a-z,0-9,\-,_]+\.*[a-z,0-9,\-,_]+\.*[a-z,0-9,\-,_]*\.*[a-z,0-9,\-,_]*\.*[a-z,0-9,\-,_]*\.[a-z,0-9,\-,_]*$/, :allow_blank => true
  #validates :host, :presence => true, :format => /^[a-z,0-9,\-,_@\.]+$/

  private

  def update_serial
    if self.record_type != "SOA"
      zone = self.zonename
      zone.soa_record.serial = Time.now.to_i
      zone.soa_record.save
      Rails.logger.info("Performing async job")
      HardWorker.perform_async(zone.id)
    end
  end
end
