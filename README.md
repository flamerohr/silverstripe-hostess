# Hostess
Module for quickly setting up vagrant for localhost development, the intention is to make it easier and
faster to setup an environment to get going with development on SilverStripe, while keeping it easy to configure.

The idea comes from [Laravel's Homestead](https://github.com/laravel/homestead), which made setting up a local
environment quick and easy.

## Requirements
* Vagrant
* Virtualbox
* Access to hosts file, listed below

## Install
Clone with composer:
```
cd ~
composer clone https://github.com/flamerohr/silverstripe-hostess.git Hostess
```
*Important*: DO NOT use this for production setup

*Note*: It is recommended not putting this within a SilverStripe installation, as this is a global localhost
development. There is a plan to make installation specific environments.

Then you'll need to create a copy of the config files required by Hostess
```
bash ~/Hostess/setup.sh
```

You can configure the localhost servers that you would like to start serving, details in the Documentation section.

You'll need to add the host to your hosts file.
* For Mac and Linux: `/etc/hosts`
* For Windows: `C:\windows\system32\drivers\etc\hosts`
By default
```
192.168.20.20 hostess.vagrant
```

An _ss_environment.php file is included to illustrate the database username and password setup for the default
environment that is being used.

## Execute
Once you've completed installation, all you need to do:
1. Change to the Hostess folder `cd ~/Hostess`
1. Run `Vagrant up`
1. Go to `hostess.vagrant` in your browser.

## Documentation
You can run scripts after the environment has been setup by editing/adding your commands in
`~/Sites/.hostess/afterSetup.sh`

There are configuration options you can change to make the environment more suited for what your server requires.
To make these configurations, edit the file `~/Sites/.hostess/config.yml`

You can choose to use a different provider, box and OS, by changing `box`, make sure to include the corresponding `ostype`
if you're using virtualbox:
```
provider: virtualbox
box: micmania1/silverstripe-jessie64
ostype: Debian_64
```

Sometimes you may get warnings about "non-hostonly network" and would require changing the IP address:
```
ip: "192.168.20.20"
```

Resources on your server/computer can be configured with:
```
memory: 2048
cpus: 2
```

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

## Recommendation
Installing the vagrant hosts updater plugin can save you a step of manually editing the hosts file, you can install it
with the following command.
```
vagrant plugin install vagrant-hostsupdater
```

## Maintainers
* Christopher Joe cjoe@silverstripe.com

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
