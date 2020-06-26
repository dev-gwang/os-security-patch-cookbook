#
# Cookbook:: security-cookbook
# Recipe:: d99-permission-mysql-configure
#
# Copyright:: 2019, The Authors, All Rights Reserved.

execute "change permission my.cnf" do
    user "root"
    command "chmod 600 /etc/my.cnf"
end