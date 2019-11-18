
# node1
docker network ls
ip a
docker swarm init --advertise-addr=172.31.23.174
docker network ls
docker network rm wdptejml5nr4
docker network create --driver=overlay --attachable kubeatl-overlay-net
docker network ls
docker swarm join-token manager

#node 2
docker swarm join --token SWMTKN-1-1eumpzznnpt3e0osfwfgh968c2hbzjkg52t72pd4yhldbn6ndl-86gfaoyzgaih9ekzvn45iuxvr 172.31.23.174:2377
docker network ls

#node 1
docker run -it --name node1-alpine --network kubeatl-overlay-net dmilan/alpine-plus

#node 2
docker run -it --name node2-alpine  --network kubeatl-overlay-net dmilan/alpine-plus



# node1
ping -c 2 node2-alpine
nc -l -p 8083

#node2
ping -c 2 node1-alpine
nc node1-alpine 8083
