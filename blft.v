// Output SNR ≥ 40 dB (test pattern provided)
// Latency ~= 70k cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process

`include "gaussian.v"
`include "mul_gi.v"

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
reg         en_mapgi_r;
reg         en_mapgi_w;
reg         en_mapghi_r;
reg         en_mapghi_w;

reg  [13:0] mapg_r[0:120];
wire [27:0] mapg_w[0:120];
reg  [27:0] mapgi_r[0:120];
wire [27:0] mapgi_w[0:120];
reg  [27:0] mapghi_r[0:120];
wire [41:0] mapghi_w[0:120];

reg         en_mapi_i0_r;
reg         en_mapi_i0_w;
reg         en_maph_r;
reg         en_maph_w;
reg         en_maphi_r;
reg         en_maphi_w;

reg  [7:0]  mapi_i0_r[0:120];
reg  [7:0]  mapi_i0_w[0:120];
reg  [13:0] maph_r[0:120];
wire [27:0] maph_w[0:120];
reg  [13:0] maphi_r[0:120];
reg  [13:0] maphi_w[0:120];
 
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
    en_mapgi_w      = en_mapgi_r;

    out_valid_w     = out_valid;
    out_addr_w      = { px_row_cntr_r , px_col_cntr_r };
    out_data_w      = out_data;
    finish_w        = finish;
    
    for(i=0;i<121;i=i+1) begin
        mapi_w[i]    = mapi_r[i];
        mapi_i0_w[i] = mapi_i0_r[i];
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

        en_mapg_w       = 1;
        en_mapgi_w      = 1;
        
        en_mapi_i0_w    = 1;
        en_maph_w       = 1;

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
        
        if(en_mapi_i0_r) begin
            for(i=0;i<121;i=i+1)begin
                mapi_i0_w[i] = (mapi_r[i]>mapi_r[60])?mapi_r[i] + (-mapi_r[60]) : (-mapi_r[i]) + mapi_r[60];
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
        en_mapgi_r      <= 0;
        en_mapghi_r     <= 0;
        
        en_mapi_i0_r    <= 0;
        en_maph_r       <= 0;
        en_maphi_r      <= 0;
        
        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= 0;
            mapg_r[i]    <= 0;
            mapgi_r[i]   <= 0;
            mapi_i0_r[i] <= 0;
            maph_r[i]    <= 0;
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
        en_mapgi_r      <= en_mapgi_w;
        en_mapghi_r     <= en_mapghi_w;
        
        en_mapi_i0_r    <= en_mapi_i0_w;
        en_maph_r       <= en_maph_w;
        en_maphi_r      <= en_maphi_w;
        
        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= mapi_w[i];
            mapg_r[i]    <= mapg_w[i][19:6];
            mapgi_r[i]   <= mapgi_w[i];
            mapi_i0_r[i] <= mapi_i0_w[i][19:6];
            maph_r[i]   <= maph_w[i][19:6];
        end
        for(i=0;i<11;i=i+1) begin
            in_buffer_r[i] <= in_buffer_w[i];
        end
    end
end

gaussian i2g(.en(en_mapg_r),
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
.out110(mapg_w[110]),.out111(mapg_w[111]),.out112(mapg_w[112]),.out113(mapg_w[113]),.out114(mapg_w[114]),.out115(mapg_w[115]),.out116(mapg_w[116]),.out117(mapg_w[117]),.out118(mapg_w[118]),.out119(mapg_w[119]),.out120(mapg_w[120])
);

