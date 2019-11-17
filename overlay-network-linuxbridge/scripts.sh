# node1 & node2
## Create vxlan
ip link add vxlan10 type vxlan id 10 group 239.1.1.1 dstport 0 dev eth1
## Create linux bridge 
ip link add br-vxlan10 type bridge
## connect bridge to vxlan
ip link set vxlan10 master br-vxlan10
## Start
ip link set vxlan10 up
ip link set br-vxlan10 up

# create a profile as per the options below
lxd init
########################
# root@node1:~# lxd init
# Would you like to use LXD clustering? (yes/no) [default=no]:
# Do you want to configure a new storage pool? (yes/no) [default=yes]:
# Name of the new storage pool [default=default]:
# Name of the storage backend to use (btrfs, ceph, dir, lvm) [default=btrfs]:
# Create a new BTRFS pool? (yes/no) [default=yes]:
# Would you like to use an existing block device? (yes/no) [default=no]:
# Size in GB of the new loop device (1GB minimum) [default=15GB]:
# Would you like to connect to a MAAS server? (yes/no) [default=no]:
# Would you like to create a new local network bridge? (yes/no) [default=yes]: no
# Would you like to configure LXD to use an existing bridge or host interface? (yes/no) [default=no]: no
# Would you like LXD to be available over the network? (yes/no) [default=no]:
# Would you like stale cached images to be updated automatically? (yes/no) [default=yes] no
# Would you like a YAML "lxd init" preseed to be printed? (yes/no) [default=no]:
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
