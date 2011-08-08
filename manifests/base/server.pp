class apt {
  file { "/etc/apt/sources.list":
    source => "/vagrant/files/conf/sources.list",
    owner  => root,
    ensure => present,
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

  notice("Configuring APT")
}

class server {
	include apt
}
