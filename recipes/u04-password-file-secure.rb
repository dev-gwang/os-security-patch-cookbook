#
# Cookbook:: security-cookbook
# Recipe:: d04-password-file-secure
#
# Copyright:: 2019, The Authors, All Rights Reserved.

execute "password file secure" do
    user "root"
    command "pwconv"
end