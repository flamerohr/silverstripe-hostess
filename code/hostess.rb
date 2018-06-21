scriptDir = File.dirname(__FILE__)
baseDir = "/vagrant/base"
rootDir = "/vagrant/root"

def setupSite(site, config)
  from = site["from"]
  sourceFolder = from
  targetFolder = rootDir + from

  if !from.start_with?("/") then
    sourceFolder = File.expand_path(scriptDir + "/" + from)
    targetFolder = File.expand_path(baseDir + "/" + from)
  end

  if !File.exists? sourceFolder then
    return
  end
  config.vm.synced_folder sourceFolder, targetFolder, type: site["type"] ||= nil

  if site.include? 'domain' then
    config.vm.provision "shell" do |s|
      s.path = File.expand_path(scriptDir + "/scripts/server.sh")
      s.args = [
        site["domain"],
        targetFolder,
        site["port"] ||= "80",
        site["ssl"] ||= "443"
      ]
    end
  end
end

class Hostess
  def Hostess.run(config, settings)
    ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    config.vm.box = settings["box"] ||= "zauberfisch/silverstripe-jessie64"
    config.vm.hostname = settings["hostname"] ||= "silverstripe.hostess"
    config.vm.network "private_network", ip: settings["ip"] ||= "10.0.20.20"

    # Use host for ssh keys etc.
    config.ssh.forward_agent = true

    config.vm.provider "virtualbox" do |v|
      v.name = settings["name"] ||= "silverstripe_hostess"
      v.customize ["modifyvm", :id, "--memory", settings["memory"] ||= "2048"]
      v.customize ["modifyvm", :id, "--cpus", settings["cpus"] ||= "2"]
      v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--ostype", settings["ostype"] ||= "Debian_64"]
    end

    # Configure A Few Parallels Settings
    config.vm.provider "parallels" do |v|
      v.name = settings["name"] ||= "silverstripe_hostess"
      v.memory = settings["memory"] ||= "2048"
      v.cpus = settings["cpus"] ||= "2"
      v.update_guest_tools = true
    end

    # create a vagrant public folder
    config.vm.provision :shell, :inline => "mkdir -p /vagrant/public || echo '/vagrant/public already exists'"

    # run scripts before setup
    beforeSetupPath = File.expand_path(scriptDir + "/../settings/before.sh")
    if File.exists? beforeSetupPath then
        config.vm.provision "shell", path: beforeSetupPath, privileged: false
    end

    domains = []
    # Register site folders
    if settings.include? 'sites' then
      settings["sites"].each do |site|
        setupSite(site, config)
      end
    end

    # Check if ~/.gitconfig exists locally
    # If so, copy basic Git Config settings to Vagrant VM
    if File.exists?(File.join(Dir.home, ".gitconfig"))
      git_name = `git config user.name`   # find locally set git name
      git_email = `git config user.email` # find locally set git email

      # set git name for 'vagrant' user on VM
      config.vm.provision :shell, :inline => "echo 'Saving local git username to VM...' && sudo -i -u vagrant git config --global user.name '#{git_name.chomp}'"

      # set git email for 'vagrant' user on VM
      config.vm.provision :shell, :inline => "echo 'Saving local git email to VM...' && sudo -i -u vagrant git config --global user.email '#{git_email.chomp}'"
    end

    # run scripts after setup
    afterSetupPath = File.expand_path(scriptDir + "/../settings/after.sh")
    if File.exists? afterSetupPath then
        config.vm.provision "shell", path: afterSetupPath, privileged: false
    end

  end
end
