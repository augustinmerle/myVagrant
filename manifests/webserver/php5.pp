class php5 {
  package {
    [
      "php5",
      "php5-cli",
      "php5-mysql",
      "php5-sqlite",
      "php5-intl",
      "php5-apc"
    ]: ensure => present,
  }

  notice("Installing PHP")
}
