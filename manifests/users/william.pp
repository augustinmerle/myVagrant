class william inherits developer {
  user { "william":
    ensure     => "present",
    groups     => ["www-data"],
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
    require => User["william"],
  }

  exec { "dotfiles-update":
    user    => william,
    cwd     => "/home/william/dotfiles",
    command => "git pull origin master && ./install.sh",
    onlyif  => "test -d dotfiles",
    path    => ["/bin", "/usr/bin", "/usr/local/bin", "/usr/sbin"],
    require => User["william"],
  }

  notice ("Creating user: william")
}
