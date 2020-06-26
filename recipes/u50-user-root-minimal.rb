#
# Cookbook:: security-cookbook
# Recipe:: u50-user-root-minimal
#
# Copyright:: 2019, The Authors, All Rights Reserved.

userlist=`cat /etc/group | grep root: | awk -F: {'print $4'}`.split(",")

userlist.each { |user| 
    username = user
    username.gsub!("\n", "")

    execute "remove user from group" do
        user "root"
        ignore_failure true
        command "gpasswd -d #{username} root"
    end
}