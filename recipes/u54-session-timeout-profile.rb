#
# Cookbook:: security-cookbook
# Recipe:: u54-session-timeout-profile
#
# Copyright:: 2019, The Authors, All Rights Reserved.

require 'time'

timeout = node["u54"]["timeout"]
time = Time.now.iso8601

bash "remove old TMOUT" do
    user "root"
    code <<-EOH
        cat /etc/profile | grep -v "TMOUT=\\|export TMOUT" > /tmp/profile_tmp;

        mv /etc/profile /etc/profile_bak_#{time}

        cp -rfp /tmp/profile_tmp /etc/profile;

        rm -rf /tmp/profile_tmp;
    EOH
    not_if "cat /etc/profile | grep TMOUT=#{timeout}"
end


execute "set TMOUT=#{timeout}" do
    user    "root"
    command "echo 'TMOUT=#{timeout}' >> /etc/profile"
    not_if  "cat /etc/profile | grep TMOUT"
end

execute "export TMOUT" do
    user    "root"
    command "echo 'export TMOUT' >> /etc/profile"
    not_if  "cat /etc/profile | grep 'export TMOUT'"
end

execute "umask setting" do
    user    "root"
    command "echo 'umask 027' >> /etc/profile"
    not_if  "cat /etc/profile | grep 'umask'"
end