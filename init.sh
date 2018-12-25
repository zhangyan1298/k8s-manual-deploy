#!/bin/bash
system_conf_dir=/usr/lib/systemd/system/
env_dir=/etc/sysconfig/
bin_dir=/usr/local/bin
##initialization config need for kubernetes cluster node
#off virtual memory
swapoff -a
#delete mount config follow swap mount 
sed -i /swap/d /etc/fstab 
#enabled master to node tranfale ssh tun
sshd-keygen
#copy etcd conf and binary prog
cp bin/etcd* ${bin_dir}
cp etcd.service ${system_conf_dir}
cp etcd ${env_dir}
chmod u+x ${bin}/etcd*
##alert etcd conf follow its's local ip
###--name tticar_k8s_m1 \
###--initial-advertise-peer-urls http://10.0.0.4:2380 \
###--listen-client-urls http://10.0.0.4:2379,http://127.0.0.1:2379 \
###--advertise-client-urls http://10.0.0.4:2379 \
