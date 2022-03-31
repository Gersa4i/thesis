# mar/31/2022 19:13:08 by RouterOS 6.49.4
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
add interface=ether2-trunk name=vlan1003-to-P2 vlan-id=1003
add interface=ether2-trunk name=vlan1004-to-P1 vlan-id=1004
add interface=ether2-trunk name=vlan1007-to-PE2 vlan-id=1007
add interface=ether2-trunk name=vlan1016-to-P4 vlan-id=1016
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
set default as=100
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] mpls-te-area=area1 mpls-te-router-id=\
    bridge1-loopback redistribute-bgp=as-type-1 router-id=10.1.1.3
/ip address
add address=172.20.0.3/24 interface=ether1-mgmt network=172.20.0.0
add address=10.1.1.3 interface=bridge1-loopback network=10.1.1.3
add address=192.168.0.21/30 interface=vlan1016-to-P4 network=192.168.0.20
add address=192.168.0.6/30 interface=vlan1004-to-P1 network=192.168.0.4
add address=192.168.0.34/30 interface=vlan1003-to-P2 network=192.168.0.32
add address=192.168.0.49/30 interface=vlan1007-to-PE2 network=192.168.0.48
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/mpls ldp
set enabled=yes lsr-id=10.1.1.3 transport-address=10.1.1.3
/mpls ldp interface
add interface=vlan1016-to-P4
add interface=vlan1004-to-P1
add interface=vlan1003-to-P2
add interface=vlan1007-to-PE2
/mpls traffic-eng interface
add bandwidth=1Mbps interface=vlan1003-to-P2
add bandwidth=1Mbps interface=vlan1004-to-P1
add bandwidth=1Mbps interface=vlan1016-to-P4
add bandwidth=1Mbps interface=vlan1007-to-PE2
/routing bgp peer
add address-families=l2vpn,vpnv4 name=RR1 remote-address=10.1.1.5 remote-as=\
    100 update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=RR2 remote-address=10.1.1.6 remote-as=\
    100 update-source=bridge1-loopback
/routing ospf network
add area=area1 network=192.168.0.20/30
add area=area1 network=192.168.0.48/30
add area=area1 network=192.168.0.4/30
add area=area1 network=192.168.0.32/30
add area=area1 network=10.1.1.3/32
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=P3
