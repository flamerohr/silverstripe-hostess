# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|

	config.vm.box = <% $Box %>
	config.vm.hostname = <% $BaseUrl %>
	config.vm.network "private_network", ip: <% $Ip %>

	config.vm.provider "parallels" do |p|
		p.name = $project
		p.memory = 1024
		p.cpus = 2
	end

	config.vm.synced_folder ".", "/var/www/html", type: "nfs"

	config.vm.provision "shell" do |s|
		if !"<% $PostScript %>".empty? and File.exists?(File.join(Dir.pwd, "<% $PostScript %>"))
			s.path = "<% $PostScript %>"
		end
	end

	# Use host for ssh keys etc.
	config.ssh.forward_agent = true

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

end
