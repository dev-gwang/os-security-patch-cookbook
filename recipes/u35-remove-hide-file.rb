#
# Cookbook:: security-cookbook
# Recipe:: u35-remove-hide-file
#
# Copyright:: 2019, The Authors, All Rights Reserved.

execute "remove ice-unix" do
    user "root"
    command "rm -rf /tmp/.ICE-unix"
end