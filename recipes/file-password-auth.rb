#
# Cookbook:: security-cookbook
# Recipe:: file-password-auth
#
# Copyright:: 2019, The Authors, All Rights Reserved.

os_version = node["system"]["os"]

template "/etc/pam.d/password-auth-ac" do
    source  "password-auth.erb"
    owner   "root"
    group   "root"
    mode    "0755"
    only_if { os_version == "el6" }
end