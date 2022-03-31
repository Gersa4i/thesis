# mar/31/2022 19:13:35 by RouterOS 6.49.4
# software id = 
#
#
#
/interface bridge
add name=bridge1-loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=ether1-mgmt
set [ find default-name=ether2 ] disable-running-check=no name=ether2-trunk
/interface vlan
add interface=ether2-trunk name=vlan1005-to-P2 vlan-id=1005
add interface=ether2-trunk name=vlan1006-to-P1 vlan-id=1006
add interface=ether2-trunk name=vlan1008-to-PE2 vlan-id=1008
add interface=ether2-trunk name=vlan1011-to-RR2 vlan-id=1011
add interface=ether2-trunk name=vlan1016-to-P3 vlan-id=1016
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
set default as=100
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] mpls-te-area=area1 mpls-te-router-id=\
    bridge1-loopback redistribute-bgp=as-type-1 router-id=10.1.1.4
/ip address
add address=172.20.0.4/24 interface=ether1-mgmt network=172.20.0.0
add address=10.1.1.4 interface=bridge1-loopback network=10.1.1.4
add address=192.168.0.22/30 interface=vlan1016-to-P3 network=192.168.0.20
add address=192.168.0.54/30 interface=vlan1008-to-PE2 network=192.168.0.52
add address=192.168.0.10/30 interface=vlan1006-to-P1 network=192.168.0.8
add address=192.168.0.38/30 interface=vlan1005-to-P2 network=192.168.0.36
add address=192.168.0.58/30 interface=vlan1011-to-RR2 network=192.168.0.56
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/mpls ldp
set enabled=yes lsr-id=10.1.1.4 transport-address=10.1.1.4
/mpls ldp interface
add interface=vlan1016-to-P3 transport-address=10.1.1.4
add interface=vlan1006-to-P1 transport-address=10.1.1.4
add interface=vlan1005-to-P2 transport-address=10.1.1.4
add interface=vlan1008-to-PE2
/mpls traffic-eng interface
add bandwidth=1Mbps interface=vlan1005-to-P2
add bandwidth=1Mbps interface=vlan1006-to-P1
add bandwidth=1Mbps interface=vlan1016-to-P3
add bandwidth=1Mbps interface=vlan1008-to-PE2
/routing bgp peer
add address-families=l2vpn,vpnv4 name=RR1 remote-address=10.1.1.5 remote-as=\
    100 update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=RR2 remote-address=10.1.1.6 remote-as=\
    100 update-source=bridge1-loopback
/routing ospf network
add area=area1 network=192.168.0.20/30
add area=area1 network=192.168.0.52/30
add area=area1 network=192.168.0.8/30
add area=area1 network=192.168.0.36/30
add area=area1 network=192.168.0.56/30
add area=area1 network=10.1.1.4/32
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=P4
