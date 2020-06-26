#
# Cookbook:: security-cookbook
# Recipe:: u13-suid-sgid-configure
#
# Copyright:: 2019, The Authors, All Rights Reserved.


filelist = node["u13"]["binary"]

filelist.each { |file| 
    execute "chmod -s (#{file})" do
        user "root"
        command "chmod -s #{file}"
        only_if "ls #{file}"
    end 
}