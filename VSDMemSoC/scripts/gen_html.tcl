#!/usr/bin/tclsh
set out_dir "../output/sta"
set report [open $out_dir/build_report.html w+]
puts $report {<html>}
puts $report {<body><table border="1">}
puts $report {<tr><td colspan = "9"><h1>Static Timing analysis - Post Synth</h1></td></tr>}
puts $report {<tr><td title ='sim number'><h2>Sim No.</h2></td>
		<td title ='pvt'><h2>PVT corner</h2></td>
		<td title ='se pointh'><h2>Start/endpoint(Hold)</h2></td>
		<td title ='se points'><h2>Start/endpoint(Setup)</h2></td>
		  <td title ='ns'><h2>Hold Slack</h2></td>
		  <td title ='ns'><h2>Setup Slack</h2></td>
		  <td title ='ns'><h2>WNS</h2></td>
		  <td title ='ns'><h2>FEP (Setup)</h2></td>
		  <td title ='ns'><h2>TNS</h2></td></tr>}

set mm_rpt [lsort [glob $out_dir/Post_Synth/*mm**.rpt]]

set count 1
foreach rpt_file $mm_rpt {
	set m_filename  [lindex [split [file rootname [file tail $rpt_file]] _] 0]
        
	set rd_report [open $rpt_file r]
	set filenamewns [regsub "mm" $rpt_file "wns" ]
	set wns_report [open $filenamewns r]
	set filenametns [regsub "mm" $rpt_file "tns" ]
	set tns_report [open $filenametns r]
	
	set group 0
	while {[gets $rd_report line] != -1 } {
		set pattern {Startpoint:}
		if {[regexp $pattern $line ]} {	
			set start($group) [lindex $line 1] 
	        } 		
		set pattern1 {Endpoint:}
		if {[regexp $pattern1 $line ]} {
			set end($group) [lindex $line 1]
		}		
		set pattern2 {slack}	
		if {[regexp $pattern2 $line ]} {
			set sla($group) [lindex [string map {"       " ""} $line] 0]
		incr group
		}
         }	
	close $rd_report
	while {[gets $wns_report line] != -1 } {
		set pattern {wns}
		if {[regexp $pattern $line]} {
			set worse_negative_slack [lindex $line 1]
			if {[lindex $line 1] < 0} {
				set failing_endpoint 1
				} else {
				set failing_endpoint "-"		
				}	
		}
		puts $failing_endpoint
		puts $worse_negative_slack
	}
	close $wns_report
	while {[gets $tns_report line] != -1 } {
		set pattern {tns}
		if {[regexp $pattern $line]} {
		set total_negative_slack [lindex $line 1]
		
		}
	}
	close $tns_report
	set start0 $start(0)
	set start1 $start(1)
	set end0 $end(0)
	set end1 $end(1)
	set sla0 $sla(0)
	set sla1 $sla(1)
        puts $report "<td>$count</td><td><a href ='$rpt_file' target ='_blank'>$m_filename </a></td><td>$start0/$end0</td><td>$start1/$end1</td><td>$sla0</td><td>$sla1</td><td>$worse_negative_slack</td><td>$failing_endpoint</td><td>$total_negative_slack</td></tr>"
	
	incr count		
}
puts $report {</table></body></html>}
