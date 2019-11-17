i# Add Namespace
ip netns add red-ns
ip netns add blue-ns

# verify
tree /var/run/netns/
/var/run/netns/
├── red-ns
└── blue-ns

# Add link pairs (the ethernet cable)
ip link add veth-r type veth peer name br-veth-r
ip link add veth-b type veth peer name br-veth-b



# Connect Links to namespace
ip link set veth-r netns red-ns
ip link set veth-b netns blue-ns


# Start
ip link set br-veth-r up
ip link set br-veth-b up

ip netns exec red-ns ip link set veth-r up
ip netns exec blue-ns ip link set veth-b up

# assign ip address
ip netns exec red-ns ip addr add 192.168.1.11/24 dev veth-r
ip netns exec blue-ns ip addr add 192.168.1.12/24 dev veth-b

# verify ip address
ip netns exec red-ns ip address show
ip netns exec blue-ns ip address show

# Testing
# Ping blue from red
ip netns exec red-ns ping 192.168.1.12
# ping google DNS
ip netns exec red-ns ping 8.8.8.8


# Create the bridge device naming it `v-net-br`
# and set it up:
ip link add name v-net-br type bridge
ip link set v-net-br up
# Add ip to the bridge
ip addr add 192.168.1.10/24 brd + dev v-net-br



# Connect veth to the bridge
ip link set br-veth-r master v-net-br
ip link set br-veth-b master v-net-br

# Verify links
bridge link show br1

# Testing
# Ping blue from red
ip netns exec red-ns ping 192.168.1.12
# ping google DNS
ip netns exec red-ns ping 8.8.8.8

# Add default route table
ip -all netns exec ip route add default via 192.168.1.10

# Testing
# Ping blue from red
ip netns exec red-ns ping 192.168.1.12
# ping google DNS
ip netns exec red-ns ping 8.8.8.8


# Add NAT for external access
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1

# Testing
# Ping blue from red
ip netns exec red-ns ping 192.168.1.12
# ping google DNS 
ip netns exec red-ns ping 8.8.8.8
