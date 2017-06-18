// 32-point single-path delay feedback (SDF) FFT 
// input  x[0] x[1] ... x[31]
// output X[0] X[1] ... X[31]

// Output SNR ≥ 40 dB (test pattern provided)
// Latency ≤ 68 cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process

// Radix-ANY
module blft(
clk,
rst,
in_valid,
out_valid,
in_addr,
out_addr,
in_data,
out_data
);

//==== I/O port ==========================
input         clk;
input         rst;
input         in_valid;
output        out_valid;
output [15:0] in_addr;
output [15:0] out_addr;
input  [8:0]  in_data;
output [8:0]  out_data;

//==== reg/wire ==========================
reg                out_valid;
reg                out_valid_w;
reg         [11:0] addr_map_r;
reg         [11:0] addr_map_w;

reg         [7:0]  row_cntr_r;
reg         [7:0]  row_cntr_w;
reg         [7:0]  colume_cntr_r;
reg         [7:0]  colume_cntr_w;
reg         [7:0]  pixel_cntr_r;
reg         [7:0]  pixel_cntr_w;


reg signed  [8:0]  in_buffer_r;
reg signed  [8:0]  in_buffer_w;
reg signed  [14:0] map_r[0:2815]
reg signed  [14:0] map_w[0:2815]

integer i;
parameter START  =0;
parameter LEFT   =1;
parameter MID    =2;
parameter RIGHT  =3;
parameter ENDING =4;

always@(*) begin
    state_w = state_r;
    in_buffer_w         = in_buffer_r;
    addr_map_w          = addr_map_r;
    colume_cntr_w       = colume_cntr_r;
    row_cntr_w          = row_cntr_r;
    pixel_cntr_w        = pixel_cntr_w;
    
    
    
    case(state_r):
    HEADER: begin
        if(row_cntr_r==10 && colume_cntr_r==10) begin
            state_w = MID;
        end
        
        if(in_valid) begin
            map_w[addr_map_r]   = {in_data,6'b0};
            addr_map_w          = (addr_map_r==2815)?2560:addr_map_r+1;
            
            if(colume_cntr_r==255)begin
                colume_cntr_w   = 0;
                row_cntr_w      = (row_cntr_r==255)?0:row_cntr_r+1;
            end
            else begin
                colume_cntr_w   = colume_cntr_r+1;
            end
        end        
    end
    
    MID: begin
        if(row_cntr_r==255 && colume_cntr_r==255) begin
            state_w = ENDING;
        end
        
        if(in_valid) begin
            map_w[addr_map_r]   = {in_data,6'b0};
            addr_map_w          = (addr_map_r==2815)?2560:addr_map_r+1;
            
            if(colume_cntr_r==255)begin
                colume_cntr_w   = 0;
                row_cntr_w      = (row_cntr_r==255)?0:row_cntr_r+1;
            end
            else begin
                colume_cntr_w   = colume_cntr_r+1;
            end
        end
        
        
        
    end
    
    ENDING: begin
    end
    
    endcase
end

always @(*) begin
    in_buffer_w         = in_buffer_r;
    addr_map_w          = addr_map_r;
    colume_cntr_w       = colume_cntr_r;
    row_cntr_w          = row_cntr_r;
    
    if(in_valid) begin
        // in_buffer_w = {in_data,6'b0};
        
        if(colume_cntr_r==255)begin
            colume_cntr_w   = 0;
            row_cntr_w      = (row_cntr_r==255)?0:row_cntr_r+1;
        end
        else begin
            colume_cntr_w   = colume_cntr_r+1;
        end
        
        
        map_w[addr_map_r]   = {in_data,6'b0};
        addr_map_w          = (addr_map_r==1279)?0:addr_map_r+1;
    end
    
    
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
        out_valid       <= 0;
        in_buffer_r     <= 0;
        addr_map_r      <= 0;
        row_cntr_r      <= 0;
        colume_cntr_r   <= 0;
        pixel_cntr_r    <= 0;    
        
        for for(i=0;j<2816;i=i+1) begin
            map_r[i]    <= 0;
        end
    end
    else begin
        out_valid       <= out_valid_w;
        in_buffer_r     <= in_buffer_w;
        addr_map_r      <= addr_map_w;
        row_cntr_r      <= row_cntr_w;
        colume_cntr_r   <= colume_cntr_w;
        pixel_cntr_r    <= pixel_cntr_w;
        
        for for(i=0;j<2816;i=i+1) begin
            map_r[i]    <=  map_w[i];
        end
    end
end

endmodule