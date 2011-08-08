class developer {
  package { ["git-core", "vim-nox", "elinks"]:
    ensure  => latest,
  }
}
