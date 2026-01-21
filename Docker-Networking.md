# Networking
- **Network namespaces** - Each Docker container runs inside its own network namespace, isolating its network stack from the host and other containers. This ensures that IP addresses, routing tables, and interfaces don't conflict across containers.
- **Virtual Ethernet interfaces (veth pairs)** - Docker uses veth pairs to connect containers to networks. One end is inside the container, and the other connects to a bridge or another network device on the host. 
- **Bridges** - A bridge acts like a virtual switch that forwards traffic between containers and the host. Docker automatically creates a default bridge to connect containers unless specified otherwise. 
- **Port mapping** - Containers can expose specific ports to the host using port mapping, This allows external clients to access containerized applications through the host's IP and a designated port. 
- **DNS Resolution** - Docker provides an internal DNS service that allows containers to resolve each other by name. This makes service discovery easier without needing to hardcode IP addresses.
- **Subnets and IP addressing** - Docker assigns containers IP addresses from configured subnets. This allows containers to communicate directly with each other within a network.
- **Routing** - Docker manages routing rules so that packets can move between containers, the host, and external networks. Containers follow the routing table defined by their network namespace
- **Firewall rules (iptables)** - Docker configures iptables rules to manage traffic between containers, hosts, and external networks. These rules enforce isolation and port forwarding

# Docker network types
1. **Bridge**: The default for standalone containers. It creates a private internal network on the host, and containers can communicate through it using IPs or container names.
2. **Host**: Removes network isolation by using the host's network stack directly. THis allows containers to share the host's IP and ports, which is useful for performance or compatibility needs. 
3. **none**: Disables networking completely. Useful for security or manual configuration.
4. **overlay**: Enables multi-host networking using Docker Swarm. It creates a distributed network across nodes, allowing containers on different hosts to communicate securely.
5. **macvlan**: Assigns a MAC address to each container, making it appear as a physical device on the network. Used for scenarios requiring full network integration, such as legacy apps.
6. **ipvlan**: Similar to macvlan but uses a different method for traffic handling. It's more efficient for high-denisity environments but less flexible.

# Bridge
Bridge networks create a software-based bridge between your host and the container. Containers connected to the network can communicate with each other, but they're isolated from those outside the network.  
Each container in the network is assigned its own IP address. Because the network is bridged to your host, containers can also communicate on your LAN and the Internet. However, they will not appear as physicaal devices on your LAN.

# host
Containers that use the host network mode share your host's network stack without any isolation. They aren't allocated their own IP addresses, and port binds will be published directly to your host's network interface. This means a container process that listens on port 80 will bind to <your_host_ip>:80

# none 
The none network type in Docker disables all networking for a container. It prevents the container from being connected to any external network, including the default bridge network.  
This means that no network interface besides lo (loopback) is created, and the container cannot communicate with other containers or the host. It's commonly used for containers that don't need network access, such as isolated tasks or for enhanced security.

# overlay
Overlay networks are distributed networks that span multiple Docker hosts. The network allows all the containers running on any of the hosts to communicate with each other without requiring OS-level routing support.  
Overlay networks implement the networking for Docker Swarm clusters, but you can also use them when you're running two separate instances of Docker Engine with containers that must directly contact each other. This allows you to build your own Swarm-like environments.

# ipvlan
IPvLAN is an advanced driver that offers precise control over the IPv4 and IPv6 addresses assigned to your containers, as well as layer 2 and 3 VLAN tagging and routing.  
This driver is useful when you're integrating containerized services with an existing physical network. IPvLAN networks are assigned their own interfaces, which offers performance benefits over bridge-based networking.

# macvlan 
macvlan is another advanced option that allows containers to appear as physical devices on your network. It works by assigning each container in the network aa unique MAC address.  
This network type requires you to dedicate one of your host's physical interfaces to the cirtual network. The wider network must also be appropriately configured to support the potentially large number of MAC addresses that could be created by an active Docker host running many containers.

# Creating networks
use command ```docker network create``` you can specify the driver to use like bridge or host by using the ```-d``` flag. Bridge is the default if no driver is specified  
example: ```docker network create demo-network -d bridge```

# Connecting containers to networks
To attach a new container to a network use the ```--network``` flag.  
example: ```docker run -it --rm --name container1 --network demo-network busybox:latest```

if I have another container running that isn't on the same network I can't ping it. To add a container to an existing network use ```docker network connect <network name> <container name>```  
example: ```docker network connect demo-network container2```

# Using host networking
```docker run -d --name nginx --network host nginx:latest```

# Disabling networking
to disable a containers network attach your container to the none network
```docker run -it --rm --network none busybox:latest```

# Removing containers from networks
to remove a container from a network use ```docker network disconnect <network name> <container name>```  
example: ```docker network disconnect demo-network container2```

# Managing networks
list all networks using the ```docket network ls``` command  
to delete a network ```docker network rm <network name>```  
to automatically delete all unused networks ```docker network prune```

# Using networks with Docker Compose
The services in your stack are automatically added to a shared bridge network, but it is possible to do manual networking as well.  
You can define additional networks in the docker compose file like so
```
version: "3"
services:
  app:
    image: php:7.2-apache
    networks:
      - db
  helper:
    image: custom-image:latest
  mysql:
    image: mysql:8.0
    environment:
      MYSQL_ROOT_PASSWORD=changeme
    networks:
      - db
networks:
  db:
```
Now app can only communicate with the mysql container because they are on the same network

link sections of a docker-compose file can be used to link services/service names. On startup by default a network is created and all of the containers/services are added onto that network, however, you can customize and set different networks for different containers.

# Questions
1. Bridge and host are the most common network types, when would you want to use others?
2. Is there a way to force delete a network even when the containers using it are still in use?