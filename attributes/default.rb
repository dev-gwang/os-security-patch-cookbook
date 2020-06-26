default["u02"]["passalgo"] = "sha512"
default["u49"]["userlist"] = ["pulse", "nfsnobody", "adm", "lp", "sync", "shutdown", "halt", "news", "uucp", "operator",
                              "nuucp", "games", "gopher", "nfs", "nobody", "squid", "news", "jpp", "games", "adm", "game", "ftp"]
default["u49"]["grouplist"] = ["game", "news", "jpp", "games"]

default["u07"]["filelist"] =  [	["/etc/hosts.allow", "644"],
                                ["/etc/hosts.deny", "644"],
                                ["/etc/hosts", "600"],
                                ["/etc/passwd", "444"],
                                ["/etc/shadow", "400"],
                                ["/etc/profile", "444"],
                                ["/etc/syslog.conf", "644"],
                                ["/etc/services", "644"],
                                ["/etc/xinetd.conf", "600"],
                                ["/etc/xinetd.d/*", "600"],
                                ["/etc/at.deny", "640"],
								["/etc/cron.deny", "640"],
								["/etc/cron.allow", "640"] ]

default["u13"]["binary"]    = [ "/usr/bin/lpq-lpd", "/usr/bin/newgrp", "/sbin/unix_chkpwd", 
                                "/usr/bin/lpr-lpd", "/usr/bin/lpc-lpd", "/usr/sbin/traceroute", "/usr/bin/at"]

default["u25"]["envfile"]    = [ ".profile", ".cshrc", ".kshrc", ".login", ".bash_profile", ".bashrc", ".bash_login", ".exrc", ".netrc",
								 ".history", ".sh_history", ".bash_history", ".dtprofile", ".Xdefaults"]

default["u54"]["timeout"]   = 300
default["a02"]["servicelist"] = ["sendmail", "vsftpd"]