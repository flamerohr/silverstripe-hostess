# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'yaml'
require 'pp'

require File.expand_path(File.dirname(__FILE__) + '/code/hostess.rb')

scriptDir = File.dirname(__FILE__)

Vagrant.configure(2) do |config|
	settings = {}

	configPath = File.expand_path(scriptDir + "/settings/config.yml")
	if File.exists? configPath then
		settings = YAML::load(File.read(configPath))
	end

	Hostess.run(config, settings)

	if defined? VagrantPlugins::HostsUpdater and settings.include? 'sites'
		config.hostsupdater.aliases = settings['sites'].map { |site| site['map'] }
	end
end
