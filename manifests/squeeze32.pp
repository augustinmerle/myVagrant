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

  notice("Installing Apache2...")
}

class apache2_dyn_vhost inherits apache2 {
  file { "/etc/apache2/sites-available/dyn_vhost.conf":
    source  => "/vagrant/files/conf/dyn_vhost.conf",
    ensure  => present,
  }

  apache2::module { "vhost_alias": }
  apache2::site { "dyn_vhost.conf": }
}

class mysql {
  package { "mysql-server-5.1":
    ensure  => present,
  }

  service { "mysql":
    ensure  => running,
    require => Package["mysql-server-5.1"],
  }

  notice("Installing MySQL...")
}

class php5 {
  package { ["php5", "php5-mysql", "php5-sqlite", "php5-intl", "php5-apc"]:
    ensure => present,
  }

  notice("Installing PHP...")
}

class apt {
  file { "/etc/apt/sources.list":
    source  => "/vagrant/files/conf/sources.list",
    ensure  => present,
  }

  exec { "dotdeb" :
    user    => root,
    command => "wget http://www.dotdeb.org/dotdeb.gpg && apt-key add dotdeb.gpg",
    unless  => "test -f dotdeb.gpg",
    path    => ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin"],
    require => File["/etc/apt/sources.list"],
  }

  exec { "apt-get-update":
    user    => root,
    command => "apt-get update",
    path    => ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin"],
    require => Exec["dotdeb"],
  }

  notice("Configuring APT...")
}

class webserver {
  include apt
  include apache2_dyn_vhost
  include mysql
  include php5
}

class developer {
  package { ["git-core", "vim-nox", "elinks"]:
    ensure  => latest,
  }
}

class william inherits developer {
  user { "william":
    ensure     => "present",
    groups     => ["william", "www-data"],
    shell      => "/bin/bash",
    managehome => true,
    password   => '$6$z.DnY3wv$nwbdl3IyNPq2TXtgR7Sb6cts6qoYNgePYixReh/.HikvAIrFHoQyu09nGKJQ4OQmKL3pREouVsIBtWIzhJ0sh/',
  }

  exec { "dotfiles-install":
    user    => william,
    cwd     => "/home/william",
    command => "git clone git://github.com/willdurand/dotfiles.git && cd dotfiles && ./install.sh",
    unless  => "test -d dotfiles",
    path    => ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin"],
  }

  exec { "dotfiles-update":
    user    => william,
    cwd     => "/home/william/dotfiles",
    command => "git pull origin master && ./install.sh",
    onlyif  => "test -d dotfiles",
    path    => ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin"],
  }
}

Package {
  ensure    => installed,
  require   => Exec["apt-get-update"]
}

include webserver
include william
