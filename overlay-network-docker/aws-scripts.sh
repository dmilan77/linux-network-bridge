apt-get update && \
apt install network-manager -y && \
apt install bridge-utils -y && \
apt install snapd -y  && \
apt install net-tools -y && \
snap install lxd
#apt install tshark -y


# node1 & node2
## Create vxlan
ip link add vxlan10 type vxlan id 10 group 239.1.1.1 dstport 0 dev eth0
## Create linux bridge 
ip link add br-vxlan10 type bridge
## connect bridge to vxlan
ip link set vxlan10 master br-vxlan10
## Start
ip link set vxlan10 up
ip link set br-vxlan10 up

# create a profile as per the options below
cat <<EOF | lxd init --preseed
config:
  images.auto_update_interval: "0"
networks: []
storage_pools:
- config:
    size: 15GB
  description: ""
  name: default
  driver: btrfs
profiles:
- config: {}
  description: ""
  devices:
    root:
      path: /
      pool: default
      type: disk
  name: default
cluster: null
EOF
########################

# Cretae a profile Attach profile to vxlan10
lxc profile create vxlan10
lxc network attach-profile br-vxlan10 vxlan10

# node1
lxc launch images:alpine/3.8 node1-alpine -p vxlan10 -s default
# wait sleep 10 # to wait for the container to be up and ready
lxc exec node1-alpine ip addr add 192.168.1.1/24 dev eth0

# node2
lxc launch images:alpine/3.8 node2-alpine -p vxlan10 -s default
lxc exec node2-alpine ip addr add 192.168.1.2/24 dev eth0


# testing
lxc exec node1-alpine -- nc -l -p 9999
lxc exec node2-alpine -- nc 192.168.1.1 9999
