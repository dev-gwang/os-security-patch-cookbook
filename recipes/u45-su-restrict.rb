#
# Cookbook:: security-cookbook
# Recipe:: u45-su-restrict
#
# Copyright:: 2019, The Authors, All Rights Reserved.

template "/etc/pam.d/su" do
    source  "su.erb"
    owner   "root"
    group   "root"
    mode    "0644"
end

group "wheel" do
    append true
    not_if "cat /etc/group | grep wheel"
end

execute "gpasswd root" do
    user    "root"
    command "gpasswd wheel -a root"
end

execute "chown /bin/su" do
    user    "root"
    command "chown root.wheel /bin/su"
end

execute "chmod /bin/su" do
    user    "root"
    command "chmod 4750 /bin/su"
end
