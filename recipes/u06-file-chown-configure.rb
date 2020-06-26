#
# Cookbook:: security-cookbook
# Recipe:: u06-file-chown-configure
#
# Copyright:: 2019, The Authors, All Rights Reserved.

bash "find nouser and chown root" do
    user    "root"
    ignore_failure true
    code    <<-EOH
        IFS=$'\n' file_list=(`find / -not -path "/proc/*" -nouser -print`)

        for VALUE in "${file_list[@]}"; do
            if [[ -L $VALUE ]]; then
                chown -h root "${VALUE}";
            else
                chown root "${VALUE}";
            fi
        done;
    EOH
end

bash "find group and chown root" do
    user    "root"
    ignore_failure true
    code    <<-EOH
        IFS=$'\n' file_list=(`find / -not -path "/proc/*" -nogroup -print`)

        for VALUE in "${file_list[@]}"; do
            if [[ -L $VALUE ]]; then
                chgrp -h root "${VALUE}";
            else
                chgrp root "${VALUE}";
            fi
        done;
    EOH
end
