#
# Cookbook:: security-cookbook
# Recipe:: u30-sendmail-service-stop
#
# Copyright:: 2019, The Authors, All Rights Reserved.

service "sendmail" do
    action :stop
    only_if "ps -ef | grep sendmail | grep -v grep"
end

execute "sendmail remove chkconfig" do
    user "root"
    command "chkconfig --del sendmail"
    only_if "chkconfig --list | grep sendmail"
end