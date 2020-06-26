#
# Cookbook:: security-cookbook
# Recipe:: file-apache-conf
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apache_location = node["apache"]["location"]

template "#{apache_location}/conf/httpd.conf" do
    user "root"
    owner   "root"
    group   "root"
    mode    "0755"
	only_if "ls #{apache_location}/conf/"
end

execute "apache service stop" do
    user "root"
    command "killall httpd; sleep 5"
	only_if "ls #{apache_location}/conf/"
end

execute "apache service start" do
    user "root"
    command "#{apache_location}/bin/apachectl start"
	not_if "ps -ef | grep httpd"
end