set stop 100
set type cdma

set minth 30
set maxth 0
set adaptive 1

set flows 0
set window 30

set opt(wrap) 100
set opt(srcTrace) is
set opt(dstTrace) bs2

set bwDL(cdma) 384000

set propDL(cdma) .150

set ns [new Simulator]

set tf [open p6.tr w]
$ns trace-all $tf

set nodes(is) [$ns node]
set nodes(ms) [$ns node]
set nodes(bs1) [$ns node]
set nodes(bs2) [$ns node]
set nodes(lp) [$ns node]

proc cell_topo {} {
global ns nodes
$ns duplex-link $nodes(lp) $nodes(bs1) 3Mbps 10ms DropTail
$ns duplex-link $nodes(bs1) $nodes(ms) 1 1 RED
$ns duplex-link $nodes(ms) $nodes(bs2) 1 1 RED
$ns duplex-link $nodes(bs2) $nodes(is) 3Mbps 10ms DropTail
puts "cdma Cell Topolgy"
}

proc set_link_para {t} {
global ns nodes bwDL propDL
$ns bandwidth $nodes(bs1) $nodes(ms) $bwDL($t) duplex
$ns bandwidth $nodes(bs2) $nodes(ms) $bwDL($t) duplex

$ns delay $nodes(bs1) $nodes(ms) $propDL($t) duplex
$ns delay $nodes(bs2) $nodes(ms) $propDL($t) duplex

$ns queue-limit $nodes(bs1) $nodes(ms) 20
$ns queue-limit $nodes(bs2) $nodes(ms) 20
}

Queue/RED set adaptive_ $adaptive
Queue/RED set thresh_ $minth
Queue/RED set maxthresh_ $maxth
Agent/TCP set window_ $window

switch $type {
cdma {cell_topo}
}

set_link_para $type
$ns insert-delayer $nodes(ms) $nodes(bs1) [new Delayer]
$ns insert-delayer $nodes(ms) $nodes(bs2) [new Delayer]

if {$flows ==0} {
set tcp1 [$ns create-connection TCP/Sack1 $nodes(is) TCPSink/Sack1 $nodes(lp) 0]
set ftp1 [[set tcp1] attach-app FTP]
$ns at 0.8 "[set ftp1] start"
}

proc stop {} {
global nodes opt tf
set wrap $opt(wrap)
set sid [$nodes($opt(srcTrace)) id]
set did [$nodes($opt(dstTrace)) id]

set a "p6.tr"

set GETRC "/home/raghavendrakm/ns-allinone-2.35/ns-2.35/bin/getrc"
set RAW2XG "/home/raghavendrakm/ns-allinone-2.35/ns-2.35/bin/raw2xg"

exec $GETRC -s $sid -d $did -f 0 p6.tr | \
$RAW2XG -s 0.01 -m $wrap -r > p6.xgr

exec $GETRC -s $did -d $sid -f 0 p6.tr | \
$RAW2XG -a -s 0.01 -m $wrap >> p6.xgr

exec xgraph -x time -y packets p6.xgr &
exit 0
}
$ns at $stop "stop"
$ns run