mul_g i2gi(.en(en_mapgi_r),
.i000_g(mapg_r[0  ]),.i001_g(mapg_r[1  ]),.i002_g(mapg_r[2  ]),.i003_g(mapg_r[3  ]),.i004_g(mapg_r[4  ]),.i005_g(mapg_r[5  ]),.i006_g(mapg_r[6  ]),.i007_g(mapg_r[7  ]),.i008_g(mapg_r[8  ]),.i009_g(mapg_r[9  ]),
.i010_g(mapg_r[10 ]),.i011_g(mapg_r[11 ]),.i012_g(mapg_r[12 ]),.i013_g(mapg_r[13 ]),.i014_g(mapg_r[14 ]),.i015_g(mapg_r[15 ]),.i016_g(mapg_r[16 ]),.i017_g(mapg_r[17 ]),.i018_g(mapg_r[18 ]),.i019_g(mapg_r[19 ]),
.i020_g(mapg_r[20 ]),.i021_g(mapg_r[21 ]),.i022_g(mapg_r[22 ]),.i023_g(mapg_r[23 ]),.i024_g(mapg_r[24 ]),.i025_g(mapg_r[25 ]),.i026_g(mapg_r[26 ]),.i027_g(mapg_r[27 ]),.i028_g(mapg_r[28 ]),.i029_g(mapg_r[29 ]),
.i030_g(mapg_r[30 ]),.i031_g(mapg_r[31 ]),.i032_g(mapg_r[32 ]),.i033_g(mapg_r[33 ]),.i034_g(mapg_r[34 ]),.i035_g(mapg_r[35 ]),.i036_g(mapg_r[36 ]),.i037_g(mapg_r[37 ]),.i038_g(mapg_r[38 ]),.i039_g(mapg_r[39 ]),
.i040_g(mapg_r[40 ]),.i041_g(mapg_r[41 ]),.i042_g(mapg_r[42 ]),.i043_g(mapg_r[43 ]),.i044_g(mapg_r[44 ]),.i045_g(mapg_r[45 ]),.i046_g(mapg_r[46 ]),.i047_g(mapg_r[47 ]),.i048_g(mapg_r[48 ]),.i049_g(mapg_r[49 ]),
.i050_g(mapg_r[50 ]),.i051_g(mapg_r[51 ]),.i052_g(mapg_r[52 ]),.i053_g(mapg_r[53 ]),.i054_g(mapg_r[54 ]),.i055_g(mapg_r[55 ]),.i056_g(mapg_r[56 ]),.i057_g(mapg_r[57 ]),.i058_g(mapg_r[58 ]),.i059_g(mapg_r[59 ]),
.i060_g(mapg_r[60 ]),.i061_g(mapg_r[61 ]),.i062_g(mapg_r[62 ]),.i063_g(mapg_r[63 ]),.i064_g(mapg_r[64 ]),.i065_g(mapg_r[65 ]),.i066_g(mapg_r[66 ]),.i067_g(mapg_r[67 ]),.i068_g(mapg_r[68 ]),.i069_g(mapg_r[69 ]),
.i070_g(mapg_r[70 ]),.i071_g(mapg_r[71 ]),.i072_g(mapg_r[72 ]),.i073_g(mapg_r[73 ]),.i074_g(mapg_r[74 ]),.i075_g(mapg_r[75 ]),.i076_g(mapg_r[76 ]),.i077_g(mapg_r[77 ]),.i078_g(mapg_r[78 ]),.i079_g(mapg_r[79 ]),
.i080_g(mapg_r[80 ]),.i081_g(mapg_r[81 ]),.i082_g(mapg_r[82 ]),.i083_g(mapg_r[83 ]),.i084_g(mapg_r[84 ]),.i085_g(mapg_r[85 ]),.i086_g(mapg_r[86 ]),.i087_g(mapg_r[87 ]),.i088_g(mapg_r[88 ]),.i089_g(mapg_r[89 ]),
.i090_g(mapg_r[90 ]),.i091_g(mapg_r[91 ]),.i092_g(mapg_r[92 ]),.i093_g(mapg_r[93 ]),.i094_g(mapg_r[94 ]),.i095_g(mapg_r[95 ]),.i096_g(mapg_r[96 ]),.i097_g(mapg_r[97 ]),.i098_g(mapg_r[98 ]),.i099_g(mapg_r[99 ]),
.i100_g(mapg_r[100]),.i101_g(mapg_r[101]),.i102_g(mapg_r[102]),.i103_g(mapg_r[103]),.i104_g(mapg_r[104]),.i105_g(mapg_r[105]),.i106_g(mapg_r[106]),.i107_g(mapg_r[107]),.i108_g(mapg_r[108]),.i109_g(mapg_r[109]),
.i110_g(mapg_r[110]),.i111_g(mapg_r[111]),.i112_g(mapg_r[112]),.i113_g(mapg_r[113]),.i114_g(mapg_r[114]),.i115_g(mapg_r[115]),.i116_g(mapg_r[116]),.i117_g(mapg_r[117]),.i118_g(mapg_r[118]),.i119_g(mapg_r[119]),.i120_g(mapg_r[120]),
.i000_i(mapi_r[0  ]),.i001_i(mapi_r[1  ]),.i002_i(mapi_r[2  ]),.i003_i(mapi_r[3  ]),.i004_i(mapi_r[4  ]),.i005_i(mapi_r[5  ]),.i006_i(mapi_r[6  ]),.i007_i(mapi_r[7  ]),.i008_i(mapi_r[8  ]),.i009_i(mapi_r[9  ]),
.i010_i(mapi_r[10 ]),.i011_i(mapi_r[11 ]),.i012_i(mapi_r[12 ]),.i013_i(mapi_r[13 ]),.i014_i(mapi_r[14 ]),.i015_i(mapi_r[15 ]),.i016_i(mapi_r[16 ]),.i017_i(mapi_r[17 ]),.i018_i(mapi_r[18 ]),.i019_i(mapi_r[19 ]),
.i020_i(mapi_r[20 ]),.i021_i(mapi_r[21 ]),.i022_i(mapi_r[22 ]),.i023_i(mapi_r[23 ]),.i024_i(mapi_r[24 ]),.i025_i(mapi_r[25 ]),.i026_i(mapi_r[26 ]),.i027_i(mapi_r[27 ]),.i028_i(mapi_r[28 ]),.i029_i(mapi_r[29 ]),
.i030_i(mapi_r[30 ]),.i031_i(mapi_r[31 ]),.i032_i(mapi_r[32 ]),.i033_i(mapi_r[33 ]),.i034_i(mapi_r[34 ]),.i035_i(mapi_r[35 ]),.i036_i(mapi_r[36 ]),.i037_i(mapi_r[37 ]),.i038_i(mapi_r[38 ]),.i039_i(mapi_r[39 ]),
.i040_i(mapi_r[40 ]),.i041_i(mapi_r[41 ]),.i042_i(mapi_r[42 ]),.i043_i(mapi_r[43 ]),.i044_i(mapi_r[44 ]),.i045_i(mapi_r[45 ]),.i046_i(mapi_r[46 ]),.i047_i(mapi_r[47 ]),.i048_i(mapi_r[48 ]),.i049_i(mapi_r[49 ]),
.i050_i(mapi_r[50 ]),.i051_i(mapi_r[51 ]),.i052_i(mapi_r[52 ]),.i053_i(mapi_r[53 ]),.i054_i(mapi_r[54 ]),.i055_i(mapi_r[55 ]),.i056_i(mapi_r[56 ]),.i057_i(mapi_r[57 ]),.i058_i(mapi_r[58 ]),.i059_i(mapi_r[59 ]),
.i060_i(mapi_r[60 ]),.i061_i(mapi_r[61 ]),.i062_i(mapi_r[62 ]),.i063_i(mapi_r[63 ]),.i064_i(mapi_r[64 ]),.i065_i(mapi_r[65 ]),.i066_i(mapi_r[66 ]),.i067_i(mapi_r[67 ]),.i068_i(mapi_r[68 ]),.i069_i(mapi_r[69 ]),
.i070_i(mapi_r[70 ]),.i071_i(mapi_r[71 ]),.i072_i(mapi_r[72 ]),.i073_i(mapi_r[73 ]),.i074_i(mapi_r[74 ]),.i075_i(mapi_r[75 ]),.i076_i(mapi_r[76 ]),.i077_i(mapi_r[77 ]),.i078_i(mapi_r[78 ]),.i079_i(mapi_r[79 ]),
.i080_i(mapi_r[80 ]),.i081_i(mapi_r[81 ]),.i082_i(mapi_r[82 ]),.i083_i(mapi_r[83 ]),.i084_i(mapi_r[84 ]),.i085_i(mapi_r[85 ]),.i086_i(mapi_r[86 ]),.i087_i(mapi_r[87 ]),.i088_i(mapi_r[88 ]),.i089_i(mapi_r[89 ]),
.i090_i(mapi_r[90 ]),.i091_i(mapi_r[91 ]),.i092_i(mapi_r[92 ]),.i093_i(mapi_r[93 ]),.i094_i(mapi_r[94 ]),.i095_i(mapi_r[95 ]),.i096_i(mapi_r[96 ]),.i097_i(mapi_r[97 ]),.i098_i(mapi_r[98 ]),.i099_i(mapi_r[99 ]),
.i100_i(mapi_r[100]),.i101_i(mapi_r[101]),.i102_i(mapi_r[102]),.i103_i(mapi_r[103]),.i104_i(mapi_r[104]),.i105_i(mapi_r[105]),.i106_i(mapi_r[106]),.i107_i(mapi_r[107]),.i108_i(mapi_r[108]),.i109_i(mapi_r[109]),
.i110_i(mapi_r[110]),.i111_i(mapi_r[111]),.i112_i(mapi_r[112]),.i113_i(mapi_r[113]),.i114_i(mapi_r[114]),.i115_i(mapi_r[115]),.i116_i(mapi_r[116]),.i117_i(mapi_r[117]),.i118_i(mapi_r[118]),.i119_i(mapi_r[119]),.i120_i(mapi_r[120]),
.reg000(mapgi_r[0  ]),.reg001(mapgi_r[1  ]),.reg002(mapgi_r[2  ]),.reg003(mapgi_r[3  ]),.reg004(mapgi_r[4  ]),.reg005(mapgi_r[5  ]),.reg006(mapgi_r[6  ]),.reg007(mapgi_r[7  ]),.reg008(mapgi_r[8  ]),.reg009(mapgi_r[9  ]),
.reg010(mapgi_r[10 ]),.reg011(mapgi_r[11 ]),.reg012(mapgi_r[12 ]),.reg013(mapgi_r[13 ]),.reg014(mapgi_r[14 ]),.reg015(mapgi_r[15 ]),.reg016(mapgi_r[16 ]),.reg017(mapgi_r[17 ]),.reg018(mapgi_r[18 ]),.reg019(mapgi_r[19 ]),
.reg020(mapgi_r[20 ]),.reg021(mapgi_r[21 ]),.reg022(mapgi_r[22 ]),.reg023(mapgi_r[23 ]),.reg024(mapgi_r[24 ]),.reg025(mapgi_r[25 ]),.reg026(mapgi_r[26 ]),.reg027(mapgi_r[27 ]),.reg028(mapgi_r[28 ]),.reg029(mapgi_r[29 ]),
.reg030(mapgi_r[30 ]),.reg031(mapgi_r[31 ]),.reg032(mapgi_r[32 ]),.reg033(mapgi_r[33 ]),.reg034(mapgi_r[34 ]),.reg035(mapgi_r[35 ]),.reg036(mapgi_r[36 ]),.reg037(mapgi_r[37 ]),.reg038(mapgi_r[38 ]),.reg039(mapgi_r[39 ]),
.reg040(mapgi_r[40 ]),.reg041(mapgi_r[41 ]),.reg042(mapgi_r[42 ]),.reg043(mapgi_r[43 ]),.reg044(mapgi_r[44 ]),.reg045(mapgi_r[45 ]),.reg046(mapgi_r[46 ]),.reg047(mapgi_r[47 ]),.reg048(mapgi_r[48 ]),.reg049(mapgi_r[49 ]),
.reg050(mapgi_r[50 ]),.reg051(mapgi_r[51 ]),.reg052(mapgi_r[52 ]),.reg053(mapgi_r[53 ]),.reg054(mapgi_r[54 ]),.reg055(mapgi_r[55 ]),.reg056(mapgi_r[56 ]),.reg057(mapgi_r[57 ]),.reg058(mapgi_r[58 ]),.reg059(mapgi_r[59 ]),
.reg060(mapgi_r[60 ]),.reg061(mapgi_r[61 ]),.reg062(mapgi_r[62 ]),.reg063(mapgi_r[63 ]),.reg064(mapgi_r[64 ]),.reg065(mapgi_r[65 ]),.reg066(mapgi_r[66 ]),.reg067(mapgi_r[67 ]),.reg068(mapgi_r[68 ]),.reg069(mapgi_r[69 ]),
.reg070(mapgi_r[70 ]),.reg071(mapgi_r[71 ]),.reg072(mapgi_r[72 ]),.reg073(mapgi_r[73 ]),.reg074(mapgi_r[74 ]),.reg075(mapgi_r[75 ]),.reg076(mapgi_r[76 ]),.reg077(mapgi_r[77 ]),.reg078(mapgi_r[78 ]),.reg079(mapgi_r[79 ]),
.reg080(mapgi_r[80 ]),.reg081(mapgi_r[81 ]),.reg082(mapgi_r[82 ]),.reg083(mapgi_r[83 ]),.reg084(mapgi_r[84 ]),.reg085(mapgi_r[85 ]),.reg086(mapgi_r[86 ]),.reg087(mapgi_r[87 ]),.reg088(mapgi_r[88 ]),.reg089(mapgi_r[89 ]),
.reg090(mapgi_r[90 ]),.reg091(mapgi_r[91 ]),.reg092(mapgi_r[92 ]),.reg093(mapgi_r[93 ]),.reg094(mapgi_r[94 ]),.reg095(mapgi_r[95 ]),.reg096(mapgi_r[96 ]),.reg097(mapgi_r[97 ]),.reg098(mapgi_r[98 ]),.reg099(mapgi_r[99 ]),
.reg100(mapgi_r[100]),.reg101(mapgi_r[101]),.reg102(mapgi_r[102]),.reg103(mapgi_r[103]),.reg104(mapgi_r[104]),.reg105(mapgi_r[105]),.reg106(mapgi_r[106]),.reg107(mapgi_r[107]),.reg108(mapgi_r[108]),.reg109(mapgi_r[109]),
.reg110(mapgi_r[110]),.reg111(mapgi_r[111]),.reg112(mapgi_r[112]),.reg113(mapgi_r[113]),.reg114(mapgi_r[114]),.reg115(mapgi_r[115]),.reg116(mapgi_r[116]),.reg117(mapgi_r[117]),.reg118(mapgi_r[118]),.reg119(mapgi_r[119]),.reg120(mapgi_r[120]),
.out000(mapgi_w[0  ]),.out001(mapgi_w[1  ]),.out002(mapgi_w[2  ]),.out003(mapgi_w[3  ]),.out004(mapgi_w[4  ]),.out005(mapgi_w[5  ]),.out006(mapgi_w[6  ]),.out007(mapgi_w[7  ]),.out008(mapgi_w[8  ]),.out009(mapgi_w[9  ]),
.out010(mapgi_w[10 ]),.out011(mapgi_w[11 ]),.out012(mapgi_w[12 ]),.out013(mapgi_w[13 ]),.out014(mapgi_w[14 ]),.out015(mapgi_w[15 ]),.out016(mapgi_w[16 ]),.out017(mapgi_w[17 ]),.out018(mapgi_w[18 ]),.out019(mapgi_w[19 ]),
.out020(mapgi_w[20 ]),.out021(mapgi_w[21 ]),.out022(mapgi_w[22 ]),.out023(mapgi_w[23 ]),.out024(mapgi_w[24 ]),.out025(mapgi_w[25 ]),.out026(mapgi_w[26 ]),.out027(mapgi_w[27 ]),.out028(mapgi_w[28 ]),.out029(mapgi_w[29 ]),
.out030(mapgi_w[30 ]),.out031(mapgi_w[31 ]),.out032(mapgi_w[32 ]),.out033(mapgi_w[33 ]),.out034(mapgi_w[34 ]),.out035(mapgi_w[35 ]),.out036(mapgi_w[36 ]),.out037(mapgi_w[37 ]),.out038(mapgi_w[38 ]),.out039(mapgi_w[39 ]),
.out040(mapgi_w[40 ]),.out041(mapgi_w[41 ]),.out042(mapgi_w[42 ]),.out043(mapgi_w[43 ]),.out044(mapgi_w[44 ]),.out045(mapgi_w[45 ]),.out046(mapgi_w[46 ]),.out047(mapgi_w[47 ]),.out048(mapgi_w[48 ]),.out049(mapgi_w[49 ]),
.out050(mapgi_w[50 ]),.out051(mapgi_w[51 ]),.out052(mapgi_w[52 ]),.out053(mapgi_w[53 ]),.out054(mapgi_w[54 ]),.out055(mapgi_w[55 ]),.out056(mapgi_w[56 ]),.out057(mapgi_w[57 ]),.out058(mapgi_w[58 ]),.out059(mapgi_w[59 ]),
.out060(mapgi_w[60 ]),.out061(mapgi_w[61 ]),.out062(mapgi_w[62 ]),.out063(mapgi_w[63 ]),.out064(mapgi_w[64 ]),.out065(mapgi_w[65 ]),.out066(mapgi_w[66 ]),.out067(mapgi_w[67 ]),.out068(mapgi_w[68 ]),.out069(mapgi_w[69 ]),
.out070(mapgi_w[70 ]),.out071(mapgi_w[71 ]),.out072(mapgi_w[72 ]),.out073(mapgi_w[73 ]),.out074(mapgi_w[74 ]),.out075(mapgi_w[75 ]),.out076(mapgi_w[76 ]),.out077(mapgi_w[77 ]),.out078(mapgi_w[78 ]),.out079(mapgi_w[79 ]),
.out080(mapgi_w[80 ]),.out081(mapgi_w[81 ]),.out082(mapgi_w[82 ]),.out083(mapgi_w[83 ]),.out084(mapgi_w[84 ]),.out085(mapgi_w[85 ]),.out086(mapgi_w[86 ]),.out087(mapgi_w[87 ]),.out088(mapgi_w[88 ]),.out089(mapgi_w[89 ]),
.out090(mapgi_w[90 ]),.out091(mapgi_w[91 ]),.out092(mapgi_w[92 ]),.out093(mapgi_w[93 ]),.out094(mapgi_w[94 ]),.out095(mapgi_w[95 ]),.out096(mapgi_w[96 ]),.out097(mapgi_w[97 ]),.out098(mapgi_w[98 ]),.out099(mapgi_w[99 ]),
.out100(mapgi_w[100]),.out101(mapgi_w[101]),.out102(mapgi_w[102]),.out103(mapgi_w[103]),.out104(mapgi_w[104]),.out105(mapgi_w[105]),.out106(mapgi_w[106]),.out107(mapgi_w[107]),.out108(mapgi_w[108]),.out109(mapgi_w[109]),
.out110(mapgi_w[110]),.out111(mapgi_w[111]),.out112(mapgi_w[112]),.out113(mapgi_w[113]),.out114(mapgi_w[114]),.out115(mapgi_w[115]),.out116(mapgi_w[116]),.out117(mapgi_w[117]),.out118(mapgi_w[118]),.out119(mapgi_w[119]),.out120(mapgi_w[120])
);

