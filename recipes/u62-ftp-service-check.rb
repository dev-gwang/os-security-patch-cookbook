#
# Cookbook:: security-cookbook
# Recipe:: u62-ftp-service-check
#
# Copyright:: 2019, The Authors, All Rights Reserved.

execute "remove vsftpd" do
    user    "root"
    command "yum remove vsftpd -y"
    only_if "rpm -qa | grep vsftpd"
end

execute "remove user ftp" do
    user    "root"
    command "/usr/sbin/userdel ftp"
    only_if "cat /etc/passwd | grep ftp"
end

execute "remove group ftp" do
    user    "root"
    command "groupdel ftp"
    only_if "cat /etc/group | grep ftp"
end