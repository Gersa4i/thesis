# mar/30/2022 23:03:02 by RouterOS 6.49.4
# software id = 
#
#
#
/interface bridge
add name=bridge1-loopback
add name=bridge2-client-network
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=ether1-mgmt
set [ find default-name=ether2 ] disable-running-check=no name=ether2-trunk
/interface vlan
add interface=ether2-trunk name=vlan100-vrf vlan-id=100
add interface=ether2-trunk name=vlan101-vpls vlan-id=101
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
set default as=65350
/ip address
add address=172.20.0.21/24 interface=ether1-mgmt network=172.20.0.0
add address=172.29.0.2/30 interface=vlan100-vrf network=172.29.0.0
add address=10.1.1.9 interface=bridge1-loopback network=10.1.1.9
add address=192.168.1.1/24 interface=bridge2-client-network network=\
    192.168.1.0
add address=192.168.101.1/24 interface=vlan101-vpls network=192.168.101.0
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/mpls ldp
set lsr-id=10.1.1.9 transport-address=10.1.1.9
/routing bgp network
add network=192.168.1.0/24
/routing bgp peer
add name=PE1 remote-address=172.29.0.1 remote-as=100 update-source=\
    vlan100-vrf
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=CE1
