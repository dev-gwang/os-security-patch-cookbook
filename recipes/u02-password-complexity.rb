#
# Cookbook:: security-cookbook
# Recipe:: u02-password-complexity
#
# Copyright:: 2019, The Authors, All Rights Reserved.

passalgo = node["u02"]["passalgo"]

execute "change password algorithm" do
    user "root"
    command "authconfig -passalgo=#{passalgo} -update"
    not_if "authconfig --test | grep hashing | grep #{passalgo}"
end