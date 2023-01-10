#!/usr/bin/tclsh

set lib_dir [lsort [glob lib_dir/*.lib]]
#puts "$lib_dir"
set verilog_file [glob output/*.v]

foreach libs $lib_dir {
		#puts "$libs"
		
		#Naming convention, make directory and input Open STA commands 
		#set filename [string map {"_" ""}[string map {"__" ""}[lindex [split [file rootname [file tail $libs]] hd]3]]]
		set filename [string map {" " ""} [lrange [split [file rootname [file tail $libs]] __] end-2 end] ]
		#puts "$filename"
		#set ext [file extention [file tail $libs]]
		#set stage [string map {".lib""_Post_Synth"} $ext ]
		read_liberty $libs 
		set synth_file_path [lindex $verilog_file 0]
		set filemane_synth1 [string map {"vsdmemsoc""Post"} [lindex [split [file rootname [file tail $synth_file_path]].]0]]
		set filemane_synth2 [string totitle [lindex [split [file rootname [file tail $synth_file_path]].]1]]
		mkdir -p output/STA/$filemane_synth1\_&filemane_synth2/minmax
		mkdir -p output/STA/$filemane_synth1\_&filemane_synth2/wns
		mkdir -p output/STA/$filemane_synth1\_&filemane_synth2/tns
		
		if {[file exists $synth_file_path]}{
		#lib/sky130_fd_sc_hd__tt_025C_1v80.lib
		read_liberty  lib/sram_32_256_sky130A_TT_1p8V_25C.lib
		read_verilog $synth_file_path
		link_design vsdmemsoc
		#read_sdc -echo ..///vsdmemsoc.sdc
				
		set_units -time ns
		create_clock [get_ports -of_objects [get_nets CLK]] -name clk -period 14.5
		
		#checks commnad -synthesis 
		report_checks -path_delay min -group_count 1000 -endpoint_count 1000 -unique_paths_to_endpoint -fields {nets cap slew input_pins} -digits {4} > output/STA/$filemane_synth1/minmax/$filename$stage\_$filemane_synth2/minmax/$filename\_$filemane_synth1\_$filemane_synth2\_minmax.rpt
		report_tns -digits {4} > output/STA/$filemane_synth1/minmax/$filename$stage\_$filemane_synth2/wns/$filename\_$filemane_synth1\_$filemane_synth2\_wns.rpt
		report_wns -digits {4} > output/STA/$filemane_synth1/minmax/$filename$stage\_$filemane_synth2/tns/$filename\_$filemane_synth1\_$filemane_synth2\_tns.rpt
		}
		
		set cts_file_path [lindex $verilog_file 1]
		et filemane_cts [string toupper [lindex [split [lindex [split [file rootname [file tail $cts_file_path] ].]1] _] 1] ]
		mkdir -p output/STA/$filemane_cts/minmax
		mkdir -p output/STA/$filemane_cts/wns
		mkdir -p output/STA/$filemane_cts/tns
		
		if {[file exists $cts_file_path]}{
		#lib/sky130_fd_sc_hd__tt_025C_1v80.lib
		read_liberty  lib/sram_32_256_sky130A_TT_1p8V_25C.lib
		read_verilog $synth_file_path
		link_design vsdmemsoc
		read_sdc -echo ..///vsdmemsoc.sdc
				
		#checks commnad - CTS 
		report_checks -path_delay min -group_count 1000 -endpoint_count 1000 -unique_paths_to_endpoint -fields {nets cap slew input_pins} -digits {4} > output/STA/$filemane_cts/minmax/$filemane_cts/minmax/$filename\_$filemane_cts\_minmax.rpt
		report_tns -digits {4} > output/STA/$filemane_synth1/minmax/$filemane_cts/wns/$filename\_$filemane_cts\_wns.rpt
		report_wns -digits {4} > output/STA/$filemane_synth1/minmax/$filemane_cts/tns/$filename\_$filemane_cts\_tns.rpt

}