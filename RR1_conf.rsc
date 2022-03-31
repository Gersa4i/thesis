# mar/30/2022 22:57:09 by RouterOS 6.49.4
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
add interface=ether2-trunk name=vlan1001-to-P1 vlan-id=1001
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/routing bgp instance
set default as=100 router-id=10.1.1.5
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] router-id=10.1.1.5
/ip address
add address=172.20.0.5/24 interface=ether1-mgmt network=172.20.0.0
add address=10.1.1.5 interface=bridge1-loopback network=10.1.1.5
add address=192.168.0.26/30 interface=vlan1001-to-P1 network=192.168.0.24
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/mpls ldp
set lsr-id=10.1.1.5 transport-address=10.1.1.5
/routing bgp peer
add address-families=l2vpn,vpnv4 name=P1 remote-address=10.1.1.1 remote-as=\
    100 route-reflect=yes update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=P2 remote-address=10.1.1.2 remote-as=\
    100 route-reflect=yes update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=P3 remote-address=10.1.1.3 remote-as=\
    100 route-reflect=yes update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=P4 remote-address=10.1.1.4 remote-as=\
    100 route-reflect=yes update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=PE1 remote-address=10.1.1.7 remote-as=\
    100 route-reflect=yes update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=PE2 remote-address=10.1.1.8 remote-as=\
    100 route-reflect=yes update-source=bridge1-loopback
/routing ospf network
add area=area1 network=192.168.0.24/30
add area=area1 network=10.1.1.5/32
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=RR1
