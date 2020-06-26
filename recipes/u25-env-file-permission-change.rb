#
# Cookbook:: security-cookbook
# Recipe:: u25-env-file-permission-change
#
# Copyright:: 2019, The Authors, All Rights Reserved.

filelist = node["u25"]["envfile"]

filelist.each { |file| 
    execute "chown (#{file})" do
        user "root"
        command "chown root.root /root/#{file}"
        only_if "ls /root/#{file}"
    end 

	execute "chmod o-w (#{file})" do
        user "root"
        command "chmod o-w /root/#{file}"
        only_if "ls /root/#{file}"
    end 
}