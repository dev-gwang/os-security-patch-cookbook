#
# Cookbook:: security-cookbook
# Recipe:: u61-openssh-port-change
#
# Copyright:: 2019, The Authors, All Rights Reserved.

openssh_port = `netstat -tnlp | grep ssh | grep "0.0.0.0" | awk {'print $4'} | awk -F: {'print $2'}`.to_s

bash "openssh sshd_config patch" do
    user "root"
    code <<-EOH
        cat /etc/ssh/sshd_config | grep -v Port > /tmp/sshd_config_bak;
        cp -rfp /tmp/sshd_config_bak /etc/ssh/etc/sshd_config;
    EOH
    only_if {"#{openssh_port}" == "22\n"}
end

service "sshd" do
    action :restart
    only_if {"#{openssh_port}" == "22\n"}
end