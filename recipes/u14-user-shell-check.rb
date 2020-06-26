#
# Cookbook:: security-cookbook
# Recipe:: u14-user-shell-check
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash "user shell check" do
    user "root"
    code <<-EOH
        IFS=$'\n' username_list=(`ls /export/home`)
        
        for username in "${username_list[@]}"; do 
            echo "<---- $username ---->"; 
            IFS=$'\n' username_file_list=(`ls -a /export/home/$username | grep "^\."`)

            for filename in "${username_file_list[@]}"; do
                if [[ "$filename" == "." ]] || [[ "$filename" == ".." ]]; then
                    continue;
                fi

                chown $username.$username /export/home/$username/$filename;
                echo $filename;
            done
        done
    EOH
end
