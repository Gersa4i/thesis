# mar/30/2022 23:00:52 by RouterOS 6.49.4
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
add interface=ether2-trunk name=vlan100-vrf vlan-id=100
add interface=ether2-trunk name=vlan101-vpls vlan-id=101
add interface=ether2-trunk name=vlan1009-to-P1 vlan-id=1009
add interface=ether2-trunk name=vlan1010-to-P2 vlan-id=1010
/interface wireless security-profiles
set [ find default=yes ] supplicant-identity=MikroTik
/mpls traffic-eng tunnel-path
add name=To-PE2 record-route=yes
/interface traffic-eng
add bandwidth=100kbps disabled=no name=To-PE2 primary-path=To-PE2 \
    record-route=yes to-address=10.1.1.8
/routing bgp instance
set default as=100 router-id=10.1.1.7
add as=100 client-to-client-reflection=no name="Client office 1" \
    redistribute-other-bgp=yes routing-table="Client office 1"
/routing ospf area
add area-id=0.0.0.1 name=area1
/routing ospf instance
set [ find default=yes ] mpls-te-area=area1 mpls-te-router-id=\
    bridge1-loopback router-id=10.1.1.7
/interface bridge port
add bridge=bridge-vpls interface=vlan101-vpls
/interface vpls bgp-vpls
add bridge=bridge-vpls bridge-horizon=101 export-route-targets=1:2 \
    import-route-targets=1:2 name=vpls route-distinguisher=1:2
/ip address
add address=172.20.0.7/24 interface=ether1-mgmt network=172.20.0.0
add address=172.29.0.1/30 interface=vlan100-vrf network=172.29.0.0
add address=10.1.1.7 interface=bridge1-loopback network=10.1.1.7
add address=192.168.0.14/30 interface=vlan1009-to-P1 network=192.168.0.12
add address=192.168.0.42/30 interface=vlan1010-to-P2 network=192.168.0.40
/ip route
add comment="Management Network" distance=1 dst-address=172.20.0.0/22 \
    gateway=172.20.0.254
/ip route vrf
add export-route-targets=100:1 import-route-targets=100:1 interfaces=\
    vlan100-vrf route-distinguisher=100:1 routing-mark="Client office 1"
/mpls ldp
set enabled=yes lsr-id=10.1.1.7 transport-address=10.1.1.7
/mpls ldp interface
add interface=vlan1009-to-P1
add interface=vlan1010-to-P2
/mpls traffic-eng interface
add bandwidth=1Mbps interface=vlan1009-to-P1
add bandwidth=1Mbps interface=vlan1010-to-P2
add interface=ether1-mgmt
/routing bgp instance vrf
add redistribute-other-bgp=yes routing-mark="Client office 1"
/routing bgp peer
add address-families=l2vpn,vpnv4 name=RR1 remote-address=10.1.1.5 remote-as=\
    100 update-source=bridge1-loopback
add address-families=l2vpn,vpnv4 name=RR2 remote-address=10.1.1.6 remote-as=\
    100 update-source=bridge1-loopback
add instance="Client office 1" name=CE1 remote-address=172.29.0.2 remote-as=\
    65350 update-source=vlan100-vrf
/routing ospf network
add area=area1 network=192.168.0.12/30
add area=area1 network=192.168.0.40/30
add area=area1 network=10.1.1.7/32
add area=area1 network=172.29.0.0/30
/system clock
set time-zone-name=Europe/Sofia
/system identity
set name=PE1
