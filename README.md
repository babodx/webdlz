webdlz
======

Web management module for Bind named server with dlz dirver support

This module manage zone and records via Web interface, which stores in Database. With database works bind with dlz support. For authorization it uses devise with omniauth and enabled webmoney auth module.

upports user roles an multiple users. 

Supports All kind of DNS records (also IPV6 AAAA records and TXT records)


About Bind Dlz you can read here http://bind-dlz.sourceforge.net/


For installation:

1. Clone this repo
2. Create database and user 'named_production'
3. Edit config/database.yml
4. run RAILS_ENV=production bundle install 
5. run RAILS_ENV=production rake db:migrate
6. than run any web server ( unicorn for example) you want.


Also for Bind config you need to specify this rules in /etc/named.conf

dlz "postgres zone" {
    database "postgres 2
    {host=172.16.5.55 port=5432 dbname=named_production user=named_production password='your_password'}
    {select zone from records where zone = '$zone$'}
    {select ttl, record_type, mx_priority, case when lower(record_type)='txt' then concat('\"', data, '\"') else data end from records where zone = '$zone$' and host = '$record$' and not (record_type = 'SOA' or record_type = 'NS')}
    {select ttl, record_type, mx_priority, data, resp_person, serial, refresh, retry, expire, minimum from records where zone = '$zone$' and (record_type = 'SOA' or record_type='NS')}
    {select ttl, record_type, host, mx_priority, data, resp_person, serial, refresh, retry, expire,  minimum from records where zone = '$zone$'}
    {select zone from xfr_table where zone = '$zone$' and client = '$client$'}";
    };
    
    


Developer Pavel Sorokin
