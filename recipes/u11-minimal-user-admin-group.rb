#
# Cookbook:: security-cookbook
# Recipe:: u11-minimal-user-admin-group
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash "user shell check" do
    user "root"
    code <<-EOH
		IFS=$',' ARR=(`cat /etc/group | grep root:x | awk -F:root, {'print $2'}`)

		for VALUE in "${ARR[@]}";
		do
			gpasswd -d $VALUE root
		done
	EOH
end