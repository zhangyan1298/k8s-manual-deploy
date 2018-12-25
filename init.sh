#!/bin/bash
system_conf_dir=/usr/lib/systemd/system/
env_dir=/etc/sysconfig/
##initialization config need for kubernetes cluster node
#off virtual memory
swapoff -a
#delete mount config follow swap mount 
sed -i /swap/d /etc/fstab 
#enabled master to node tranfale ssh tun
sshd-keygen
#copy etcd conf and binary prog
cp bin/etcd* /usr/local/bin
cp etcd.service ${system_conf_dir}
cp etcd ${env_dir}
