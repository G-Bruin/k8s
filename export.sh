#!/bin/bash
K8S_VERSION=v1.15.3
ETCD_VERSION=3.3.10
DNS_VERSION=1.3.1
PAUSE_VERSION=3.1
FLANNEL_VERSION=v0.11.0-amd64

if [ $1 == "save" ]
	then

	docker save -o kube-apiserver.tar       k8s.gcr.io/kube-apiserver:$K8S_VERSION
	docker save -o kube-controller.tar      k8s.gcr.io/kube-controller-manager:$K8S_VERSION
	docker save -o kube-scheduler.tar       k8s.gcr.io/kube-scheduler:$K8S_VERSION
	docker save -o kube-proxy.tar           k8s.gcr.io/kube-proxy:$K8S_VERSION
	docker save -o pause.tar                k8s.gcr.io/pause:$PAUSE_VERSION
	docker save -o etcd.tar                 k8s.gcr.io/etcd:$ETCD_VERSION
	docker save -o coredns.tar              k8s.gcr.io/coredns:$DNS_VERSION
	docker save -o flannel.tar              quay.io/coreos/flannel:$FLANNEL_VERSION
fi

if [ $1 == "load" ]
	then

	docker load -i kube-apiserver.tar  && \
	docker load -i kube-controller.tar && \
	docker load -i kube-scheduler.tar && \
	docker load -i kube-proxy.tar      && \
	docker load -i etcd.tar    && \
	docker load -i coredns.tar    && \
	docker load -i flannel.tar
    docker load -i pause.tar


fi

if [ $1 == "node" ]
	then

	docker load -i kube-proxy.tar
	docker load -i pause.tar
	docker load -i flannel.tar

fi