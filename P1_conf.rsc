# mar/30/2022 22:40:24 by RouterOS 6.49.4
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
add interface=ether2-trunk name=vlan1001-to-RR1 vlan-id=1001
add interface=ether2-trunk name=vlan1002-to-P2 vlan-id=1002
add interface=ether2-trunk name=vlan1004-to-P3 vlan-id=1004
add interface=ether2-trunk name=vlan1006-to-P4 vlan-id=1006
add interface=ether2-trunk name=vlan1009-to-PE1 vlan-id=1009
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
set default as=100
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] mpls-te-area=area1 mpls-te-router-id=\
    bridge1-loopback router-id=10.1.1.1
/ip address
add address=172.20.0.1/24 comment=management interface=ether1-mgmt network=\
    172.20.0.0
add address=192.168.0.1/30 interface=vlan1002-to-P2 network=192.168.0.0
add address=10.1.1.1 interface=bridge1-loopback network=10.1.1.1
add address=192.168.0.5/30 interface=vlan1004-to-P3 network=192.168.0.4
add address=192.168.0.9/30 interface=vlan1006-to-P4 network=192.168.0.8
add address=192.168.0.13/30 interface=vlan1009-to-PE1 network=192.168.0.12
add address=192.168.0.25/30 interface=vlan1001-to-RR1 network=192.168.0.24
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/mpls ldp
set enabled=yes lsr-id=10.1.1.1 transport-address=10.1.1.1
/mpls ldp interface
add interface=vlan1002-to-P2
add interface=vlan1004-to-P3
add interface=vlan1006-to-P4
add interface=vlan1009-to-PE1
/mpls traffic-eng interface
add bandwidth=1Mbps interface=vlan1002-to-P2
add bandwidth=1Mbps interface=vlan1004-to-P3
add bandwidth=1Mbps interface=vlan1006-to-P4
add bandwidth=1Mbps interface=vlan1009-to-PE1
/routing bgp peer
add address-families=l2vpn,vpnv4 name=RR1 remote-address=10.1.1.5 remote-as=\
    100 update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=RR2 remote-address=10.1.1.6 remote-as=\
    100 update-source=bridge1-loopback
/routing ospf network
add area=area1 network=192.168.0.4/30
add area=area1 network=192.168.0.0/30
add area=area1 network=192.168.0.8/30
add area=area1 network=192.168.0.12/30
add area=area1 network=192.168.0.24/30
add area=area1 network=10.1.1.1/32
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=P1
