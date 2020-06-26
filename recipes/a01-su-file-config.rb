#
# Cookbook:: security-cookbook
# Recipe:: a01-su-file-config
#
# Copyright:: 2019, The Authors, All Rights Reserved.

## /etc/login.defs 파일에 SULOG_FILE /var/log/sulog 하고 /etc/syslog.conf 파일에 auth.notice /var/adm/sulog가 설정되어 있으면 양호

if File.exist?('/etc/syslog.conf')
  sylog_conf = "/etc/syslog.conf"
else
  sylog_conf = "/etc/rsyslog.conf"
end

execute "/etc/login.defs SULOG_FILE ADD" do
    user "root"
    command "echo 'SULOG_FILE /var/log/sulog' >> /etc/login.defs"
    not_if "cat /etc/login.defs | grep 'SULOG_FILE /var/log/sulog'"
end

execute "#{sylog_conf} auth.notice ADD" do
    user "root"
    command "echo 'auth.notice /var/adm/sulog' >> #{sylog_conf}"
    not_if "cat #{sylog_conf} | grep 'auth.notice /var/adm/sulog'"
end
