#####  linux 环境
- 发行版 centos
- 版本 7(x86_64-Minimal-1810)
- [阿里云os下载地址](https://mirrors.aliyun.com/centos/7.6.1810/isos/x86_64/CentOS-7-x86_64-Minimal-1810.iso)
- VirtualBox 安装虚拟机, cpu 设置核数大于2
- 设置hosts
```
# vim /etc/hosts
192.168.1.77   master
192.168.1.223  node1
```
- 禁用防火墙
```
# systemctl stop firewalld
# systemctl disable firewalld
```
- 禁用SELINUX
```
# setenforce 0
# vim /etc/selinux/config
# 设置 SELINUX=disabled
```
- k8s.conf
```
vim /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
```
- 执行如下命令使修改生效
```
# modprobe br_netfilter
# sysctl -p /etc/sysctl.d/k8s.conf
```

##### 安装docker
- cd /etc/yum.repos.d && wget https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
- yum list docker-ce.x86_64 --showduplicates | sort -r 
```
#   Loading mirror speeds from cached hostfile
#   Loaded plugins: branch, fastestmirror, langpacks
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            @docker-ce-stable
#   docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable
#   Available Packages
```
- 选择你想要得版本，我使用了最新版本
```
# yum -y  install docker-ce 
```

- 设置自启动
```
# systemctl enable docker && systemctl start docker
```

- 安装 kubeadm、kubelet、kubectl K8S_VERSION=v1.15.3
```
# cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg
        http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF

# yum install -y  kubeadm kubelet  kubectl 
# kubelet --version //v1.15.3
```
- kubelet启动设置
```
# vim /etc/sysconfig/kubelet  
  KUBELET_EXTRA_ARGS="--fail-swap-on=false"
# systemctl daemon-reload  
```
####  master节点设置
- 下载相关镜像
``` bash
#!/bin/bash
# master 节点 shell
K8S_VERSION=v1.15.3
ETCD_VERSION=3.3.10
DNS_VERSION=1.3.1
PAUSE_VERSION=3.1
FLANNEL_VERSION=v0.11.0-amd64
DASHBOARD_VERSION=v1.10.1

// 下载镜像
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNS_VERSION
docker pull jmgao1983/flannel:$FLANNEL_VERSION
docker pull siriuszg/kubernetes-dashboard-amd64:$DASHBOARD_VERSION

# 修改tag
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$K8S_VERSION           k8s.gcr.io/kube-apiserver:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$K8S_VERSION  k8s.gcr.io/kube-controller-manager:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$K8S_VERSION           k8s.gcr.io/kube-scheduler:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION               k8s.gcr.io/kube-proxy:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION                  k8s.gcr.io/pause:$PAUSE_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION                    k8s.gcr.io/etcd:$ETCD_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNS_VERSION  			     k8s.gcr.io/coredns:$DNS_VERSION
docker tag jmgao1983/flannel:$FLANNEL_VERSION                              							 quay.io/coreos/flannel:$FLANNEL_VERSION
docker tag siriuszg/kubernetes-dashboard-amd64:$DASHBOARD_VERSION                                    k8s.gcr.io/kubernetes-dashboard-amd64:$DASHBOARD_VERSION

#删除冗余的images
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-apiserver:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-controller-manager:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-scheduler:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/etcd:$ETCD_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/coredns:$DNS_VERSION
docker rmi jmgao1983/flannel:$FLANNEL_VERSION
docker rmi siriuszg/kubernetes-dashboard-amd64:$DASHBOARD_VERSION
```

- 集群安装初始化
```
# kubeadm init --kubernetes-version=v1.15.3 --pod-network-cidr=10.244.0.0/16 --ignore-preflight-errors=Swap 

# 出现如下信息安装成功
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

kubeadm join 192.168.1.16:6443 --token 981it6.k4kqs2i73e1bfd1p \
    --discovery-token-ca-cert-hash sha256:5cc5c1c2ace7b720a178840c951b2a05c679d26b8d6a1cfc81aa7e006e6a6ef9 

```
- 查看集群健康状况
```
# kubectl get cs
```
- 集群安装过程中遇到问题，重置操作
```
# kubeadm reset
```
- 安装网络插件
```
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

- 查看集群中的组件运行状态
```
# kubectl get pods --all-namespaces
```

####  node节点设置
- 下载镜像
```
#!/bin/bash
# node 节点 shell
K8S_VERSION=v1.15.3
ETCD_VERSION=3.3.10
DNS_VERSION=1.3.1
PAUSE_VERSION=3.1
FLANNEL_VERSION=v0.11.0-amd64
DASHBOARD_VERSION=v1.10.1

## node 安装插件
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION
docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker pull jmgao1983/flannel:v0.11.0-amd64
docker pull siriuszg/kubernetes-dashboard-amd64:$DASHBOARD_VERSION


docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION  k8s.gcr.io/kube-proxy:$K8S_VERSION
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION     k8s.gcr.io/pause:$PAUSE_VERSION
docker tag jmgao1983/flannel:$FLANNEL_VERSION                                           quay.io/coreos/flannel:$FLANNEL_VERSION
docker tag siriuszg/kubernetes-dashboard-amd64:$DASHBOARD_VERSION                       k8s.gcr.io/kubernetes-dashboard-amd64:$DASHBOARD_VERSION


docker rmi jmgao1983/flannel:$FLANNEL_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/pause:$PAUSE_VERSION
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:$K8S_VERSION
docker rmi siriuszg/kubernetes-dashboard-amd64:$DASHBOARD_VERSION

```
- 加入节点
```
# kubeadm join 192.168.1.77:6443 --token 5oi47o.stqe7c5w1qo7wcr0 \
    --discovery-token-ca-cert-hash sha256:2387b0db19fa83e57ac094bf27a870a0381082c47c0f08bf9ef6277e24593fcd --ignore-preflight-errors=Swap
    
#出现下面就ok了, master节点， kubectl get nodes

This node has joined the cluster:
* Certificate signing request was sent to master and a response
  was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the master to see this node join the cluster.
```

####  安装 dashboard组件
- 集群配置，生成浏览器证书
```
# 生成client-certificate-data
grep 'client-certificate-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.crt

# 生成client-key-data
grep 'client-key-data' ~/.kube/config | head -n 1 | awk '{print $2}' | base64 -d >> kubecfg.key

# 生成p12
openssl pkcs12 -export -clcerts -inkey kubecfg.key -in kubecfg.crt -out kubecfg.p12 -name "kubernetes-client"

# 导入证书后浏览器重启

```

- 创建admin-user账号，并放在kube-system名称空间下
```
# vim admin-user.yaml

apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kube-system
  
#kubectl create -f admin-user.yaml
```

- 绑定角色
```
# vim admin-user-role-binding.yaml

apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kube-system
  
# kubectl create -f  admin-user-role-binding.yaml

```

- 获取Token
```
# kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')
```
- 登录dashboard
```
https://192.168.255.130:6443/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
```