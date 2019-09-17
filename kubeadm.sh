#!/bin/bash
# master 节点 shell
K8S_VERSION=v1.15.3
ETCD_VERSION=3.3.10
DNS_VERSION=1.3.1
PAUSE_VERSION=3.1
FLANNEL_VERSION=v0.11.0-amd64

#k8s.gcr.io/kube-apiserver:v1.15.3
#k8s.gcr.io/kube-controller-manager:v1.15.3
#k8s.gcr.io/kube-scheduler:v1.15.3
#k8s.gcr.io/kube-proxy:v1.15.3
#k8s.gcr.io/pause:3.1
#k8s.gcr.io/etcd:3.3.10
#k8s.gcr.io/coredns:1.3.1


docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNS_VERSION
docker pull jmgao1983/flannel:$FLANNEL_VERSION
docker pull quay.io/kubernetes-ingress-controller/nginx-ingress-controller:0.25.1

# 修改tag
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$K8S_VERSION           k8s.gcr.io/kube-apiserver:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$K8S_VERSION  k8s.gcr.io/kube-controller-manager:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$K8S_VERSION           k8s.gcr.io/kube-scheduler:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION               k8s.gcr.io/kube-proxy:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION                  k8s.gcr.io/pause:$PAUSE_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION                    k8s.gcr.io/etcd:$ETCD_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNS_VERSION  			     k8s.gcr.io/coredns:$DNS_VERSION
docker tag jmgao1983/flannel:$FLANNEL_VERSION                              							 quay.io/coreos/flannel:$FLANNEL_VERSION

#删除冗余的images
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNS_VERSION
docker rmi jmgao1983/flannel:$FLANNEL_VERSION

docker tag daocloud.io/yxl1992/swoft-file:master  registry.cn-hangzhou.aliyuncs.com/bruin-tech/swoft:latest

##### node
#
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:v1.15.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:v1.15.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:v1.15.3
##docker pull cnych/k8s-dns-kube-dns-amd64:1.14.8
#docker pull cnych/k8s-dns-dnsmasq-nanny-amd64:1.14.8
#docker pull cnych/k8s-dns-sidecar-amd64:1.14.8
#docker pull cnych/etcd-amd64:3.1.12
#docker pull cnych/flannel:v0.10.0-amd64
#docker pull cnych/pause-amd64:3.1
#
#
### node 安装插件
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.15.3
#docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
#docker pull jmgao1983/flannel:v0.11.0-amd64
#
#
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.15.3               k8s.gcr.io/kube-proxy:v1.15.3
#docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1                        k8s.gcr.io/pause:3.1
#docker tag jmgao1983/flannel:v0.11.0-amd64                                                      quay.io/coreos/flannel:v0.11.0-amd64
#
#
#docker rmi jmgao1983/flannel:v0.11.0-amd64
#docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:3.1
#docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.15.3









