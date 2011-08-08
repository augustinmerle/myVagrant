import "../base/*"

class webserver inherits server {
  include apache2_dyn_vhost
  include mysql
  include php5
}
