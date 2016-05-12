class Hostess
  def Hostess.run(config, settings)
    scriptDir = File.dirname(__FILE__)

    # set the script that will run after setting things up
#     afterSetupPath = File.expand_path(scriptDir + "../afterSetup.sh")
#     if not File.exists? afterSetupPath then
      afterSetupPath = File.expand_path("~/Sites/.hostess/afterSetup.sh")
#     end

    # set the script that will run before setting things up
#     beforeSetupPath = File.expand_path(scriptDir + "../beforeSetup.sh")
#     if not File.exists? beforeSetupPath then
      beforeSetupPath = File.expand_path("~/Sites/.hostess/beforeSetup.sh")
#     end

    ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

    # Prevent TTY Errors
    config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

    config.vm.box = settings["box"] ||= "micmania1/silverstripe-jessie64"
    config.vm.hostname = settings["hostname"] ||= "silverstripe.hostess"
    config.vm.network "private_network", ip: settings["ip"] ||= "192.168.20.20"

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
      v.memory = settings["memory"] ||= 2048
      v.cpus = settings["cpus"] ||= 2
      v.update_guest_tools = true
    end

    # Register All Of The Configured Shared Folders
    if settings.include? 'folders'
      settings["folders"].each do |folder|
        config.vm.synced_folder folder["map"], folder["to"], type: folder["type"] ||= nil
      end
    end

    # create a vagrant public folder
    config.vm.provision :shell, :inline => "mkdir -p /vagrant/public || echo '/vagrant/public already exists'"

    # run scripts before setup
    if File.exists? beforeSetupPath then
        config.vm.provision "shell", path: beforeSetupPath, privileged: false
    end

    # Setup sites that were listed
    if settings.include? 'sites'
      settings["sites"].each do |site|
        config.vm.provision "shell" do |s|
          s.path = scriptDir + "/scripts/server.sh"
          s.args = [site["map"], site["to"], site["port"] ||= "80", site["ssl"] ||= "443"]
        end
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
    if File.exists? afterSetupPath then
        config.vm.provision "shell", path: afterSetupPath, privileged: false
    end

  end
end
