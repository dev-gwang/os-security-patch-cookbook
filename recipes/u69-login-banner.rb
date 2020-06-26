#
# Cookbook:: security-cookbook
# Recipe:: u69-login-banner
#
# Copyright:: 2019, The Authors, All Rights Reserved.

template "/etc/issue.net" do
    source  "banner.erb"
    owner   "root"
    group   "root"
    mode    "0755"
end

template "/etc/issue" do
    source  "banner.erb"
    owner   "root"
    group   "root"
    mode    "0755"
end

execute "set openssh banner" do
    user    "root"
    command "echo 'Banner /etc/issue.net' >> /etc/ssh/sshd_config"
    not_if  "cat /etc/ssh/sshd_config | grep Banner | grep issue.net"
end

service "sshd" do
    action "restart"
end