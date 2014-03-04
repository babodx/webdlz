#!/usr/bin/ruby
require 'rubygems'
require 'json'
namespace :zones do
  desc "Importing zone and SOA records"
  task :impsoa => :environment do
    create_soa
  end

  desc "Importing all records except soa"
  task :notsoa => :environment  do
    create_all_not_soa
  end
  desc "create SOA records from custom zone file"
  task :create_soa => :environment do
    file = ARGV[1]
    create_custom_soa(file)
  end
  desc "migrate FoRU eecords"
  task :foru_job => :environment do
    create_fo_ru
  end
  desc "setting dot at end of data for cname mx ns"
  task :enddot => :environment do
    set_dot_at_end
  end
  desc "Creating xfr records"
  task :create_xfr => :environment do
    xfr_create
  end

end

def create_soa
    files=Dir.glob("/home/pavel/readyzones/*.dns")
    files.each do |file|
        npjs=`/usr/local/pdns/bin/zone2json --zone=#{file}`
        json=JSON.parse(npjs)
        json["records"].each do |line|
            if line["type"] == 'SOA'
                name = file.split("/").last.gsub(/.dns$/, '')
                #p line["content"].split(" ")
                p line["ttl"]
                req = line["content"].split(" ")
                zone = Zonename.create("name" => name)
                zone.create_soa_record(:zone => name, :ttl => line["ttl"], :resp_person => req[1], :refresh => req[3], :retry => req[4], :expire => req[5], :minimum => req[6], :host => '@', :data => req[0], :serial => req[2])
            end

        end
    end
end

def create_all_not_soa
    files=Dir.glob("/home/pavel/readyzones/*.dns")
    files.each do |file|
        npjs=`/usr/local/pdns/bin/zone2json --zone=#{file}`
        json=JSON.parse(npjs)
        json["records"].each do |line|
            if line["type"] != 'SOA'
                name = file.split("/").last.gsub(/.dns$/, '')
                zone = Zonename.find_by_name(name)
                if line["name"].nil?
                    puts "NO name #{line}"
                end
                hostname = lambda { line["name"] == "." ? "@" : line["name"].gsub(/\.$/, '') }
                pr = ""
                pr = line["prio"] if line["type"].to_s == 'MX'
                content = line["content"]
                if line["type"] == 'TXT'
                  content = line["content"].to_s.delete('"')
                end
                zone.records.create(:zone => zone.name.to_s, :record_type => line["type"], :host => hostname.call, :data => content, :ttl => line["ttl"], :mx_priority => pr)
            end
        end
    end
end

def create_custom_soa(z)
    files=Dir.glob("/home/pavel/readyzones/*.dns")
    files.each do |file|
        npjs=`/usr/local/pdns/bin/zone2json --zone=#{z}`
        json=JSON.parse(npjs)
        json["records"].each do |line|
            puts "Record: "+line.to_s
            if line["type"] == 'SOA'
                name = z.split("/").last.gsub(/.dns$/, '')
                #p line["content"].split(" ")
                p line["ttl"]
                req = line["content"].split(" ")
                p name.to_s+" "+line.to_s
                zone = Zonename.create("name" => name)
                zone.create_soa_record(:zone => name, :ttl => line["ttl"], :resp_person => req[1], :refresh => req[3], :retry => req[4], :expire => req[5], :minimum => req[6], :host => '@', :data => req[0], :serial => req[2])
            end
        end
    end
end

def create_fo_ru
  files=Dir.glob("/home/pavel/share/dns/fo.ru.dns")
  files.each do |file|
    npjs=`/usr/local/pdns/bin/zone2json --zone=#{file}`
    json=JSON.parse(npjs)
    json["records"].each do |line|
      if line["type"] == 'SOA'
        @ttl = line["ttl"]
        req = line["content"].split(" ")
        @resp_person = req[1]
        @refresh = req[3]
        @retry = req[4]
        @expire = req[5]
        @mininmum = req[6]
        @data = req[0]
        @serial = req[2]
      end
      if line["type"] == 'A'
        zon = line["name"].split('.')
        if zon[0] != '*'
          zone = Zonename.create("name" => "#{line["name"]}fo.ru")
          zone.create_soa_record(:zone => "#{line["name"]}fo.ru", :ttl => line["ttl"], :resp_person => @resp_person, :refresh => @refresh, :retry => @retry, :expire => @expire, :minimum => @mininmum, :host => '@', :data => @data, :serial => @serial)
          zone.records.create(:zone => "#{line["name"]}fo.ru", :record_type => "NS", :host => "@", :data => 'ns.molot.ru.', :ttl => '7200')
          zone.records.create(:zone => "#{line["name"]}fo.ru", :record_type => "NS", :host => "@", :data => 'ns.relsoft.ru.', :ttl => '7200')
          zone.records.create(:zone => "#{line["name"]}fo.ru", :record_type => "NS", :host => "@", :data => 'ns.relsoftcom.ru.', :ttl => '7200')
          zone.records.create(:zone => "#{line["name"]}fo.ru", :record_type => "MX", :host => "@", :data => 'mx.fo.ru.', :ttl => '7200', :mx_priority => '10')
          zone.records.create(:zone => "#{line["name"]}fo.ru", :record_type => "A", :host => "@", :data => line["content"], :ttl => '7200')
          zone.records.create(:zone => "#{line["name"]}fo.ru", :record_type => "A", :host => "*", :data => line["content"], :ttl => '7200')
        end
      end


    end
  end
end

def set_dot_at_end
  records = Record.where(:record_type => "MX")

  records.each do |record|
    lastvalue = record.data.split(//).last
    if lastvalue.to_s != "."
      puts record.data
      puts record.id
      record.data = "#{record.data.to_s}."
      record.save!
    end
  end

  records = Record.where(:record_type => "NS")

  records.each do |record|
    lastvalue = record.data.split(//).last
    if lastvalue.to_s != "."
      record.data = "#{record.data}."
      record.save!
    end
  end
  records = Record.where(:record_type => "CNAME")

  records.each do |record|
    lastvalue = record.data.split(//).last
    if lastvalue.to_s != "."
      record.data = "#{record.data}."
      record.save!
    end
  end
end

def xfr_create
  ips = []
  i = 1
  while i < 255 do
    ips << "172.16.1.#{i}"
    i = i + 1
  end
  Zonename.all.each do |z|
    ips.each do |ip|
      z.xfr.create(:zone => z.name, :client => ip)
    end
  end
end
