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
mkdir /var/lib/etcd
##alert etcd conf follow its's local ip
###--name tticar_k8s_m1 \
###--listen-peer-urls http://10.0.0.4:2380 \
###--initial-advertise-peer-urls http://10.0.0.4:2380 \
###--listen-client-urls http://10.0.0.4:2379,http://127.0.0.1:2379 \
###--advertise-client-urls http://10.0.0.4:2379 \
###
####cfssl gencert cert file
#生成default 配置需要修改后使用
#./cfssl print-defaults csr>ca-csr.json
#./cfssl print-defaults config>ca-config.json
#./cfssl gencert -initca ca-csr.json | cfssljson -bare ca -
#./cfssl print-defaults csr > server.json
#or follow 使用下面得配置
#echo '{"CN":"coreos1","hosts":[""],"key":{"algo":"rsa","size":2048}}' | cfssl gencert -ca=ca.pem -ca-key=ca-key.pem #-config=ca-config.json -profile=server -hostname="192.168.122.68,ext.example.com,coreos1.local,coreos1" - | cfssljson -bare server
#
mkdir -p /etc/kubernetes/ssl/
cp bin/cert/*  /etc/kubernetes/ssl/
#salt-cp "*" ./* /etc/kubernetes/ssl
##增加TLS 选项配置，etcd conf 增加如下行
#--cert-file=/etc/kubernetes/ssl/server.pem \
#--key-file=/etc/kubernetes/ssl/server-key.pem \
#--peer-cert-file=/etc/kubernetes/ssl/server.pem \
#--peer-key-file=/etc/kubernetes/ssl/server-key.pem \
#--trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
#--peer-trusted-ca-file=/etc/kubernetes/ssl/ca.pem \
