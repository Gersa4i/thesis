# mar/31/2022 19:15:18 by RouterOS 6.49.4
# software id = 
#
#
#
/interface bridge
add name=bridge-vpls protocol-mode=none
add name=bridge1-loopback
/interface ethernet
set [ find default-name=ether1 ] disable-running-check=no name=ether1-mgmt
set [ find default-name=ether2 ] disable-running-check=no name=ether2-trunk
/interface vlan
add interface=ether2-trunk name=vlan200-vrf vlan-id=200
add interface=ether2-trunk name=vlan201-vpls vlan-id=201
add interface=ether2-trunk name=vlan1007-to-P3 vlan-id=1007
add interface=ether2-trunk name=vlan1008-to-P4 vlan-id=1008
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/mpls traffic-eng tunnel-path
add name=To-PE1 record-route=yes
/interface traffic-eng
add bandwidth=100kbps disabled=no name=To-PE1 primary-path=To-PE1 \
    record-route=yes to-address=10.1.1.7
/routing bgp instance
set default as=100 router-id=10.1.1.8
add as=100 client-to-client-reflection=no name="Client office 2" \
    redistribute-other-bgp=yes routing-table="Client office 2"
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] mpls-te-area=area1 mpls-te-router-id=\
    bridge1-loopback router-id=10.1.1.8
/interface bridge port
add bridge=bridge-vpls interface=vlan201-vpls
/interface vpls bgp-vpls
add bridge=bridge-vpls bridge-horizon=101 export-route-targets=1:2 \
    import-route-targets=1:2 name=vpls route-distinguisher=1:2 site-id=2
/ip address
add address=172.20.0.8/24 interface=ether1-mgmt network=172.20.0.0
add address=172.30.0.2/30 interface=vlan200-vrf network=172.30.0.0
add address=10.1.1.8 interface=bridge1-loopback network=10.1.1.8
add address=192.168.0.50/30 interface=vlan1007-to-P3 network=192.168.0.48
add address=192.168.0.53/30 interface=vlan1008-to-P4 network=192.168.0.52
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/ip route vrf
add export-route-targets=100:1 import-route-targets=100:1 interfaces=\
    vlan200-vrf route-distinguisher=100:1 routing-mark="Client office 2"
/mpls ldp
set enabled=yes lsr-id=10.1.1.8 transport-address=10.1.1.8
/mpls ldp interface
add interface=vlan1007-to-P3
add interface=vlan1008-to-P4
/mpls traffic-eng interface
add bandwidth=1Mbps interface=vlan1007-to-P3
add bandwidth=1Mbps interface=vlan1008-to-P4
/routing bgp instance vrf
add redistribute-other-bgp=yes routing-mark="Client office 2"
/routing bgp peer
add address-families=l2vpn,vpnv4 name=RR1 remote-address=10.1.1.5 remote-as=\
    100 update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=RR2 remote-address=10.1.1.6 remote-as=\
    100 update-source=bridge1-loopback
add instance="Client office 2" name=CE2 remote-address=172.30.0.1 remote-as=\
    65300 update-source=vlan200-vrf
/routing ospf network
add area=area1 network=192.168.0.48/30
add area=area1 network=192.168.0.52/30
add area=area1 network=10.1.1.8/32
add area=area1 network=172.30.0.0/30
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=PE2
