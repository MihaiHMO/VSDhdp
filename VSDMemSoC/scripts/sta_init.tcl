read_liberty lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty  lib/sram_32_256_sky130A_TT_1p8V_25C.lib
read_verilog output/synth/vsdmemsoc.synth.v
link_design vsdmemsoc
set_units -time ns
create_clock [get_ports -of_objects [get_nets CLK]] -name clk -period 14.5

#set_input_delay -clock clk -max -rise 0.5 {reset init_en init_addr init_data}
#set_input_delay -clock clk -min -rise 1 {reset init_en init_addr init_data}
#set_input_delay -clock clk -min -fall 0.5 {reset init_en init_addr init_data}
#set_input_delay -clock clk -max -fall 1 {reset init_en init_addr init_data}
#[get_ports -of_objects [get_nets init_en]]

#set_input_transition -min -rise 0.5 [all_inputs]
#set_input_transition -max -rise 1 [all_inputs]
#set_input_transition -min -fall 0.5 [all_inputs]
#set_input_transition -max -fall 1 [all_inputs]

#set_output_delay -clock clk -min -rise 0.5 [all_outputs]
#set_output_delay -clock clk -max -rise 1 [all_outputs]
#set_output_delay -clock clk -min -fall 0.5 [all_outputs]
#set_output_delay -clock clk -max -fall 1 [all_outputs]
#set_load 1 [all_outputs] 

puts "----------reg2reg setup/hold---------------\n"

#report_checks -path_delay max -from [all_registers] -to [all_registers] -fields {nets cap slew input_pins} 
report_checks -path_delay min -group_count 1000 -endpoint_count 1000 -unique_paths_to_endpoint -fields {nets cap slew input_pins}

#puts "----------in2reg setup/hold ---------------\n"

#report_checks -path_delay max -from [all_inputs] -to [all_registers] -fields {nets cap slew input_pins}
#report_checks -path_delay min -from [all_inputs] -to [all_registers] -fields {nets cap slew input_pins}

#puts "----------reg2out setup/hold ---------------\n"

#report_checks -path_delay max -from [all_registers] -to [all_outputs] -fields {nets cap slew input_pins}
#report_checks -path_delay min -from [all_registers] -to [all_outputs] -fields {nets cap slew input_pins}

#puts "----------in2out setup/hold ---------------\n"

#report_checks -path_delay max -from [all_inputs] -to [all_outputs] -fields {nets cap slew input_pins}
#report_checks -path_delay min -from [all_inputs] -to [all_outputs] -fields {nets cap slew input_pins}

