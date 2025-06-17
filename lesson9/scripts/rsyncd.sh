sudo touch /etc/rsyncd.secrets
sudo touch /etc/rsyncd.conf
sudo bash -c 'cat /etc/rsyncd.conf << '"'"'EOF'"'"'

#!/bin/bash

uid = root
gid = root
use chroot = yes
max connections = 4
pid file = /var/run/rsyncd.pid
lock file = /var/run/rsync.lock
log file = /var/log/rsync.log

[mysql_backup]
    path = /opt/store/mysql
    comment = MySQL backups storage
    read only = no
    auth users = svt
    secrets file = /etc/rsyncd.secrets

EOF'




sudo bash -c 'cat /etc/rsyncd.secrets << '"'"'EOF'"'"'
svt:svt123
EOF'


(sudo crontab -l 2>/dev/null; echo "0 * * * * /path/to/mysql_backup.sh") | sudo crontab -