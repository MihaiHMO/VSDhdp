#!/usr/bin/tclsh
set out_dir "output/sta"
set report [open $out_dir/build_report.html w+]
puts $report {<html>}
puts $report {<body><table border="1">}
puts $report {<tr><td colspan = "12"><h2>Static Timing analysis - Post Synth @CLK 100Mhz</h2></td></tr>}
puts $report {<tr><td colspan = "12"><h3>SRAM PVT TT, 25C, 1.8V</h3></td></tr>}
puts $report {<tr><td title ='sim number'><h3>Sim No.</h3></td>
		<td title ='pvt'><h3>PVT corner</h3></td>
		<td title ='s/e pointh'><h3>Start/endpoint(Hold)</h3></td>
		<td title ='s/e points'><h3>Start/endpoint(Setup)</h3></td>
		  <td title ='ns'><h3>Hold Slack</h3></td>
		  <td title ='ns'><h3>Setup Slack</h3></td>
		  <td title ='ns'><h3>TNS</h3></td>
		<td title ='MEM s/e pointh'><h3>Mem S/E (Hold)</h3></td>
		<td title ='MEM s/e points'><h3>Mem S/E (Setup)</h3></td>
		  <td title ='ns'><h3>Mem IF Hold Slack</h3></td>
		  <td title ='ns'><h3>Mem IF Setup Slack</h3></td></tr>}

set rpt [lsort [glob $out_dir/Post_Synth/*mm**.rpt]]

set count 1
foreach rpt_file $rpt {
	set m_filename  [lindex [split [file rootname [file tail $rpt_file]] _] 0]
 	set rd_report [open $rpt_file r]
	set filename_mem [regsub "mm" $rpt_file "mem" ]
	set mem_report [open $filename_mem r]
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
		
	while {[gets $tns_report line] != -1 } {
		set pattern {tns}
		if {[regexp $pattern $line]} {
		set total_negative_slack [lindex $line 1]
		
		}
	}
	close $tns_report
	
	set group_m 0
	while {[gets $mem_report line] != -1 } {
		set pattern {Startpoint:}
		if {[regexp $pattern $line ]} {	
			set mem_start($group_m) [lindex $line 1] 
	        } 		
		set pattern1 {Endpoint:}
		if {[regexp $pattern1 $line ]} {
			set mem_end($group_m) [lindex $line 1]
		}		
		set pattern2 {slack}	
		if {[regexp $pattern2 $line ]} {
			set mem_sla($group_m) [lindex [string map {"       " ""} $line] 0]
		incr group_m
		}
         }	
	close $mem_report

	set start0 $start(0)
	set start1 $start(1)
	set end0 $end(0)
	set end1 $end(1)
	set sla0 $sla(0)
	set sla1 $sla(1)
	set mem_start0 $mem_start(0)
	set mem_start1 $mem_start(1)
	set mem_end0 $mem_end(0)
	set mem_end1 $mem_end(1)
	set mem_sla0 $mem_sla(0)
	set mem_sla1 $mem_sla(1)
        puts $report "<td>$count</td><td><a href ='$rpt_file' target ='_blank'>$m_filename </a></td><td>$start0/$end0</td><td>$start1/$end1</td><td>$sla0</td><td>$sla1</td><td>$total_negative_slack</td><td>$mem_start0/$mem_end0</td><td>$mem_start1/$mem_end1</td><td>$mem_sla0</td><td>$mem_sla1</td></tr>"
	
	incr count		
}
puts $report {</table></body></html>}

#second report
set report [open $out_dir/build_report_graph.html w+]
puts $report {<html>}
puts $report {<body><table border="1">}
puts $report {<tr><td colspan = "6"><h1>Static Timing analysis - Post Synth</h1></td></tr>}
puts $report {<tr><td colspan = "6"><h2>SRAM PVT TT, 25C, 1.8V</h2></td></tr>}
puts $report {<tr><td title ='sim number'><h2>Sim No.</h2></td>
		<td title ='pvt'><h2>PVT corner</h2></td>
		<td title ='se pointh'><h2>Start/endpoint(Hold)</h2></td>
		<td title ='se points'><h2>Start/endpoint(Setup)</h2></td>
		  <td title ='ns'><h2>Hold Slack</h2></td>
		  <td title ='ns'><h2>Setup Slack</h2></td></tr>}

set mm_rpt [lsort [glob $out_dir/Post_Synth/graph/*.rpt]]

set count 1
foreach rpt_file $mm_rpt {
	set m_filename  [lindex [split [file rootname [file tail $rpt_file]] _] 0]
 	set rd_report [open $rpt_file r]
		
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
	
	
	set start0 $start(0)
	set start1 $start(1)
	set end0 $end(0)
	set end1 $end(1)
	set sla0 $sla(0)
	set sla1 $sla(1)
	puts $report "<td>$count</td><td><a href ='$rpt_file' target ='_blank'>$m_filename </a></td><td>$start0/$end0</td><td>$start1/$end1</td><td>$sla0</td><td>$sla1</td></tr>"
	
	incr count		
}
puts $report {</table></body></html>}
