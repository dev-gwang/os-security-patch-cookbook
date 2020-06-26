#
# Cookbook:: security-cookbook
# Recipe:: u48-password-min-day
#
# Copyright:: 2019, The Authors, All Rights Reserved.

## with u47, u49

login_defs = "/etc/login.defs"

pass_min_len = 9
pass_max_days = 90
pass_min_days = 1

execute "remove option #{login_defs}" do
    user    "root"
    command "cat /etc/login.defs | grep -v 'PASS_MIN_LEN' | grep -v 'PASS_MAX_DAYS' | grep -v 'PASS_MIN_DAYS' > /tmp/login.defs.bak"
end

bash "add option #{login_defs}" do
    user    "root"
    code    <<-EOH
        echo "PASS_MIN_LEN #{pass_min_len}" >> /tmp/login.defs.bak;
        echo "PASS_MAX_DAYS #{pass_max_days}" >> /tmp/login.defs.bak;
        echo "PASS_MIN_DAYS #{pass_min_days}" >> /tmp/login.defs.bak;

        cp -rfp /tmp/login.defs.bak /etc/login.defs;
        #rm -rf /tmp/login.defs.bak;
    EOH
end