#
# Cookbook:: security-cookbook
# Recipe:: u55-apache-unnecessary-file-remove
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apache_location = node["u55-apache-unnecessary-file-remove"]["apache-location"]["value"]

execute "remove unnecessary apache file" do
    user "root"
    command "rm -rf #{apache_location}/manual"
    only_if "ls #{apache_location}/manual"
end