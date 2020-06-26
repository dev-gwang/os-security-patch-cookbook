#
# Cookbook:: security-cookbook
# Recipe:: d00-run-non-root-account
#
# Copyright:: 2019, The Authors, All Rights Reserved.

mysql_datadir = node["d00-run-non-root-account"]["mysql_datadir"]["value"]

### 데이터 디렉토리 권한 변경
execute "change own mysql" do
    user "root"
    command "chown mysql.mysql -R #{mysql_datadir}"
    only_if "ls #{mysql_datadir}"
end

### mysql 데몬 재시작
execute "kill mysqld" do
    user "root"
    command "killall mysqld; sleep 10;"
end