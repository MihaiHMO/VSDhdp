#!/usr/bin/tclsh

set out_dir "output/sta"
set lib_dir [lsort [glob lib/*sky130_fd**.lib]]
set verilog_file [glob output/synth/*.v]
read_liberty lib/sram_32_256_sky130A_TT_1p8V_25C.lib
set synth_file_path [lindex $verilog_file 0]
set filemane_synth1 [string map {"vsdmemsoc" "Post"} [lindex [split [file rootname [file tail $synth_file_path]] .] 0]]
set filemane_synth2 [string totitle [lindex [split [file rootname [file tail $synth_file_path]] .] 1]]
file mkdir $out_dir/$filemane_synth1\_$filemane_synth2
file mkdir $out_dir/$filemane_synth1\_$filemane_synth2/graph

foreach libs $lib_dir {

	#Naming convention, make directory and input Open STA commands 
	set lib_filename [string map {" " ""} [lrange [split [file rootname [file tail $libs]] __] end-2 end] ]
	read_liberty $libs 
	if {[file exists $synth_file_path]} {
		read_verilog $synth_file_path
		link_design vsdmemsoc

		# Design constrains
		read_sdc -echo scripts/vsdmemsoc_synth.sdc

		#checks commnad -synthesis 
		#Worst design parameters
		report_checks -path_delay min_max -fields {nets cap slew input_pins} -digits {4} > $out_dir/$filemane_synth1\_$filemane_synth2/$lib_filename\_mm.rpt
		#Report for certain gates
		report_checks -path_delay min_max -from {_20588_ _21814_} -to {_21686_ _21110_} -fields {nets cap slew input_pins} -digits {4} > $out_dir/$filemane_synth1\_$filemane_synth2/graph/$lib_filename\_g_mm.rpt
		#TNS
		report_tns -digits {4} > $out_dir/$filemane_synth1\_$filemane_synth2/$lib_filename\_tns.rpt
		#report min max for mem inetrface
		report_checks -path_delay min_max -to mem -fields {nets cap slew input_pins} -digits {4} > $out_dir/$filemane_synth1\_$filemane_synth2/$lib_filename\_mem.rpt
		
	}
}
exit
