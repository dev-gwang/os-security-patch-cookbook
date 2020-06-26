#
# Cookbook:: security-cookbook
# Recipe:: u33-home-directory-own-permission
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash "patch" do
	user "root"
	code <<-EOH
		IFS=$'\n' ARR=(`cat /etc/passwd | grep bash | awk -F: {'print $1,$6'}`)

		for VALUE in "${ARR[@]}"; do 
			USER=`echo $VALUE | awk {'print $1'}`
			LOCATION=`echo $VALUE | awk {'print $2'}`

			if [[ $USER == "root" ]]; then
				chown $USER.$USER $LOCATION;
			fi
		done
	EOH
end
