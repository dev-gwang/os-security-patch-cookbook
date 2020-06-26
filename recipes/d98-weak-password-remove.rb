#
# Cookbook:: security-cookbook
# Recipe:: d98-weak-password-remove
#
# Copyright:: 2019, The Authors, All Rights Reserved.

execute "remove non user" do
    user "root"
    command "mysql -uroot -e \"DELETE FROM mysql.user WHERE User=''\""
end