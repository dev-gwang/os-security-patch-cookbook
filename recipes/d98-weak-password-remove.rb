#
# Cookbook:: security-cookbook
# Recipe:: d98-weak-password-remove
#
# Copyright:: 2019, The Authors, All Rights Reserved.

mysql_user_id = node["d98-weak-password-remove"]["mysql_admin_id"]["value"]
mysql_user_password = node["d98-weak-password-remove"]["mysql_admin_password"]["value"]

execute "remove non user" do
    user "root"
    command "mysql -u#{mysql_user_id} -p#{mysql_user_password} -e \"DELETE FROM mysql.user WHERE User=''\""
    only_if "ps -ef | grep mysql | grep -v mysql"
end