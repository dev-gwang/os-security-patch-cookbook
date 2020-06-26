#
# Cookbook:: security-cookbook
# Recipe:: u15-world-writable-file-check
#
# Copyright:: 2019, The Authors, All Rights Reserved.

puts ("\n\n Find World Writable File \n Please Wait...\n")
filelist=`find / -not -path "/proc/*" -not -path "/tmp/*" -not -path "/tmp"  -not -path "/dev/*" -perm -2 -ls  | awk '{print $3 ":" $5 ":" $6 ":" $11}' | egrep -v "^l|^s|^c" | awk -F: {'print $4'}`.split("\n")

filelist.each { |file| 
    filename = file
    filename.gsub!("\n", "")

    execute "remove worldwritable from file #{filename}" do
        user "root"
        command "chmod o-w #{filename}"
    end
}