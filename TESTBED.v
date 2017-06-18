`timescale 1ns/10ps
`include "PATTERN.v"
`ifdef RTL
  `include "blft.v"
`endif
`ifdef GATE
  `include "blft_SYN.v"
`endif	  		  	
`ifdef POST
  `include "blft_CHIP.v"
`endif

module TESTBED;

//////////////////////////////////// IO declaration
// $fsdbDumpfile("abc.fsdb");
// $fsdbDumpvars;
// $fsdbDumpMDA;
    
initial begin
    `ifdef RTL
        $dumpfile("blft.vcd");
        $dumpvars(0, TESTBED);
    `endif
    `ifdef GATE
        $sdf_annotate("blft_SYN.sdf",blft_CORE);
        $dumpfile("blft_SYN.vcd");
        $dumpvars();
    `endif
    `ifdef POST
        $sdf_annotate("blft_POST.sdf",blft_CORE);
        $dumpfile("blft_POST.vcd");
        $dumpvars();
    `endif
end

wire        clk;
wire        rst;
wire        in_valid;
wire        out_valid;
wire [15:0] in_addr;
wire [15:0] out_addr;
wire [8:0]  in_data;
wire [8:0]  out_data;

blft blft_CORE(
.clk(clk),
.rst(rst),
.in_valid(in_valid),
.out_valid(out_valid),
.in_addr(in_addr),
.out_addr(out_addr),
.in_data(in_data),
.out_data(out_data)
);

PATTERN PAT_GEN_LOGIC_ANA(
.clk(clk),
.rst(rst),
.in_valid(in_valid),
.out_valid(out_valid),
.in_addr(in_addr),
.out_addr(out_addr),
.in_data(in_data),
.out_data(out_data)
);


endmodule
