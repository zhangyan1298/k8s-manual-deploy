#!/bin/bash
KUBE_APISERVER=https://10.0.0.4
KUBE_APISERVER=${KUBE_APISERVER:-default}
kubectl config set-cluster kubernetes \
  --certificate-authority=/etc/kubernetes/ssl/ca.pem \
  --embed-certs=true \
  --server=${KUBE_APISERVER} \
  --kubeconfig=kube-client.kubeconfig
kubectl config set-credentials kube-proxy \
  --token=3796fac2e6fae7a23aefb5b7fdb4d731 \
  --client-certificate=/etc/kubernetes/ssl/kube-client.pem \
  --embed-certs=true \
  --client-key=/etc/kubernetes/ssl/kube-client-key.pem \
  --kubeconfig=kube-client.kubeconfig
kubectl config set-context kubernetes \
  --cluster=kubernetes \
  --user=kube-proxy \
  --kubeconfig=kube-client.kubeconfig
kubectl config use-context kubernetes --kubeconfig=kube-client.kubeconfig
mv kube-client.kubeconfig /etc/kubernetes/ssl
