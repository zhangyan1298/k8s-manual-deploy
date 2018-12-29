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
####
#config kube-scheduler
#copy configure to /usr/lib/systemd/system
#copy binary to /usr/local/bin
#alert configure 
#config kube-controller-manager
#copy configure to /usr/lib/systemd/system
#copy binary to /usr/local/bin
#alert configure 
#config docker 
#remove exits docker old comoins
#config docker-ce repo
#1.sudo yum install -y yum-utils \
#  device-mapper-persistent-data \
#  lvm2
#2. sudo yum-config-manager \
#    --add-repo \
#    https://download.docker.com/linux/centos/docker-ce.repo
#3. list release docker info
#yum list docker-ce --showduplicates | sort -r
#4.install release docker-ce 
#sudo yum install docker-ce
#start docker-ce
#systemctl enable docker-ce
#systemctl start docker
#configure kubelet
#cp /home/opc/bootstrap.kubeconfig /etc/kubernetes/ssl/
#cp /home/opc/kubelet /usr/local/bin/
#cp kubelet.service /usr/lib/systemd/system/
#systemctl enable kubelet
#systemctl start kubelet
#alert configure for hostname
#--hostname-override=10.0.0.6
#如果这里的hostname设置了相同的值，那么master上只能显示出一个node，解决
#需要删除master签发的/etc/kubernetes/kubelet.kubeconfig 文件，修改hostname 重新注册
#配置集群网络
