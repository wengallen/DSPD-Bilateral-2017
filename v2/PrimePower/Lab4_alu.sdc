###################################################################

# Created by write_sdc on Mon Oct 26 19:20:52 2015

###################################################################
set sdc_version 1.9

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current mA
set_operating_conditions -max WCCOM -max_library                               \
fsa0a_c_generic_core_ss1p62v125c\
                         -min BCCOM -min_library                               \
fsa0a_c_generic_core_ff1p98vm40c
set_max_area 0
create_clock [get_ports clk_p_i]  -period 16  -waveform {0 8}
set_clock_uncertainty 0.5  [get_clocks clk_p_i]
set_clock_transition -max -rise 0.5 [get_clocks clk_p_i]
set_clock_transition -max -fall 0.5 [get_clocks clk_p_i]
set_clock_transition -min -rise 0.5 [get_clocks clk_p_i]
set_clock_transition -min -fall 0.5 [get_clocks clk_p_i]
set_propagated_clock [get_clocks clk_p_i]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[7]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[6]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[5]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[4]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[3]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[2]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[1]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_a_i[0]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[7]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[6]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[5]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[4]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[3]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[2]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[1]}]
set_input_delay -clock clk_p_i  2  [get_ports {data_b_i[0]}]
set_input_delay -clock clk_p_i  2  [get_ports {inst_i[2]}]
set_input_delay -clock clk_p_i  2  [get_ports {inst_i[1]}]
set_input_delay -clock clk_p_i  2  [get_ports {inst_i[0]}]
set_input_delay -clock clk_p_i  2  [get_ports reset_n_i]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[15]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[14]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[13]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[12]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[11]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[10]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[9]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[8]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[7]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[6]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[5]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[4]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[3]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[2]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[1]}]
set_output_delay -clock clk_p_i  3  [get_ports {data_o[0]}]
