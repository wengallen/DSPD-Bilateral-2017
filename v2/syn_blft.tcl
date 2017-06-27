# MultiCore
set_host_options -max_cores 16

# Read Design

read_file -format verilog ./blft.v
current_design blft
set hdlin_keep_signal_name default

# Set Design Constrains

set cycle 10.0
create_clock -name clk -period $cycle [get_ports clk]
set_dont_touch_network      [get_clocks clk]
set_fix_hold                [get_clocks clk]
set_clock_uncertainty  0.1  [get_clocks clk]
set_clock_latency      1    [get_clocks clk]
set_input_transition   0.5  [all_inputs]
set_clock_transition   0.5  [all_clocks]

set_load         1     [all_outputs]
#set_drive        1     [all_inputs]
#set_input_delay  5      -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
#set_output_delay 0.5    -clock clk [all_outputs] 
set_input_delay   -max 1    -clock clk   [all_inputs]
set_input_delay   -min 0.1  -clock clk   [all_inputs]
set_output_delay  -max 1    -clock clk   [all_outputs]
set_output_delay  -min 0.1  -clock clk   [all_outputs]

set_operating_conditions -min fast -max slow
set_wire_load_model -name tsmc090_wl10 -library slow                      



# Compile Settings
set verilogout_no_tri true
set_boundary_optimization "*"
set_fix_multiple_port_nets -all -buffer_constants

set_max_area 0
set_max_fanout 20 [all_inputs]
set_max_fanout 8 blft
set_max_transition 1 blft
check_design
#compile -exact_map -map_effort high
compile_ultra -incremental


#for problem(too few module port connections)
remove_unconnected_ports -blast_buses [get_cells -hierarchical *]

#for problem(change naming rule script)
set bus_inference_style {%s[%d]}
set bus_naming_style {%s[%d]}
set hdlout_internal_busses true
change_names -hierarchy -rule verilog
define_name_rules name_rule -allowed {a-z A-Z 0-9 _} -max_length 255 -type cell
define_name_rules name_rule -allowed {a-z A-Z 0-9 _[]} -max_length 255 -type net
define_name_rules name_rule -map {{"\\*cell\\*" "cell"}}
define_name_rules name_rule -case_insensitive
change_names -hierarchy -rules name_rule


# Area/Timing/Power report
report_timing
report_area
report_timing > blft.timing_rpt
report_area   > blft.area_rpt
report_power  > blft.power_rpt

write -hierarchy -format ddc -output ./blft.ddc
write -hierarchy -format verilog -output ./blft_syn.v
write_script > ./blft_syn.dc
#write_sdf -version 2.1 blft_syn.sdf
write_sdf -version 1.0  -context verilog  -load_delay net  blft_syn.sdf
write_sdc blft_syn.sdc
