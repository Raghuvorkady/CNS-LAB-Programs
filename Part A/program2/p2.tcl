# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(stop)   20.0                         ;# time of simulation end

#===================================
#        Initialization        
#===================================

Agent/Ping instproc recv {from rtt} {
$self instvar node_
puts "node [$node_ id] received ping answer from \ $from with round-trip-time $rtt ms."
}

#Create a ns simulator
set ns [new Simulator]

#Open the NS trace file
set tracefile [open p2.tr w]
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open p2.nam w]
$ns namtrace-all $namfile

#===================================
#        Nodes Definition        
#===================================
#Create 6 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

#===================================
#        Links Definition        
#===================================
#Createlinks between nodes
$ns duplex-link $n0 $n1 10.0Mb 10ms DropTail
$ns queue-limit $n0 $n1 5
$ns duplex-link $n1 $n2 1.0Mb 10ms DropTail
$ns queue-limit $n1 $n2 3
$ns duplex-link $n2 $n3 0.1Mb 10ms DropTail
$ns queue-limit $n2 $n3 2
$ns duplex-link $n3 $n4 100.0Mb 10ms DropTail
$ns queue-limit $n3 $n4 10
$ns duplex-link $n4 $n5 10.0Mb 10ms DropTail
$ns queue-limit $n4 $n5 5
$ns duplex-link $n5 $n0 0.1Mb 10ms DropTail
$ns queue-limit $n5 $n0 2

#Give node position (for NAM)
$ns duplex-link-op $n0 $n1 orient right-up
$ns duplex-link-op $n1 $n2 orient right
$ns duplex-link-op $n2 $n3 orient right-down
$ns duplex-link-op $n3 $n4 orient left-down
$ns duplex-link-op $n4 $n5 orient left

$ns duplex-link-op $n5 $n0 orient left-up

#===================================
#        Agents Definition        
#===================================

set PingAgent1 [new Agent/Ping]
$ns attach-agent $n0 $PingAgent1
set PingAgent2 [new Agent/Ping]
$ns attach-agent $n1 $PingAgent2
set PingAgent3 [new Agent/Ping]
$ns attach-agent $n2 $PingAgent3
set PingAgent4 [new Agent/Ping]
$ns attach-agent $n3 $PingAgent4
set PingAgent5 [new Agent/Ping]
$ns attach-agent $n4 $PingAgent5
set PingAgent6 [new Agent/Ping]
$ns attach-agent $n5 $PingAgent6

#===================================
#        Applications Definition        
#===================================

$ns connect $PingAgent1 $PingAgent2
$ns connect $PingAgent2 $PingAgent3
$ns connect $PingAgent3 $PingAgent4
$ns connect $PingAgent4 $PingAgent5
$ns connect $PingAgent5 $PingAgent6
$ns connect $PingAgent6 $PingAgent1



$ns at 0.1 "$PingAgent1 send"
$ns at 0.1 "$PingAgent2 send"
$ns at 0.1 "$PingAgent3 send"
$ns at 0.1 "$PingAgent4 send"
$ns at 0.1 "$PingAgent5 send"
$ns at 0.1 "$PingAgent6 send"
$ns at 0.1 "$PingAgent1 send"
$ns at 0.1 "$PingAgent2 send"
$ns at 0.1 "$PingAgent3 send"
$ns at 0.1 "$PingAgent4 send"
$ns at 0.1 "$PingAgent5 send"
$ns at 0.1 "$PingAgent6 send"
$ns at 0.1 "$PingAgent1 send"
$ns at 0.1 "$PingAgent2 send"
$ns at 0.1 "$PingAgent3 send"
$ns at 0.1 "$PingAgent4 send"
$ns at 0.1 "$PingAgent5 send"
$ns at 0.1 "$PingAgent6 send"
$ns at 0.1 "$PingAgent1 send"
$ns at 0.1 "$PingAgent2 send"
$ns at 0.1 "$PingAgent3 send"
$ns at 0.1 "$PingAgent4 send"
$ns at 0.1 "$PingAgent5 send"
$ns at 0.1 "$PingAgent6 send"
$ns at 0.1 "$PingAgent1 send"
$ns at 0.1 "$PingAgent2 send"
$ns at 0.1 "$PingAgent3 send"
$ns at 0.1 "$PingAgent4 send"
$ns at 0.1 "$PingAgent5 send"
$ns at 0.1 "$PingAgent6 send"


#===================================
#        Termination        
#===================================
#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam p2.nam &
    exit 0
}
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run

#To check Number of Packets dropped use following command
#grep -c "^d" p2.tr