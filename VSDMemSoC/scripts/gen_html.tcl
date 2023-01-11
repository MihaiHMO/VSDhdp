#!/usr/bin/tclsh

set report [open build_report.html w+]
puts $report {<html>}
puts $report {<body><table border="1">}
puts $report {<tr><td colspan = "9'><h1>Static Timing analisis</h1></td></tr>}
puts $report {<tr><td title ='sim number`><h2> Sr. No</h2></td>
			      <td title ='pvt`><h2> PVT corner</h2></td>
			      <td title ='s/e pointh`><h2> Start/endpoint(Hold)</h2></td>
				  <td title ='s/e points`><h2> Start/endpoint(Setup)</h2></td>
				  <td title ='ns`><h2>Hold Slack</h2></td></tr>
				  <td title ='ns`><h2>Setup Slack</h2></td>
				  <td title ='ns`><h2>WNS</h2></td>
				  <td title ='ns`><h2>FEP (Setup)</h2></td>
				  <td title ='ns`><h2>TNS</h2></td>
				  }
set rpt_file [lsort [glob output/STA/Post_synth/minmax/*.rpt]]
set count 1
foreach rpt $rpt_file {
        incr count
		set filename  [lindex [split [file rootname [file tail $rpt]] _] 0] 
		put $report "<tr><td>$count</td><td><a href= 'rpt' target='_blank'>$filename </a></td></tr>"
		
}



puts $report {</table></body></html>}