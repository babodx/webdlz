class HardWorker
  include Sidekiq::Worker
  def perform(id)
    zone = Zonename.find(id)
    raise CustomExceptions, "Zone Not Found" if zone.nil?
    system("/usr/bin/send_dns_notify -z #{zone.name} -s 172.16.1.46")
  end
end