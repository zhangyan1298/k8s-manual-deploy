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
###配置kube-proxy
##kube-proxy直接使用kubelet 的tls文件进行认证
###拷贝二进制文件与配置文件
##修改hostname
##更改proxymode，默认未iptables，如果iptables 错误那么将回退到userspace，这里使用
#ipvs
#--proxy-mode=ipvs
##--ipvs-scheduler=rr ,ipvs负载平衡算法
##支持的有 lc,dh,sh,sed,nq
#配置集群网络
#使用calico 三层路由模式，并开启tun隧道
#注意事项：calico 使用唯一的主机名来注册bgp网络，确保主机名唯一，如果修改了某个主机名那么可能node无法注册，需要先确认清空所有负载
#使用calicoctl delete nodename 删除后重信启动calico-node服务。
#配置calcioctl 可使用命令行或生成默认配置文件到/etc/calico/calicoctl.cfg 目录下
#官网下载calico.yml ，修改endpoints etcd地址，如果etcd开启了tls 那么加入tls，ca，key，cert 参数，修改volume 挂载configmap。
#calico文件包括一个kube-calico controller deployment 部署，一个calico-node pod daemonset，运行在集群内每台主机上，使用hostnetwor-true 模式
#calico包括felix，用来监控容器，设置容器ip,路由规则,iptables 等.bird 分发bgp peer 对等路由信息. confd 监控etcd 生成bird配置文件.
#参数注意实现ipipMode=always，开启ipip隧道模式，如果未开启则使用bgp模式下node 无法ping通pod 的ip，在公有云环境下开启ipipmode=always
#修改kubelet 的network-plugin=cni,可选参数--cni-conf-dir 插件的配置文件所在地--cni-bin-dir cni插件的bin文件目录
#docker 增加daemon.json 文件，开启独立群主机选项
#
