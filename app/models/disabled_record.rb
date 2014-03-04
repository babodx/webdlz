class DisabledRecord < ActiveRecord::Base
  attr_accessible :zone, :host, :ttl, :mx_priority, :data, :resp_person, :serial, :refresh, :retry, :expire, :minimum, :record_type, :user_id, :last_edit_time, :created_time, :zonename_id
end
