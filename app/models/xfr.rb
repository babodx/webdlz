class Xfr < ActiveRecord::Base
  set_table_name "xfr_table"
  attr_accessible :zone, :client
  belongs_to :zonename
end