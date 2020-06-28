#
# Cookbook:: security-cookbook
# Recipe:: u69-login-banner
#
# Copyright:: 2019, The Authors, All Rights Reserved.

banner_content = node["u69-login-banner"]["banner-content"]["value"]

file '/etc/issue.net' do
    content "#{banner_content}"
    mode '0755'
    owner 'root'
    group 'root'
end

file '/etc/issue' do
    content "#{banner_content}"
    mode '0755'
    owner 'root'
    group 'root'
end

execute "set openssh banner" do
    user    "root"
    command "echo 'Banner /etc/issue.net' >> /etc/ssh/sshd_config"
    not_if  "cat /etc/ssh/sshd_config | grep Banner | grep issue.net"
end

service "sshd" do
    action "restart"
end