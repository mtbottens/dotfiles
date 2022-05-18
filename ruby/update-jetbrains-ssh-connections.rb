#!/usr/bin/ruby

gem 'nokogiri'
require 'nokogiri'
require 'json'
require 'securerandom'

spin_instances = JSON.parse(%x[spin list --json --output name,fqdn])

jetbrains_ssh_config_files = Dir.glob("#{Dir.home}/Library/Application*/JetBrains/**/options/sshConfigs.xml")
jetbrains_ssh_config_files.each do |jetbrains_ssh_config_file|
  doc = File.open(jetbrains_ssh_config_file, 'r+') { |f| Nokogiri::XML(f) }

  # Remove all existing spin configurations
  doc.search("//sshConfig[contains(@host, 'spin.dev')]").remove

  # Add new spin configurations
  spin_instances.each do |instance|
    doc.at('configs').add_child("<sshConfig host=\"#{instance['fqdn']}\" id=\"#{SecureRandom.uuid}\" keyPath=\"$USER_HOME$/.config/spin/ssh/us.spin.dev.pem\" port=\"22\" nameFormat=\"DESCRIPTIVE\" username=\"spin\" useOpenSSHConfig=\"true\" />")
  end

  # Write changes to file
  File.write(jetbrains_ssh_config_file, doc.to_xml)
end
