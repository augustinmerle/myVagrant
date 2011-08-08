myVagrant
=========

This set of files is designed to setup a new virtual machine in few minutes based on a
[Debian Squeeze box](http://mathie-vagrant-boxes.s3.amazonaws.com/debian_squeeze_32.box).

## Installation

Get *Virtualbox*: [http://www.virtualbox.org/wiki/downloads](http://www.virtualbox.org/wiki/downloads)

Install [*Vagrant*](http://vagrantup.com/):

    gem install vagrant

Add box to *Vagrant*:

    vagrant box add squeeze32 http://mathie-vagrant-boxes.s3.amazonaws.com/debian_squeeze_32.box

Clone this configuration:

    git clone git://github.com/willdurand/myVagrant.git

And... Enjoy:

    cd myVagrant
    vagrant up

In few minutes, you'll get a new virtual machine with *Debian Squeeze*, *Apache2*, *MySQL* (latest version),
*PHP 5.3* (latest version), *Git*, *Vim* (with Ruby support) and *Elinks*.
It configures *APT* to use the [Dotdeb](http://www.dotdeb.org/) repository.
Apache2 is configured to use the `VirtualDocumentRoot` feature that allows you to fast create new vhosts.
It also configures a user named `william` with [my dotfiles](https://github.com/willdurand/dotfiles) for this user.

## Credentials

* `root` / `vagrant`
* `vagrant` / `vagrant`
* `william` / `william`

## Credits

* William DURAND
* Fabrice BERNHARD for [his example](https://github.com/fabriceb/sfLive2011vm).
