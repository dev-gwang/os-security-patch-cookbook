#
# Cookbook:: security-cookbook
# Recipe:: file_system_auth
#
# Copyright:: 2019, The Authors, All Rights Reserved.

## 구버전 보안 취약성 패치의 경우 system-auth -> system-auth-ac 파일로 링크하지 않고 복사하였기 때문에
## 해당 파일을 제거하는 과정 필요함

os_version = node["system"]["os"]

template "/etc/pam.d/system-auth-ac" do
    source  "system-auth-#{os_version}.erb"
    owner   "root"
    group   "root"
    mode    "0755"
end

execute 	"remove old not link file" do
	user 	"root"
	command "rm -f /etc/pam.d/system-auth"
	not_if 	"test -L /etc/pam.d/system-auth"
end

link "/etc/pam.d/system-auth" do
	to "/etc/pam.d/system-auth-ac"
end
