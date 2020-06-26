#
# Cookbook:: security-cookbook
# Spec:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

describe file('/etc/ssh/etc/sshd_config') do
  its('content') { should match(PermitRootLogin) }
end