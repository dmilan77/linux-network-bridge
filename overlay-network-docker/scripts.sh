# node1 and node2
docker network prune
# node1
docker swarm init --advertise-addr=100.0.0.28
# node2
docker swarm join --token SWMTKN-1-079p3x2mnrpillk2sdumczlu0bi1v3adschrqr398km3o136wm-f1nf4904p4yir9owmkrth91dd 100.0.0.28:2377
docker node ls

# Overlay Network Creation on Node 1

# node 1
docker network create --driver=overlay --attachable kubeatl-overlay-net
docker network ls


# node1
docker run -it --name node1-alpine --network kubeatl-overlay-net dmilan/alpine-plus

# node 2
docker run -it --name node2-alpine  --network kubeatl-overlay-net dmilan/alpine-plus

# node1
ping -c 2 node2-alpine
nc -l -p 8083

#node2
ping -c 2 node1-alpine
nc node1-alpine 8083
