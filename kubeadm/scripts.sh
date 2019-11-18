# https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-init/
# https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/
# https://docs.projectcalico.org/v3.10/getting-started/kubernetes/
# Turn off swap
swapoff -a  && \
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab 


# Install Docker
apt update && \
apt-get -y install apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
wget https://download.docker.com/linux/debian/dists/jessie/pool/stable/amd64/containerd.io_1.2.6-3_amd64.deb -O /tmp/containerd.io_1.2.6-3_amd64.deb && \
wget https://download.docker.com/linux/debian/dists/jessie/pool/stable/amd64/docker-ce_18.06.3~ce~3-0~debian_amd64.deb  -O /tmp/docker-ce_18.06.3~ce~3-0~debian_amd64.deb && \
apt-get install libltdl7 -y && \
dpkg -i /tmp/containerd.io_1.2.6-3_amd64.deb && \
dpkg -i /tmp/docker-ce_18.06.3~ce~3-0~debian_amd64.deb

# Install kubeadm  kubelet kubernetes-cni
apt-get update && sudo apt-get install -y apt-transport-https && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -  && \
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" |  tee -a /etc/apt/sources.list.d/kubernetes.list &&  apt-get update  && \
apt install -y kubeadm  kubelet kubernetes-cni

#for flannel
kubeadm init --pod-network-cidr=10.244.0.0/16 --service-cidr=10.243.0.0/16

# for calico
kubeadm init --pod-network-cidr=192.168.0.0/16 --service-cidr=192.169.0.0/16



==========================
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubeadm join 172.31.22.231:6443 --token x3jwlb.yah3ydgm5ka1hbsc \
    --discovery-token-ca-cert-hash sha256:4a6346c647a8e7fe3bf64590fc943690348da4d0d53a320398dd58001ed96fbc

=====================
# Install flannel network adapter
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml

# For Calico
kubectl apply -f https://docs.projectcalico.org/v3.10/manifests/calico.yaml

# Check all pods
watch kubectl get pods --all-namespaces

# Remove the Taints for single node cluster
kubectl taint nodes --all node-role.kubernetes.io/master-
