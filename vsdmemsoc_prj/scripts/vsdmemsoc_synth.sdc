set_units -time ns
create_clock [get_ports -of_objects [get_nets CLK]] -name clk -period 10

set_input_delay -clock clk -max -rise 0.5 [all_inputs]
set_input_delay -clock clk -min -rise 1 [all_inputs]
set_input_delay -clock clk -min -fall 0.5 [all_inputs] 
set_input_delay -clock clk -max -fall 1 [all_inputs]

set_input_transition -min -rise 0.5 [all_inputs]
set_input_transition -max -rise 1 [all_inputs]
set_input_transition -min -fall 0.5 [all_inputs]
set_input_transition -max -fall 1 [all_inputs]

set_output_delay -clock clk -min -rise 0.5 [all_outputs]
set_output_delay -clock clk -max -rise 1 [all_outputs]
set_output_delay -clock clk -min -fall 0.5 [all_outputs]
set_output_delay -clock clk -max -fall 1 [all_outputs]
set_load 1 [all_outputs] 

