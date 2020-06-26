#
# Cookbook:: security-cookbook
# Recipe:: os-check
#
# Copyright:: 2019, The Authors, All Rights Reserved.

################################################
## Variables
################################################

if node['platform_family'] == 'rhel' then
	node.default["system"]["os"]	=	"el" + node['platform_version'][0]
end