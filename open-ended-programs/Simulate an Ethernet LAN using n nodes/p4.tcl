#Create Simulator
set ns [new Simulator]

#Use colors to differentiate the traffic
$ns color 1 Blue
$ns color 2 Red

#Open trace and NAM trace file
set ntrace [open p4.tr w]
$ns trace-all $ntrace
set namfile [open p4.nam w]
$ns namtrace-all $namfile

#Finish Procedure
proc Finish {} {
global ns ntrace namfile

#Dump all trace data and close the files
$ns flush-trace
close $ntrace
close $namfile

#Execute the nam animation file
exec nam p4.nam &

#Calculate the throughput = (number of packets received/time taken for simulation)
set TcpSize [exec grep "^r" p4.tr | grep "tcp" | tail -n 1 | cut -d " " -f 6]
set numTcp [exec grep "^r" p4.tr | grep -c "tcp"]
set tcpTime 123.0
set UdpSize [exec grep "^r" p4.tr | grep "cbr" | tail -n 1 | cut -d " " -f 6]
set numUdp [exec grep "^r" p4.tr | grep -c "cbr"]
set udpTime 124.4
puts "The throughput of FTP is"
puts "[expr ($numTcp*$TcpSize)/$tcpTime] bytes per second"
puts "The throughput of CBR is"
puts "[expr ($numUdp*$UdpSize)/$udpTime] bytes per second"
exit 0
}

#Create 6 nodes
for {set i 0} {$i < 6} {incr i} {
set n($i) [$ns node]
}

#Create duplex links between the nodes
$ns duplex-link $n(0) $n(2) 2Mb 10ms DropTail
$ns duplex-link $n(1) $n(2) 2Mb 10ms DropTail
$ns simplex-link $n(2) $n(3) 0.3Mb 100ms DropTail
$ns simplex-link $n(3) $n(2) 0.3Mb 100ms DropTail

#Node n(3), n(4) and n(5) are considered in a LAN
set lan [$ns newLan "$n(3) $n(4) $n(5)" 0.5Mb 40ms LL Queue/DropTail MAC/802_3 Channel]

#Orientation to the nodes
$ns duplex-link-op $n(0) $n(2) orient right-down
$ns duplex-link-op $n(1) $n(2) orient right-up
$ns simplex-link-op $n(2) $n(3) orient right

#Setup queue between n(2) and n(3) and monitor the queue
$ns queue-limit $n(2) $n(3) 20
$ns simplex-link-op $n(2) $n(3) queuePos 0.5

#Set error model on link n(2) and n(3) and insert the error model
set loss_module [new ErrorModel]
$loss_module ranvar [new RandomVariable/Uniform]
$loss_module drop-target [new Agent/Null]
$ns lossmodel $loss_module $n(2) $n(3)

#Setup TCP Connection between n(0) and n(4)
set tcp0 [new Agent/TCP/Newreno]
$tcp0 set fid_ 1
$tcp0 set window_ 8000
$tcp0 set packetSize_ 552
$ns attach-agent $n(0) $tcp0
set sink0 [new Agent/TCPSink/DelAck]
$ns attach-agent $n(4) $sink0
$ns connect $tcp0 $sink0

#Apply FTP Application over TCP
set ftp0 [new Application/FTP]
$ftp0 set type_ FTP
$ftp0 attach-agent $tcp0

#Setup UDP Connection between n(1) and n(5)
set udp0 [new Agent/UDP]
$udp0 set fid_ 2
$ns attach-agent $n(1) $udp0
set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0
$ns connect $udp0 $null0

#Apply CBR Traffic over UDP
set cbr0 [new Application/Traffic/CBR]
$cbr0 set type_ CBR
$cbr0 set packetSize_ 1000
$cbr0 set rate_ 0.1Mb
$cbr0 set random_ false
$cbr0 attach-agent $udp0

#Schedule events
$ns at 0.1 "$cbr0 start"
$ns at 1.0 "$ftp0 start"
$ns at 124.0 "$ftp0 stop"
$ns at 124.5 "$cbr0 stop"
$ns at 125.0 "Finish"

#Run Simulation
$ns run