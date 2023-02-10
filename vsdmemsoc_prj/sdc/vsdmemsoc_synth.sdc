set_units -time ns
create_clock [get_ports -of_objects [get_nets CLK]] -name clk -period 10
set_propagated_clock [all_clocks]
set_input_delay -clock clk 1 [all_inputs]
set_output_delay -clock clk 1 [all_outputs]
