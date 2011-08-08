class mysql {
  package { "mysql-server":
    ensure  => present,
  }

  service { "mysqld":
    ensure  => running,
    require => Package["mysql-server"],
  }

  notice("Installing MySQL")
}
