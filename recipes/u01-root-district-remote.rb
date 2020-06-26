#
# Cookbook:: security-cookbook
# Recipe:: u01-root-district-remote
#
# Copyright:: 2019, The Authors, All Rights Reserved.

openssh_dir = node["u01-root-district-remote"]["openssh_dir"]["value"]

execute "sshd_config remove PermitRootLogin Option" do
    user "root"
    command "cat #{openssh_dir}/sshd_config | grep -v PermitRootLogin > /tmp/sshd_config"
    only_if "ls #{openssh_dir}"
end

execute "sshd_config move #{openssh_dir}" do
    user "root"
    command "mv /tmp/sshd_config #{openssh_dir}/sshd_config"
    only_if "ls #{openssh_dir}"
end

execute "sshd_config PermitRootLogin No Option Add" do
    user "root"
    command "echo 'PermitRootLogin no' >> #{openssh_dir}/sshd_config"
    only_if "ls #{openssh_dir}"
end

service "sshd" do
    action :restart
    only_if "ls #{openssh_dir}"
end