class apache2 {
  package { "apache2":
    ensure  => present,
  }

  define site () {
    exec { "/usr/sbin/a2ensite $name":
      unless  => "/bin/readlink -e /etc/apache2/sites-enabled/$name",
      notify  => Exec["apache2-force-reload"],
      require => Package["apache2"],
    }
  }

  define module () {
    exec { "/usr/sbin/a2enmod $name":
      unless  => "/bin/readlink -e /etc/apache2/mods-enabled/${name}.load",
      notify  => Exec["apache2-force-reload"],
      require => Package["apache2"],
    }
  }

  exec { "apache2-force-reload":
    user    => root,
    command => "/etc/init.d/apache2 force-reload",
  }

  service { "apache2":
    ensure      => running,
    hasstatus   => true,
    hasrestart  => true,
    require     => Package["apache2"],
  }

  notice("Installing Apache2")
}

class apache2_dyn_vhost inherits apache2 {
  file { "/etc/apache2/sites-available/dyn_vhost.conf":
    source  => "/vagrant/files/conf/dyn_vhost.conf",
    ensure  => present,
  }

  apache2::module { "vhost_alias": }
  apache2::site { "dyn_vhost.conf": }
}
