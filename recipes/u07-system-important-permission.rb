#
# Cookbook:: security-cookbook
# Recipe:: u07-system-important-permission
#
# Copyright:: 2019, The Authors, All Rights Reserved.

# 해당 레시피는 다음 항목을 추가로 가지고 있음
# /etc/shadow (U-08), /etc/hosts (U-09), /etc/inetd.conf (U-10), /etc/syslog.conf (U-11), /etc/services (U-12)

filelist = node["u07"]["filelist"]

filelist.each { |file| 
    file_location   = file[0]
    file_permission = file[1]

    execute "change file permission #{file_location}" do
        user "root"
        command "chmod #{file_permission} #{file_location}"
        only_if "ls #{file_location}"
    end
}