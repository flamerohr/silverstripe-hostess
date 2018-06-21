# Hostess

Module to help set up a virtual environment for localhost development, the intention is to make it easier and
faster to setup an environment to get going with development on SilverStripe, while keeping it easy to configure.

The idea comes from [Laravel's Homestead](https://github.com/laravel/homestead), which made setting up a local
environment quick and easy.

## Requirements

* Vagrant
* Virtualbox (or Parallels)

## Install

Clone with composer:

```sh
> composer clone https://github.com/flamerohr/silverstripe-hostess.git
> cd silverstripe-hostess
```

**Important**: DO NOT use this for production setup

*Note*: It is recommended not putting this within a SilverStripe installation, as this is a global localhost
development. There is a plan to make installation specific environments.

## Recommendation

Installing the `vagrant-hostsupdater` plugin can save you a step of manually editing the hosts file, you can install it
with the following command.

```sh
> vagrant plugin install vagrant-hostsupdater
```

## Getting started

Then you'll need to edit the config found in `settings/config.yml`

If you don't have `vagrant-hostsupdater` installed, then you'll also need to add the domains you have to your hosts file.

* For Mac and Linux: `/etc/hosts`
* For Windows: `C:\windows\system32\drivers\etc\hosts`

For the default vagrant site:

```txt
192.168.20.20  hostess.vagrant
```

Once you've completed installation and the setup above, all you need to do is:

1. Run `> Vagrant up`
1. Go to `http://hostess.vagrant` in your browser.

## Documentation

### Scripts

You can run scripts before or after the environment has been setup by editing/adding your commands to `settings/before.sh` or
`settings/after.sh`

### Configuration

The config file `settings/config.yml` contains options available to customise the environment to suit your needs and requirements. The options are listed in this table:

| Option | Default | Description |
|--- | --- | --- |
| `name` | `silverstripe_hostess` | The name for the vagrant machine, you may have multiple instances of vagrant up for different environment setups |
| `hostname` | `silverstripe.hostess` | The default hostname the machine shall take, currently won't show anything, have plans to create a "directory" of hosted sites |
| `box` | `zauberfisch/silverstripe-jessie64` | The vagrant box to use, you can find other kinds of boxes to use on the Vagrant website |
| `ip` | `10.0.20.20` | The IP address the machine shall use, maybe you want this to be on your network |
| `memory` | `2048` | How much RAM do you want your machine to have |
| `cpus` | `2` | The number of CPUs your machine will utilise for processing |
| `provider` | `virtualbox` | Which virtual machine technology shall be used, I know some prefer vmware or parallels |
| `ostype` | `Debian_64` | This is mainly for Virtualbox settings |
| `sites` | N/A | Example is given |

### Setting up sites

**Important** This section is out of date, please refer to the `settings/config.yml` example on how to set sites up
You can add folders that the environment can access with, importantly share the site source code with the environment:
```
folders:
  - map: ~/Sites/silverstripe
    to: /home/vagrant/silverstripe
    type: nfs
```

Add site urls so that your browser may find it, make sure the map is in the hosts file with the IP defined above:
```
sites:
  - map: hostess.vagrant
    to: /home/vagrant/silverstripe/silverstripe
    port: 80
```

After you've finished customising, you'll need to provision vagrant with:
```
vagrant reload --provision
```

## Roadmap
This is in no particular order:
* Add `*.sspak` snapshot support, or database loader
* Port forwarding for database and other access from host machine
* Investigate Parallels support
* Switch for Apache or Nginx to be used
* Add SSL support
* An installation specific environment for a single site running, with yml config to set things up.
* Smarter vagrant config process
* Keep SilverStripe dependency only if running this as a module, I don't think global should require a SilverStripe
installation.