mul_h i_i02h(.en(en_maph_r),
.i000_n(mapi_i0_r[0  ]),.i001_n(mapi_i0_r[1  ]),.i002_n(mapi_i0_r[2  ]),.i003_n(mapi_i0_r[3  ]),.i004_n(mapi_i0_r[4  ]),.i005_n(mapi_i0_r[5  ]),.i006_n(mapi_i0_r[6  ]),.i007_n(mapi_i0_r[7  ]),.i008_n(mapi_i0_r[8  ]),.i009_n(mapi_i0_r[9  ]),
.i010_n(mapi_i0_r[10 ]),.i011_n(mapi_i0_r[11 ]),.i012_n(mapi_i0_r[12 ]),.i013_n(mapi_i0_r[13 ]),.i014_n(mapi_i0_r[14 ]),.i015_n(mapi_i0_r[15 ]),.i016_n(mapi_i0_r[16 ]),.i017_n(mapi_i0_r[17 ]),.i018_n(mapi_i0_r[18 ]),.i019_n(mapi_i0_r[19 ]),
.i020_n(mapi_i0_r[20 ]),.i021_n(mapi_i0_r[21 ]),.i022_n(mapi_i0_r[22 ]),.i023_n(mapi_i0_r[23 ]),.i024_n(mapi_i0_r[24 ]),.i025_n(mapi_i0_r[25 ]),.i026_n(mapi_i0_r[26 ]),.i027_n(mapi_i0_r[27 ]),.i028_n(mapi_i0_r[28 ]),.i029_n(mapi_i0_r[29 ]),
.i030_n(mapi_i0_r[30 ]),.i031_n(mapi_i0_r[31 ]),.i032_n(mapi_i0_r[32 ]),.i033_n(mapi_i0_r[33 ]),.i034_n(mapi_i0_r[34 ]),.i035_n(mapi_i0_r[35 ]),.i036_n(mapi_i0_r[36 ]),.i037_n(mapi_i0_r[37 ]),.i038_n(mapi_i0_r[38 ]),.i039_n(mapi_i0_r[39 ]),
.i040_n(mapi_i0_r[40 ]),.i041_n(mapi_i0_r[41 ]),.i042_n(mapi_i0_r[42 ]),.i043_n(mapi_i0_r[43 ]),.i044_n(mapi_i0_r[44 ]),.i045_n(mapi_i0_r[45 ]),.i046_n(mapi_i0_r[46 ]),.i047_n(mapi_i0_r[47 ]),.i048_n(mapi_i0_r[48 ]),.i049_n(mapi_i0_r[49 ]),
.i050_n(mapi_i0_r[50 ]),.i051_n(mapi_i0_r[51 ]),.i052_n(mapi_i0_r[52 ]),.i053_n(mapi_i0_r[53 ]),.i054_n(mapi_i0_r[54 ]),.i055_n(mapi_i0_r[55 ]),.i056_n(mapi_i0_r[56 ]),.i057_n(mapi_i0_r[57 ]),.i058_n(mapi_i0_r[58 ]),.i059_n(mapi_i0_r[59 ]),
.i060_n(mapi_i0_r[60 ]),.i061_n(mapi_i0_r[61 ]),.i062_n(mapi_i0_r[62 ]),.i063_n(mapi_i0_r[63 ]),.i064_n(mapi_i0_r[64 ]),.i065_n(mapi_i0_r[65 ]),.i066_n(mapi_i0_r[66 ]),.i067_n(mapi_i0_r[67 ]),.i068_n(mapi_i0_r[68 ]),.i069_n(mapi_i0_r[69 ]),
.i070_n(mapi_i0_r[70 ]),.i071_n(mapi_i0_r[71 ]),.i072_n(mapi_i0_r[72 ]),.i073_n(mapi_i0_r[73 ]),.i074_n(mapi_i0_r[74 ]),.i075_n(mapi_i0_r[75 ]),.i076_n(mapi_i0_r[76 ]),.i077_n(mapi_i0_r[77 ]),.i078_n(mapi_i0_r[78 ]),.i079_n(mapi_i0_r[79 ]),
.i080_n(mapi_i0_r[80 ]),.i081_n(mapi_i0_r[81 ]),.i082_n(mapi_i0_r[82 ]),.i083_n(mapi_i0_r[83 ]),.i084_n(mapi_i0_r[84 ]),.i085_n(mapi_i0_r[85 ]),.i086_n(mapi_i0_r[86 ]),.i087_n(mapi_i0_r[87 ]),.i088_n(mapi_i0_r[88 ]),.i089_n(mapi_i0_r[89 ]),
.i090_n(mapi_i0_r[90 ]),.i091_n(mapi_i0_r[91 ]),.i092_n(mapi_i0_r[92 ]),.i093_n(mapi_i0_r[93 ]),.i094_n(mapi_i0_r[94 ]),.i095_n(mapi_i0_r[95 ]),.i096_n(mapi_i0_r[96 ]),.i097_n(mapi_i0_r[97 ]),.i098_n(mapi_i0_r[98 ]),.i099_n(mapi_i0_r[99 ]),
.i100_n(mapi_i0_r[100]),.i101_n(mapi_i0_r[101]),.i102_n(mapi_i0_r[102]),.i103_n(mapi_i0_r[103]),.i104_n(mapi_i0_r[104]),.i105_n(mapi_i0_r[105]),.i106_n(mapi_i0_r[106]),.i107_n(mapi_i0_r[107]),.i108_n(mapi_i0_r[108]),.i109_n(mapi_i0_r[109]),
.i110_n(mapi_i0_r[110]),.i111_n(mapi_i0_r[111]),.i112_n(mapi_i0_r[112]),.i113_n(mapi_i0_r[113]),.i114_n(mapi_i0_r[114]),.i115_n(mapi_i0_r[115]),.i116_n(mapi_i0_r[116]),.i117_n(mapi_i0_r[117]),.i118_n(mapi_i0_r[118]),.i119_n(mapi_i0_r[119]),.i120_n(mapi_i0_r[120]),
.i000_r(maph_r[0  ]),.i001_r(maph_r[1  ]),.i002_r(maph_r[2  ]),.i003_r(maph_r[3  ]),.i004_r(maph_r[4  ]),.i005_r(maph_r[5  ]),.i006_r(maph_r[6  ]),.i007_r(maph_r[7  ]),.i008_r(maph_r[8  ]),.i009_r(maph_r[9  ]),
.i010_r(maph_r[10 ]),.i011_r(maph_r[11 ]),.i012_r(maph_r[12 ]),.i013_r(maph_r[13 ]),.i014_r(maph_r[14 ]),.i015_r(maph_r[15 ]),.i016_r(maph_r[16 ]),.i017_r(maph_r[17 ]),.i018_r(maph_r[18 ]),.i019_r(maph_r[19 ]),
.i020_r(maph_r[20 ]),.i021_r(maph_r[21 ]),.i022_r(maph_r[22 ]),.i023_r(maph_r[23 ]),.i024_r(maph_r[24 ]),.i025_r(maph_r[25 ]),.i026_r(maph_r[26 ]),.i027_r(maph_r[27 ]),.i028_r(maph_r[28 ]),.i029_r(maph_r[29 ]),
.i030_r(maph_r[30 ]),.i031_r(maph_r[31 ]),.i032_r(maph_r[32 ]),.i033_r(maph_r[33 ]),.i034_r(maph_r[34 ]),.i035_r(maph_r[35 ]),.i036_r(maph_r[36 ]),.i037_r(maph_r[37 ]),.i038_r(maph_r[38 ]),.i039_r(maph_r[39 ]),
.i040_r(maph_r[40 ]),.i041_r(maph_r[41 ]),.i042_r(maph_r[42 ]),.i043_r(maph_r[43 ]),.i044_r(maph_r[44 ]),.i045_r(maph_r[45 ]),.i046_r(maph_r[46 ]),.i047_r(maph_r[47 ]),.i048_r(maph_r[48 ]),.i049_r(maph_r[49 ]),
.i050_r(maph_r[50 ]),.i051_r(maph_r[51 ]),.i052_r(maph_r[52 ]),.i053_r(maph_r[53 ]),.i054_r(maph_r[54 ]),.i055_r(maph_r[55 ]),.i056_r(maph_r[56 ]),.i057_r(maph_r[57 ]),.i058_r(maph_r[58 ]),.i059_r(maph_r[59 ]),
.i060_r(maph_r[60 ]),.i061_r(maph_r[61 ]),.i062_r(maph_r[62 ]),.i063_r(maph_r[63 ]),.i064_r(maph_r[64 ]),.i065_r(maph_r[65 ]),.i066_r(maph_r[66 ]),.i067_r(maph_r[67 ]),.i068_r(maph_r[68 ]),.i069_r(maph_r[69 ]),
.i070_r(maph_r[70 ]),.i071_r(maph_r[71 ]),.i072_r(maph_r[72 ]),.i073_r(maph_r[73 ]),.i074_r(maph_r[74 ]),.i075_r(maph_r[75 ]),.i076_r(maph_r[76 ]),.i077_r(maph_r[77 ]),.i078_r(maph_r[78 ]),.i079_r(maph_r[79 ]),
.i080_r(maph_r[80 ]),.i081_r(maph_r[81 ]),.i082_r(maph_r[82 ]),.i083_r(maph_r[83 ]),.i084_r(maph_r[84 ]),.i085_r(maph_r[85 ]),.i086_r(maph_r[86 ]),.i087_r(maph_r[87 ]),.i088_r(maph_r[88 ]),.i089_r(maph_r[89 ]),
.i090_r(maph_r[90 ]),.i091_r(maph_r[91 ]),.i092_r(maph_r[92 ]),.i093_r(maph_r[93 ]),.i094_r(maph_r[94 ]),.i095_r(maph_r[95 ]),.i096_r(maph_r[96 ]),.i097_r(maph_r[97 ]),.i098_r(maph_r[98 ]),.i099_r(maph_r[99 ]),
.i100_r(maph_r[100]),.i101_r(maph_r[101]),.i102_r(maph_r[102]),.i103_r(maph_r[103]),.i104_r(maph_r[104]),.i105_r(maph_r[105]),.i106_r(maph_r[106]),.i107_r(maph_r[107]),.i108_r(maph_r[108]),.i109_r(maph_r[109]),
.i110_r(maph_r[110]),.i111_r(maph_r[111]),.i112_r(maph_r[112]),.i113_r(maph_r[113]),.i114_r(maph_r[114]),.i115_r(maph_r[115]),.i116_r(maph_r[116]),.i117_r(maph_r[117]),.i118_r(maph_r[118]),.i119_r(maph_r[119]),.i120_r(maph_r[120]),
.out000(maph_w[0  ]),.out001(maph_w[1  ]),.out002(maph_w[2  ]),.out003(maph_w[3  ]),.out004(maph_w[4  ]),.out005(maph_w[5  ]),.out006(maph_w[6  ]),.out007(maph_w[7  ]),.out008(maph_w[8  ]),.out009(maph_w[9  ]),
.out010(maph_w[10 ]),.out011(maph_w[11 ]),.out012(maph_w[12 ]),.out013(maph_w[13 ]),.out014(maph_w[14 ]),.out015(maph_w[15 ]),.out016(maph_w[16 ]),.out017(maph_w[17 ]),.out018(maph_w[18 ]),.out019(maph_w[19 ]),
.out020(maph_w[20 ]),.out021(maph_w[21 ]),.out022(maph_w[22 ]),.out023(maph_w[23 ]),.out024(maph_w[24 ]),.out025(maph_w[25 ]),.out026(maph_w[26 ]),.out027(maph_w[27 ]),.out028(maph_w[28 ]),.out029(maph_w[29 ]),
.out030(maph_w[30 ]),.out031(maph_w[31 ]),.out032(maph_w[32 ]),.out033(maph_w[33 ]),.out034(maph_w[34 ]),.out035(maph_w[35 ]),.out036(maph_w[36 ]),.out037(maph_w[37 ]),.out038(maph_w[38 ]),.out039(maph_w[39 ]),
.out040(maph_w[40 ]),.out041(maph_w[41 ]),.out042(maph_w[42 ]),.out043(maph_w[43 ]),.out044(maph_w[44 ]),.out045(maph_w[45 ]),.out046(maph_w[46 ]),.out047(maph_w[47 ]),.out048(maph_w[48 ]),.out049(maph_w[49 ]),
.out050(maph_w[50 ]),.out051(maph_w[51 ]),.out052(maph_w[52 ]),.out053(maph_w[53 ]),.out054(maph_w[54 ]),.out055(maph_w[55 ]),.out056(maph_w[56 ]),.out057(maph_w[57 ]),.out058(maph_w[58 ]),.out059(maph_w[59 ]),
.out060(maph_w[60 ]),.out061(maph_w[61 ]),.out062(maph_w[62 ]),.out063(maph_w[63 ]),.out064(maph_w[64 ]),.out065(maph_w[65 ]),.out066(maph_w[66 ]),.out067(maph_w[67 ]),.out068(maph_w[68 ]),.out069(maph_w[69 ]),
.out070(maph_w[70 ]),.out071(maph_w[71 ]),.out072(maph_w[72 ]),.out073(maph_w[73 ]),.out074(maph_w[74 ]),.out075(maph_w[75 ]),.out076(maph_w[76 ]),.out077(maph_w[77 ]),.out078(maph_w[78 ]),.out079(maph_w[79 ]),
.out080(maph_w[80 ]),.out081(maph_w[81 ]),.out082(maph_w[82 ]),.out083(maph_w[83 ]),.out084(maph_w[84 ]),.out085(maph_w[85 ]),.out086(maph_w[86 ]),.out087(maph_w[87 ]),.out088(maph_w[88 ]),.out089(maph_w[89 ]),
.out090(maph_w[90 ]),.out091(maph_w[91 ]),.out092(maph_w[92 ]),.out093(maph_w[93 ]),.out094(maph_w[94 ]),.out095(maph_w[95 ]),.out096(maph_w[96 ]),.out097(maph_w[97 ]),.out098(maph_w[98 ]),.out099(maph_w[99 ]),
.out100(maph_w[100]),.out101(maph_w[101]),.out102(maph_w[102]),.out103(maph_w[103]),.out104(maph_w[104]),.out105(maph_w[105]),.out106(maph_w[106]),.out107(maph_w[107]),.out108(maph_w[108]),.out109(maph_w[109]),
.out110(maph_w[110]),.out111(maph_w[111]),.out112(maph_w[112]),.out113(maph_w[113]),.out114(maph_w[114]),.out115(maph_w[115]),.out116(maph_w[116]),.out117(maph_w[117]),.out118(maph_w[118]),.out119(maph_w[119]),.out120(maph_w[120])
);

endmodule