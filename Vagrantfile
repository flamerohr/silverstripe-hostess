# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'pp'

require File.expand_path(File.dirname(__FILE__) + '/code/hostess.rb')

configPath = File.expand_path("~/Sites/.hostess/config.yml")
afterSetupPath = File.expand_path("~/Sites/.hostess/afterSetup.sh")

Vagrant.configure(2) do |config|
	settings = {}

	if File.exists? configPath then
		settings = YAML::load(File.read(configPath))
	end

	Hostess.run(config, settings)

	if File.exists? afterSetupPath then
			config.vm.provision "shell", path: afterSetupPath, privileged: false
	end

	if defined? VagrantPlugins::HostsUpdater and settings.include? 'sites'
		config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
	end
end
