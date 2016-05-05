# Hostess
SilverStripe module for setting up a vagrant for localhost development, the intention is to make it easier and faster to setup an environment to 
get going with development on SilverStripe, while keeping it easy to configure by utilising SilverStripe's configuration tools.

The idea comes from [Laravel's Homestead](https://github.com/laravel/homestead), which made setting up a local environment quick and easy.

## Requirements
* SilverStripe framework (>=3.1)
* Vagrant
* Virtualbox
* Access to hosts file, listed below

## Install
Add require through composer:
```
"require-dev": {
	"flamerohr/silverstripe-hostess": "~0.1"
}
```
*Important*: DO NOT use this for production setup and use `require-dev` in composer instead of `require`

You'll need to allow writing a Vagrantfile in your root directory, run these while you're in the root directory for your SilverStripe installation:
```
touch Vagrantfile
chmod 777 Vagrantfile
```

Then you'll need to run the dev task, it can be run in the web interface or command line, we're assuming command line otherwise you wouldn't need to
be here.
```
./framework/sake dev/tasks/CreateVagrantfileTask
```

You'll need to add the host to your hosts file.
* For Mac and Linux: `/etc/hosts`
* For Windows: `C:\windows\system32\drivers\etc\hosts`
```
192.168.10.15 localhost.dev
```

You're done setting up.

## Execute
Once you've completed installation, all you need to do is run `Vagrant up` and go to `localhost.dev` in your browser.

## Documentation
You can customise the Vagrant setup with a `yml` file in your `mysite/_config` directory, the following are default values which you can
change.
```
Vagrantfile:
  # Used mainly by vagrant as a unique reference
  name: 'silverstripe_localhost'
  # The url you want to access the SilverStripe site in the browser
  base_url: 'localhost.dev'
  # IP address used by the vagrant, only change if it conflicts with your networking
  ip: '192.168.10.15'
  # The SilverStripe box to use
  box: 'micmania1/silverstripe-jessie64'
  # script to run after starting the vagrant, normally a bash shell script
  post_script: ''
  # The SilverStripe template to use for building the Vagrantfile, can add customisations here instead
  template: 'Vagrantfile'
```

Note about `post_script`, it is recommended to only use if you require installing extra software which the box you're using doesn't provide.
This does slow down bootup of the Vagrant and potentially use a lot of bandwidth if you're reloading/provisioning a number of time.
Please use the proper scripting language supported by the box you use.

After you've finished customising, do the following:
1. Run the dev task as above, in the command line `./framework/sake dev/tasks/CreateVagrantfileTask`
1. Run `vagrant reload --provision` to apply the new settings to vagrant.

## Maintainers
* Christopher Joe cjoe@silverstripe.com

## Roadmap
This is in no particular order:
* A global environment for multiple sites running, with yml config to set things up.
* Smarter vagrant config process
* Keep SilverStripe dependency only if running this as a module, I don't think global should require a SilverStripe installation
