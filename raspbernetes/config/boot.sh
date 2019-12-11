#!/bin/bash
set -euo pipefail

# Make execution on reboot & check syslogs using "tail -f /var/log/syslog"
sed -i 's/^exit 0/\/home\/pi\/bootstrap.sh 2>\&1 | logger -t kubernetes-bootstrap \&/g' /etc/rc.local