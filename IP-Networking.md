# Subnet Mask
**subnet mask** - 32-bit number used with an IP address to divide it into two parts:
- the network ID
- the host ID

In a subnet mask:
- 1's represent the network portion of the IP address
- 0's represent the host portion

The subnet mask helps a device determine whether another device is on the same local network or on a different network, which in turn decides whether communication is direct or must go through a router.

# Function of a Subnet Mask
- Separates an IP address into network ID and host ID
- Divides a large network into smaller subnets for better organization
- Improves network efficiency, security, and manageability by reducing unnecessary traffic.
- helps routers know whether a packet should be forwarded locally or to another network

In a network without subnetting, identifying a device involves three steps:
1. Identification of the network
2. Identification of the host
3. Identification of the process

When subnetting is applied there are 4 steps:
1. Identification of the network
2. Identification of the subnet
3. Identification of the host
4. Identification of the process

# Advatages of Subnetting
- **Reduces Congestion** limits broadcast traffic, improving network performance
- **Efficient IP Usage** Allocates IPs based on need, avoiding wastage
- **Enhanced Security** isolates sensitive data within specific subnets
- **Departmental Segmentation** Prioritizes traffic for specific teams or services
- **Scalable & Organized** makes network expansion easier and manageable

# Disadvantages of Subnetting
- **Fewer Usable Addresses** network and broadcast IDs reduce host capacity
- **Higher Hardware Costs** routers or layer-3 devices are often required
- **Complex Setup** needs careful planning and technical expertise
- **Compatibility Issues** legacy devices may not support modern subnets

# IP Addresses
Every device has a private IP address that connects it to the router which connects to the internet service provider (ISP).

The router has 1 public IP address that using NAT or network address translation can connect that device with the private IP address to the internet using the public IP address. This makes it possible to have multiple devices share the same public IP address

# 7 networking commands
- **ping** - sends a request to a host computer over an IP network, if the host is reachable it sends back a reply and reports the time it took to reach the host. ```ping www.facebook.com```

- **tracert** - traces the route between a source and the destination. It reports back the IP addresses of all the routers involved. ```tracert www.wikipedia.com```

- **ipconfig** is used to determine the TCP/IP network configuration

- **nslookup** is used to diagnose DNS issues. It looks up DNS records and how they map to IP addresses. ```nslookup www.google.com```

- **netstat** displays the network connections for TCP, routing tables, and the network protocols used

- **route** is used to display and make changes to routing tables


- **curl** stands for client url and can send and recieve HTTP requests

# Questions
1. I'm not seeing anything different when using the verbose flag, what is supposed to be different?
2. what are the different classes of subnetting used for?