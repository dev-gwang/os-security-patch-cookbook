#
# Cookbook:: security-cookbook
# Recipe:: u61-openssh-port-change
#
# Copyright:: 2019, The Authors, All Rights Reserved.

openssh_port = `netstat -tnlp | grep ssh | grep "0.0.0.0" | awk {'print $4'} | awk -F: {'print $2'}`.to_s
openssh_path = node["u61-openssh-port-change"]["openssh-path"]["value"]

bash "openssh sshd_config patch" do
    user "root"
    code <<-EOH
        cat #{openssh_path}/sshd_config | grep -v Port > /tmp/sshd_config_bak;
        cp -rfp /tmp/sshd_config_bak #{openssh_path}/sshd_config;
    EOH
    only_if {"#{openssh_port}" == "22\n"}
end

service "sshd" do
    action :restart
    only_if {"#{openssh_port}" == "22\n"}
end