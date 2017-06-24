// Output SNR ≥ 40 dB (test pattern provided)
// Latency ~= 70k cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process


`include "gaussian.v"

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
reg  [15:0] out_addr;
reg  [15:0] out_addr_w;
reg  [7:0]  out_data;
reg  [7:0]  out_data_w;
reg         finish;
reg         finish_w;

reg  [6:0]  addr_mapi_r;
reg  [6:0]  addr_mapi_w;

reg  [3:0]  state_r;
reg  [3:0]  state_w;
reg  [3:0]  sub_state_r;
reg  [3:0]  sub_state_w;
reg  [7:0]  row_cntr_r;
reg  [7:0]  row_cntr_w;
reg  [7:0]  col_cntr_r;
reg  [7:0]  col_cntr_w;
reg  [7:0]  px_row_cntr_r;
reg  [7:0]  px_row_cntr_w;
reg  [7:0]  px_col_cntr_r;
reg  [7:0]  px_col_cntr_w;


reg  [7:0]  mapi_r[0:120];
reg  [7:0]  mapi_w[0:120];

reg         en_mapg_r;
reg         en_mapg_w;
reg  [13:0] mapg_r[0:120];
wire [27:0] mapg_w[0:120];

reg  [7:0]  in_buffer_r[0:10];
reg  [7:0]  in_buffer_w[0:10];

integer i;

parameter START  =0;
parameter LEFT   =1;
parameter MID    =2;
parameter RIGHT  =3;
parameter ENDING =4;

assign in_addr  = { row_cntr_r    , col_cntr_r };
// assign out_addr_w = { px_row_cntr_r , px_col_cntr_r };

always@(*) begin
    state_w         = state_r;
    sub_state_w     = sub_state_r;
    
    addr_mapi_w      = addr_mapi_r;
    col_cntr_w      = col_cntr_r;
    row_cntr_w      = row_cntr_r;
    px_row_cntr_w   = px_row_cntr_w;
    px_col_cntr_w   = px_col_cntr_w;
    
    en_mapg_w       = en_mapg_r;

    out_valid_w     = out_valid;
    out_addr_w      = { px_row_cntr_r , px_col_cntr_r };
    out_data_w      = out_data;
    finish_w        = finish;
    
    for(i=0;i<121;i=i+1) begin
        mapi_w[i]    = mapi_r[i];
    end
    for(i=0;i<11;i=i+1) begin
        in_buffer_w[i] = in_buffer_r[i];
    end
    
    case(state_r)
    START: begin
        state_w = LEFT;
        sub_state_w = 0;
        
        col_cntr_w = 0;
        row_cntr_w = 0;
        px_row_cntr_w = 5;
        px_col_cntr_w = 5;
        addr_mapi_w = 0;

        en_mapg_w = 1;

    end
    
    LEFT: begin
        if(in_valid) begin
            mapi_w[addr_mapi_r]   = in_data;
            addr_mapi_w          = (addr_mapi_r==120)?110:addr_mapi_r+1;
            
            row_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? px_row_cntr_r-5 : row_cntr_r+1;
            col_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? col_cntr_r+1    : col_cntr_r;
            
            if(col_cntr_r==px_col_cntr_r+5 && row_cntr_r==px_row_cntr_r+5) begin
                state_w = MID;
                sub_state_w = 0;
            end
        end
    end
    
    MID: begin
        if(in_valid) begin
            // mapi_w[addr_mapi_r]   = in_data;
            addr_mapi_w          = (addr_mapi_r==120)?110:addr_mapi_r+1;
            
            row_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? px_row_cntr_r-5 : row_cntr_r+1;
            col_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? col_cntr_r+1    : col_cntr_r;
            px_col_cntr_w = (row_cntr_r==px_row_cntr_r+5) ? px_col_cntr_r+1 : px_col_cntr_r;
            
            if(col_cntr_r==255 && row_cntr_r==px_row_cntr_r+4) begin
                state_w = RIGHT;
            end
        end
        
        case(sub_state_r)
        0,1,2: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
            out_valid_w = 0;
        end
        3,4,5: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
        end
        6,7,8,9: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
        end
        10: begin
            sub_state_w = 0;
            in_buffer_w[sub_state_r] = in_data;
            mapi_w[sub_state_r+110]   = in_data;
            for(i=0;i<110;i=i+1) mapi_w[i] = mapi_r[i+11];
            for(i=0;i<10;i=i+1)  mapi_w[i+110] = in_buffer_r[i];
            out_valid_w = 1;
            out_data_w = mapi_r[60];
        end
        
        endcase
        
    end
    
    RIGHT: begin
        if(in_valid) begin
            mapi_w[addr_mapi_r]  = in_data;
            addr_mapi_w          = 0;
            
            row_cntr_w    = px_row_cntr_r-4; 
            col_cntr_w    = 0;
            px_row_cntr_w = px_row_cntr_r+1;
            px_col_cntr_w = 5;
            
            if(col_cntr_r==255 && row_cntr_r==255) begin
                state_w = ENDING;
            end
            else begin
                state_w = LEFT;
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
        sub_state_r     <= 0;
        out_valid       <= 0;
        out_addr        <= 0;
        out_data        <= 0;
        finish          <= 0;
        
        addr_mapi_r     <= 0;
        row_cntr_r      <= 0;
        col_cntr_r      <= 0;
        px_row_cntr_r   <= 0;    
        px_col_cntr_r   <= 0;
        
        en_mapg_r       <= 0;

        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= 0;
            mapg_r[i]    <= 0;
        end
        for(i=0;i<11;i=i+1) begin
            in_buffer_r[i] <= 0;
        end
    end
    else begin
        state_r         <= state_w;
        sub_state_r     <= sub_state_w;
        out_valid       <= out_valid_w;
        out_addr        <= out_addr_w;
        out_data        <= out_data_w;
        finish          <= finish_w;
        
        addr_mapi_r     <= addr_mapi_w;
        row_cntr_r      <= row_cntr_w;
        col_cntr_r      <= col_cntr_w;
        px_row_cntr_r   <= px_row_cntr_w;
        px_col_cntr_r   <= px_col_cntr_w;
        
        en_mapg_r       <= en_mapg_w;
        
        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= mapi_w[i];
            mapg_r[i]    <= mapg_w[i][19:6];
        end
        for(i=0;i<11;i=i+1) begin
            in_buffer_r[i] <= in_buffer_w[i];
        end
    end
end

gaussian i2g(
.i000_n(mapi_r[0  ]),.i001_n(mapi_r[1  ]),.i002_n(mapi_r[2  ]),.i003_n(mapi_r[3  ]),.i004_n(mapi_r[4  ]),.i005_n(mapi_r[5  ]),.i006_n(mapi_r[6  ]),.i007_n(mapi_r[7  ]),.i008_n(mapi_r[8  ]),.i009_n(mapi_r[9  ]),
.i010_n(mapi_r[10 ]),.i011_n(mapi_r[11 ]),.i012_n(mapi_r[12 ]),.i013_n(mapi_r[13 ]),.i014_n(mapi_r[14 ]),.i015_n(mapi_r[15 ]),.i016_n(mapi_r[16 ]),.i017_n(mapi_r[17 ]),.i018_n(mapi_r[18 ]),.i019_n(mapi_r[19 ]),
.i020_n(mapi_r[20 ]),.i021_n(mapi_r[21 ]),.i022_n(mapi_r[22 ]),.i023_n(mapi_r[23 ]),.i024_n(mapi_r[24 ]),.i025_n(mapi_r[25 ]),.i026_n(mapi_r[26 ]),.i027_n(mapi_r[27 ]),.i028_n(mapi_r[28 ]),.i029_n(mapi_r[29 ]),
.i030_n(mapi_r[30 ]),.i031_n(mapi_r[31 ]),.i032_n(mapi_r[32 ]),.i033_n(mapi_r[33 ]),.i034_n(mapi_r[34 ]),.i035_n(mapi_r[35 ]),.i036_n(mapi_r[36 ]),.i037_n(mapi_r[37 ]),.i038_n(mapi_r[38 ]),.i039_n(mapi_r[39 ]),
.i040_n(mapi_r[40 ]),.i041_n(mapi_r[41 ]),.i042_n(mapi_r[42 ]),.i043_n(mapi_r[43 ]),.i044_n(mapi_r[44 ]),.i045_n(mapi_r[45 ]),.i046_n(mapi_r[46 ]),.i047_n(mapi_r[47 ]),.i048_n(mapi_r[48 ]),.i049_n(mapi_r[49 ]),
.i050_n(mapi_r[50 ]),.i051_n(mapi_r[51 ]),.i052_n(mapi_r[52 ]),.i053_n(mapi_r[53 ]),.i054_n(mapi_r[54 ]),.i055_n(mapi_r[55 ]),.i056_n(mapi_r[56 ]),.i057_n(mapi_r[57 ]),.i058_n(mapi_r[58 ]),.i059_n(mapi_r[59 ]),
.i060_n(mapi_r[60 ]),.i061_n(mapi_r[61 ]),.i062_n(mapi_r[62 ]),.i063_n(mapi_r[63 ]),.i064_n(mapi_r[64 ]),.i065_n(mapi_r[65 ]),.i066_n(mapi_r[66 ]),.i067_n(mapi_r[67 ]),.i068_n(mapi_r[68 ]),.i069_n(mapi_r[69 ]),
.i070_n(mapi_r[70 ]),.i071_n(mapi_r[71 ]),.i072_n(mapi_r[72 ]),.i073_n(mapi_r[73 ]),.i074_n(mapi_r[74 ]),.i075_n(mapi_r[75 ]),.i076_n(mapi_r[76 ]),.i077_n(mapi_r[77 ]),.i078_n(mapi_r[78 ]),.i079_n(mapi_r[79 ]),
.i080_n(mapi_r[80 ]),.i081_n(mapi_r[81 ]),.i082_n(mapi_r[82 ]),.i083_n(mapi_r[83 ]),.i084_n(mapi_r[84 ]),.i085_n(mapi_r[85 ]),.i086_n(mapi_r[86 ]),.i087_n(mapi_r[87 ]),.i088_n(mapi_r[88 ]),.i089_n(mapi_r[89 ]),
.i090_n(mapi_r[90 ]),.i091_n(mapi_r[91 ]),.i092_n(mapi_r[92 ]),.i093_n(mapi_r[93 ]),.i094_n(mapi_r[94 ]),.i095_n(mapi_r[95 ]),.i096_n(mapi_r[96 ]),.i097_n(mapi_r[97 ]),.i098_n(mapi_r[98 ]),.i099_n(mapi_r[99 ]),
.i100_n(mapi_r[100]),.i101_n(mapi_r[101]),.i102_n(mapi_r[102]),.i103_n(mapi_r[103]),.i104_n(mapi_r[104]),.i105_n(mapi_r[105]),.i106_n(mapi_r[106]),.i107_n(mapi_r[107]),.i108_n(mapi_r[108]),.i109_n(mapi_r[109]),
.i110_n(mapi_r[110]),.i111_n(mapi_r[111]),.i112_n(mapi_r[112]),.i113_n(mapi_r[113]),.i114_n(mapi_r[114]),.i115_n(mapi_r[115]),.i116_n(mapi_r[116]),.i117_n(mapi_r[117]),.i118_n(mapi_r[118]),.i119_n(mapi_r[119]),.i120_n(mapi_r[120]),
.i000_r(mapg_r[0  ]),.i001_r(mapg_r[1  ]),.i002_r(mapg_r[2  ]),.i003_r(mapg_r[3  ]),.i004_r(mapg_r[4  ]),.i005_r(mapg_r[5  ]),.i006_r(mapg_r[6  ]),.i007_r(mapg_r[7  ]),.i008_r(mapg_r[8  ]),.i009_r(mapg_r[9  ]),
.i010_r(mapg_r[10 ]),.i011_r(mapg_r[11 ]),.i012_r(mapg_r[12 ]),.i013_r(mapg_r[13 ]),.i014_r(mapg_r[14 ]),.i015_r(mapg_r[15 ]),.i016_r(mapg_r[16 ]),.i017_r(mapg_r[17 ]),.i018_r(mapg_r[18 ]),.i019_r(mapg_r[19 ]),
.i020_r(mapg_r[20 ]),.i021_r(mapg_r[21 ]),.i022_r(mapg_r[22 ]),.i023_r(mapg_r[23 ]),.i024_r(mapg_r[24 ]),.i025_r(mapg_r[25 ]),.i026_r(mapg_r[26 ]),.i027_r(mapg_r[27 ]),.i028_r(mapg_r[28 ]),.i029_r(mapg_r[29 ]),
.i030_r(mapg_r[30 ]),.i031_r(mapg_r[31 ]),.i032_r(mapg_r[32 ]),.i033_r(mapg_r[33 ]),.i034_r(mapg_r[34 ]),.i035_r(mapg_r[35 ]),.i036_r(mapg_r[36 ]),.i037_r(mapg_r[37 ]),.i038_r(mapg_r[38 ]),.i039_r(mapg_r[39 ]),
.i040_r(mapg_r[40 ]),.i041_r(mapg_r[41 ]),.i042_r(mapg_r[42 ]),.i043_r(mapg_r[43 ]),.i044_r(mapg_r[44 ]),.i045_r(mapg_r[45 ]),.i046_r(mapg_r[46 ]),.i047_r(mapg_r[47 ]),.i048_r(mapg_r[48 ]),.i049_r(mapg_r[49 ]),
.i050_r(mapg_r[50 ]),.i051_r(mapg_r[51 ]),.i052_r(mapg_r[52 ]),.i053_r(mapg_r[53 ]),.i054_r(mapg_r[54 ]),.i055_r(mapg_r[55 ]),.i056_r(mapg_r[56 ]),.i057_r(mapg_r[57 ]),.i058_r(mapg_r[58 ]),.i059_r(mapg_r[59 ]),
.i060_r(mapg_r[60 ]),.i061_r(mapg_r[61 ]),.i062_r(mapg_r[62 ]),.i063_r(mapg_r[63 ]),.i064_r(mapg_r[64 ]),.i065_r(mapg_r[65 ]),.i066_r(mapg_r[66 ]),.i067_r(mapg_r[67 ]),.i068_r(mapg_r[68 ]),.i069_r(mapg_r[69 ]),
.i070_r(mapg_r[70 ]),.i071_r(mapg_r[71 ]),.i072_r(mapg_r[72 ]),.i073_r(mapg_r[73 ]),.i074_r(mapg_r[74 ]),.i075_r(mapg_r[75 ]),.i076_r(mapg_r[76 ]),.i077_r(mapg_r[77 ]),.i078_r(mapg_r[78 ]),.i079_r(mapg_r[79 ]),
.i080_r(mapg_r[80 ]),.i081_r(mapg_r[81 ]),.i082_r(mapg_r[82 ]),.i083_r(mapg_r[83 ]),.i084_r(mapg_r[84 ]),.i085_r(mapg_r[85 ]),.i086_r(mapg_r[86 ]),.i087_r(mapg_r[87 ]),.i088_r(mapg_r[88 ]),.i089_r(mapg_r[89 ]),
.i090_r(mapg_r[90 ]),.i091_r(mapg_r[91 ]),.i092_r(mapg_r[92 ]),.i093_r(mapg_r[93 ]),.i094_r(mapg_r[94 ]),.i095_r(mapg_r[95 ]),.i096_r(mapg_r[96 ]),.i097_r(mapg_r[97 ]),.i098_r(mapg_r[98 ]),.i099_r(mapg_r[99 ]),
.i100_r(mapg_r[100]),.i101_r(mapg_r[101]),.i102_r(mapg_r[102]),.i103_r(mapg_r[103]),.i104_r(mapg_r[104]),.i105_r(mapg_r[105]),.i106_r(mapg_r[106]),.i107_r(mapg_r[107]),.i108_r(mapg_r[108]),.i109_r(mapg_r[109]),
.i110_r(mapg_r[110]),.i111_r(mapg_r[111]),.i112_r(mapg_r[112]),.i113_r(mapg_r[113]),.i114_r(mapg_r[114]),.i115_r(mapg_r[115]),.i116_r(mapg_r[116]),.i117_r(mapg_r[117]),.i118_r(mapg_r[118]),.i119_r(mapg_r[119]),.i120_r(mapg_r[120]),
.out000(mapg_w[0  ]),.out001(mapg_w[1  ]),.out002(mapg_w[2  ]),.out003(mapg_w[3  ]),.out004(mapg_w[4  ]),.out005(mapg_w[5  ]),.out006(mapg_w[6  ]),.out007(mapg_w[7  ]),.out008(mapg_w[8  ]),.out009(mapg_w[9  ]),
.out010(mapg_w[10 ]),.out011(mapg_w[11 ]),.out012(mapg_w[12 ]),.out013(mapg_w[13 ]),.out014(mapg_w[14 ]),.out015(mapg_w[15 ]),.out016(mapg_w[16 ]),.out017(mapg_w[17 ]),.out018(mapg_w[18 ]),.out019(mapg_w[19 ]),
.out020(mapg_w[20 ]),.out021(mapg_w[21 ]),.out022(mapg_w[22 ]),.out023(mapg_w[23 ]),.out024(mapg_w[24 ]),.out025(mapg_w[25 ]),.out026(mapg_w[26 ]),.out027(mapg_w[27 ]),.out028(mapg_w[28 ]),.out029(mapg_w[29 ]),
.out030(mapg_w[30 ]),.out031(mapg_w[31 ]),.out032(mapg_w[32 ]),.out033(mapg_w[33 ]),.out034(mapg_w[34 ]),.out035(mapg_w[35 ]),.out036(mapg_w[36 ]),.out037(mapg_w[37 ]),.out038(mapg_w[38 ]),.out039(mapg_w[39 ]),
.out040(mapg_w[40 ]),.out041(mapg_w[41 ]),.out042(mapg_w[42 ]),.out043(mapg_w[43 ]),.out044(mapg_w[44 ]),.out045(mapg_w[45 ]),.out046(mapg_w[46 ]),.out047(mapg_w[47 ]),.out048(mapg_w[48 ]),.out049(mapg_w[49 ]),
.out050(mapg_w[50 ]),.out051(mapg_w[51 ]),.out052(mapg_w[52 ]),.out053(mapg_w[53 ]),.out054(mapg_w[54 ]),.out055(mapg_w[55 ]),.out056(mapg_w[56 ]),.out057(mapg_w[57 ]),.out058(mapg_w[58 ]),.out059(mapg_w[59 ]),
.out060(mapg_w[60 ]),.out061(mapg_w[61 ]),.out062(mapg_w[62 ]),.out063(mapg_w[63 ]),.out064(mapg_w[64 ]),.out065(mapg_w[65 ]),.out066(mapg_w[66 ]),.out067(mapg_w[67 ]),.out068(mapg_w[68 ]),.out069(mapg_w[69 ]),
.out070(mapg_w[70 ]),.out071(mapg_w[71 ]),.out072(mapg_w[72 ]),.out073(mapg_w[73 ]),.out074(mapg_w[74 ]),.out075(mapg_w[75 ]),.out076(mapg_w[76 ]),.out077(mapg_w[77 ]),.out078(mapg_w[78 ]),.out079(mapg_w[79 ]),
.out080(mapg_w[80 ]),.out081(mapg_w[81 ]),.out082(mapg_w[82 ]),.out083(mapg_w[83 ]),.out084(mapg_w[84 ]),.out085(mapg_w[85 ]),.out086(mapg_w[86 ]),.out087(mapg_w[87 ]),.out088(mapg_w[88 ]),.out089(mapg_w[89 ]),
.out090(mapg_w[90 ]),.out091(mapg_w[91 ]),.out092(mapg_w[92 ]),.out093(mapg_w[93 ]),.out094(mapg_w[94 ]),.out095(mapg_w[95 ]),.out096(mapg_w[96 ]),.out097(mapg_w[97 ]),.out098(mapg_w[98 ]),.out099(mapg_w[99 ]),
.out100(mapg_w[100]),.out101(mapg_w[101]),.out102(mapg_w[102]),.out103(mapg_w[103]),.out104(mapg_w[104]),.out105(mapg_w[105]),.out106(mapg_w[106]),.out107(mapg_w[107]),.out108(mapg_w[108]),.out109(mapg_w[109]),
.out110(mapg_w[110]),.out111(mapg_w[111]),.out112(mapg_w[112]),.out113(mapg_w[113]),.out114(mapg_w[114]),.out115(mapg_w[115]),.out116(mapg_w[116]),.out117(mapg_w[117]),.out118(mapg_w[118]),.out119(mapg_w[119]),.out120(mapg_w[120]),
.en(en_mapg_r)
);



endmodule