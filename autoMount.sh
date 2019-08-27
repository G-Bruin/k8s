#!/bin/bash
# chkconfig:   2345 10 90
# command: chkconfig --add autoMount.sh && chkconfig autoMount.sh on
# description:  自动mount， 关闭swap 启动 kubelet
mount -t vboxsf code  /var/code
swapoff -a
systemctl daemon-reload
systemctl restart kubelet