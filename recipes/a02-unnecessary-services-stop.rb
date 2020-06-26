#
# Cookbook:: security-cookbook
# Recipe:: a02-unnecessary-services-stop
#
# Copyright:: 2019, The Authors, All Rights Reserved.

servicelist = node["a02-unnecessary-services-stop"]["servicelist"]["value"]

servicelist.each { |service| 
    execute "service stop (#{service})" do
        user "root"
        command "service #{service} stop"
        only_if "service #{service} status"
    end
     
    execute "chkconfig remove #{service}" do
        user "root"
        command "chkconfig --del #{service}"
        only_if "chkconfig --list | grep #{service}"
    end
}