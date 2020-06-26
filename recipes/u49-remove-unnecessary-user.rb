#
# Cookbook:: security-cookbook
# Recipe:: u49-remove-unnecessary-user
#
# Copyright:: 2019, The Authors, All Rights Reserved.

userlist = node["u49"]["userlist"]
grouplist = node["u49"]["grouplist"]

userlist.each { |user| 
    execute "remove user #{user}" do
        user "root"
        command "/usr/sbin/userdel #{user}"
        ignore_failure true
        only_if "cat /etc/passwd | grep #{user}:x"
    end 
}

grouplist.each { |group| 
    execute "remove group #{group}" do
        user "root"
        command "groupdel #{group}"
        ignore_failure true
        only_if "cat /etc/group | grep #{group}"
    end 
}