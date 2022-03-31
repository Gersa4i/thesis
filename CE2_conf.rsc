# mar/31/2022 19:15:54 by RouterOS 6.49.4
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
add interface=ether2-trunk name=vlan200-vrf vlan-id=200
add interface=ether2-trunk name=vlan201-vpls vlan-id=201
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
set default as=65300
/ip address
add address=172.20.0.22/24 interface=ether1-mgmt network=172.20.0.0
add address=172.30.0.1/30 interface=vlan200-vrf network=172.30.0.0
add address=10.1.1.10 interface=bridge1-loopback network=10.1.1.10
add address=192.168.2.1/24 interface=bridge2-client-network network=\
    192.168.2.0
add address=192.168.101.2/24 interface=vlan201-vpls network=192.168.101.0
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/mpls ldp
set enabled=yes lsr-id=10.1.1.10 transport-address=10.1.1.10
/mpls ldp interface
add interface=ether2-trunk transport-address=10.1.1.10
/routing bgp network
add network=192.168.2.0/24
/routing bgp peer
add name=PE2 remote-address=172.30.0.2 remote-as=100 update-source=\
    vlan200-vrf
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=CE2
