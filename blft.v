// Output SNR ≥ 40 dB (test pattern provided)
// Latency ~= 70k cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process

// Bilateral Filter
module blft(
clk,
rst,
in_valid,
out_valid,
in_addr,
out_addr,
in_data,
out_data,
finish
);

//==== I/O port ==========================
input         clk;
input         rst;
input         in_valid;
output        out_valid;
output [15:0] in_addr;
output [15:0] out_addr;
input  [7:0]  in_data;
output [7:0]  out_data;
output        finish;

//==== reg/wire ==========================
reg         out_valid;
reg         out_valid_w;
reg  [7:0]  out_data;
reg  [7:0]  out_data_w;
reg         finish;
reg         finish_w;

reg  [6:0]  addr_map_r;
reg  [6:0]  addr_map_w;

reg  [3:0]  state_r;
reg  [3:0]  state_w;
reg  [7:0]  row_cntr_r;
reg  [7:0]  row_cntr_w;
reg  [7:0]  col_cntr_r;
reg  [7:0]  col_cntr_w;
reg  [7:0]  px_row_cntr_r;
reg  [7:0]  px_row_cntr_w;
reg  [7:0]  px_col_cntr_r;
reg  [7:0]  px_col_cntr_w;


reg  [13:0] map_r[0:120];
reg  [13:0] map_w[0:120];

integer i;

parameter START  =0;
parameter LEFT   =1;
parameter MID    =2;
parameter RIGHT  =3;
parameter ENDING =4;

assign in_addr  = { row_cntr_r    , col_cntr_r };
assign out_addr = { px_row_cntr_r , px_col_cntr_r };

always@(*) begin
    state_w = state_r;
    addr_map_w      = addr_map_r;
    col_cntr_w      = col_cntr_r;
    row_cntr_w      = row_cntr_r;
    px_row_cntr_w   = px_row_cntr_w;
    px_col_cntr_w   = px_col_cntr_w;
    out_valid_w     = out_valid;
    out_data_w      = out_data;
    finish_w        = finish;
    
    for(i=0;i<120;i=i+1) begin
        map_w[i]    = map_r[i];
    end
    
    case(state_r)
    START: begin
        state_w = LEFT;
        col_cntr_w = 0;
        row_cntr_w = 0;
        px_row_cntr_w = 5;
        px_col_cntr_w = 5;
        addr_map_w = 0;
    end
    
    LEFT: begin
        if(in_valid) begin
            map_w[addr_map_r]   = {in_data,6'b0};
            addr_map_w          = (addr_map_r==120)?110:addr_map_r+1;
            
            row_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? px_row_cntr_r-5 : row_cntr_r+1;
            col_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? col_cntr_r+1    : col_cntr_r;
            
            if(col_cntr_r==px_col_cntr_r+5 && row_cntr_r==px_row_cntr_r+4) begin
                state_w = MID;
            end
        end
    end
    
    MID: begin
        if(in_valid) begin
            map_w[addr_map_r]   = {in_data,6'b0};
            addr_map_w          = (addr_map_r==120)?110:addr_map_r+1;
            
            row_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? px_row_cntr_r-5 : row_cntr_r+1;
            col_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? col_cntr_r+1    : col_cntr_r;
            px_col_cntr_w = (row_cntr_r==px_row_cntr_r+5) ? px_col_cntr_r+1 : px_col_cntr_r;
            
            if(col_cntr_r==255 && row_cntr_r==px_col_cntr_r+4) begin
                state_w = RIGHT;
            end
        end
    end
    
    RIGHT: begin
        if(in_valid) begin
            map_w[addr_map_r]   = {in_data,6'b0};
            addr_map_w          = 0;
            
            row_cntr_w    = px_row_cntr_r-4; 
            col_cntr_w    = 0;
            px_row_cntr_w = px_row_cntr_r+1;
            px_col_cntr_w = 5;
            
            if(col_cntr_r==255 && row_cntr_r==255) begin
                state_w = ENDING;
            end
        end
    end
    ENDING: begin
        finish_w = 1;
    end
    
    endcase
end

/*
0.0625 15'b0_000100
0.1094 15'b0_000111
0.1563 15'b0_001010
0.1719 15'b0_001011
0.2031 15'b0_001101
0.2344 15'b0_001111
0.2500 15'b0_010000
0.3281 15'b0_010101
0.3750 15'b0_011000
0.3906 15'b0_011001
0.4063 15'b0_011010
0.4844 15'b0_011111
0.5781 15'b0_100101
0.6094 15'b0_100111
0.6406 15'b0_101001
0.7500 15'b0_110000
0.7969 15'b0_110011
0.8906 15'b0_111001
0.9531 15'b0_111101
1.0000 15'b1_000000
*/

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state_r         <= 0;
        out_valid       <= 0;
        out_data        <= 0;
        finish          <= 0;
        
        addr_map_r      <= 0;
        row_cntr_r      <= 0;
        col_cntr_r      <= 0;
        px_row_cntr_r   <= 0;    
        px_col_cntr_r   <= 0;
        
        for(i=0;i<120;i=i+1) begin
            map_r[i]    <= 0;
        end
    end
    else begin
        state_r         <= state_w;
        out_valid       <= out_valid_w;
        out_data        <= out_data_w;
        finish          <= finish_w;
        
        addr_map_r      <= addr_map_w;
        row_cntr_r      <= row_cntr_w;
        col_cntr_r      <= col_cntr_w;
        px_row_cntr_r   <= px_row_cntr_w;
        px_col_cntr_r   <= px_col_cntr_w;
        
        for(i=0;i<120;i=i+1) begin
            map_r[i]    <=  map_w[i];
        end
    end
end

endmodule