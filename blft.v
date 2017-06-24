// Output SNR ≥ 40 dB (test pattern provided)
// Latency ~= 70k cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process

`include "mul_g.v"
`include "mul_gi.v"
`include "mul_ghi.v"
`include "mul_h.v"
`include "mul_hi.v"

`include "sum_ghi.v"
`include "sum_hi.v"

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
reg         en_sum_ghi_r;
reg         en_sum_ghi_w;

reg  [13:0] mapg_r[0:120];
wire [27:0] mapg_w[0:120];
reg  [27:0] mapgi_r[0:120];
wire [27:0] mapgi_w[0:120];
reg  [27:0] mapghi_r[0:120];
wire [55:0] mapghi_w[0:120];
reg  [34:0] sum_ghi_r;
wire [34:0] sum_ghi_w;

reg         en_mapi_i0_r;
reg         en_mapi_i0_w;
reg         en_maph_r;
reg         en_maph_w;
reg         en_maphi_r;
reg         en_maphi_w;
reg         en_sum_hi_r;
reg         en_sum_hi_w;

reg  [7:0]  mapi_i0_r[0:120];
reg  [7:0]  mapi_i0_w[0:120];
reg  [13:0] maph_r[0:120];
wire [13:0] maph_w[0:120];
reg  [13:0] maphi_r[0:120];
wire [27:0] maphi_w[0:120];
reg  [20:0] sum_hi_r;
wire [20:0] sum_hi_w;
 
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
        en_mapghi_w     = 1;
        en_sum_ghi_w    = 1;
        
        en_mapi_i0_w    = 1;
        en_maph_w       = 1;
        en_maphi_w      = 1;
        en_sum_hi_w     = 1;
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
        en_sum_ghi_r    <= 0;
        
        en_mapi_i0_r    <= 0;
        en_maph_r       <= 0;
        en_maphi_r      <= 0;
        en_sum_hi_r     <= 0;

        sum_ghi_r       <= 0;
        sum_hi_r        <= 0;
        
        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= 0;
            mapg_r[i]    <= 0;
            mapgi_r[i]   <= 0;
            mapghi_r[i]  <= 0;
            mapi_i0_r[i] <= 0;
            maph_r[i]    <= 0;
            maphi_r[i]   <= 0;
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
        en_sum_ghi_r    <= en_sum_ghi_w;
        
        en_mapi_i0_r    <= en_mapi_i0_w;
        en_maph_r       <= en_maph_w;
        en_maphi_r      <= en_maphi_w;
        en_sum_hi_r     <= en_sum_hi_w;

        sum_ghi_r       <= sum_ghi_w;
        sum_hi_r        <= sum_hi_w;

        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= mapi_w[i];
            mapg_r[i]    <= mapg_w[i][19:6];
            mapgi_r[i]   <= mapgi_w[i];
            mapghi_r[i]  <= mapghi_w[i][39:12];
            mapi_i0_r[i] <= mapi_i0_w[i];
            maph_r[i]    <= maph_w[i];
            maphi_r[i]   <= maphi_w[i][19:6];
        end
        for(i=0;i<11;i=i+1) begin
            in_buffer_r[i] <= in_buffer_w[i];
        end
    end
end

mul_g i2g(.en(en_mapg_r),
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
.reg000(mapg_r[0  ]),.reg001(mapg_r[1  ]),.reg002(mapg_r[2  ]),.reg003(mapg_r[3  ]),.reg004(mapg_r[4  ]),.reg005(mapg_r[5  ]),.reg006(mapg_r[6  ]),.reg007(mapg_r[7  ]),.reg008(mapg_r[8  ]),.reg009(mapg_r[9  ]),
.reg010(mapg_r[10 ]),.reg011(mapg_r[11 ]),.reg012(mapg_r[12 ]),.reg013(mapg_r[13 ]),.reg014(mapg_r[14 ]),.reg015(mapg_r[15 ]),.reg016(mapg_r[16 ]),.reg017(mapg_r[17 ]),.reg018(mapg_r[18 ]),.reg019(mapg_r[19 ]),
.reg020(mapg_r[20 ]),.reg021(mapg_r[21 ]),.reg022(mapg_r[22 ]),.reg023(mapg_r[23 ]),.reg024(mapg_r[24 ]),.reg025(mapg_r[25 ]),.reg026(mapg_r[26 ]),.reg027(mapg_r[27 ]),.reg028(mapg_r[28 ]),.reg029(mapg_r[29 ]),
.reg030(mapg_r[30 ]),.reg031(mapg_r[31 ]),.reg032(mapg_r[32 ]),.reg033(mapg_r[33 ]),.reg034(mapg_r[34 ]),.reg035(mapg_r[35 ]),.reg036(mapg_r[36 ]),.reg037(mapg_r[37 ]),.reg038(mapg_r[38 ]),.reg039(mapg_r[39 ]),
.reg040(mapg_r[40 ]),.reg041(mapg_r[41 ]),.reg042(mapg_r[42 ]),.reg043(mapg_r[43 ]),.reg044(mapg_r[44 ]),.reg045(mapg_r[45 ]),.reg046(mapg_r[46 ]),.reg047(mapg_r[47 ]),.reg048(mapg_r[48 ]),.reg049(mapg_r[49 ]),
.reg050(mapg_r[50 ]),.reg051(mapg_r[51 ]),.reg052(mapg_r[52 ]),.reg053(mapg_r[53 ]),.reg054(mapg_r[54 ]),.reg055(mapg_r[55 ]),.reg056(mapg_r[56 ]),.reg057(mapg_r[57 ]),.reg058(mapg_r[58 ]),.reg059(mapg_r[59 ]),
.reg060(mapg_r[60 ]),.reg061(mapg_r[61 ]),.reg062(mapg_r[62 ]),.reg063(mapg_r[63 ]),.reg064(mapg_r[64 ]),.reg065(mapg_r[65 ]),.reg066(mapg_r[66 ]),.reg067(mapg_r[67 ]),.reg068(mapg_r[68 ]),.reg069(mapg_r[69 ]),
.reg070(mapg_r[70 ]),.reg071(mapg_r[71 ]),.reg072(mapg_r[72 ]),.reg073(mapg_r[73 ]),.reg074(mapg_r[74 ]),.reg075(mapg_r[75 ]),.reg076(mapg_r[76 ]),.reg077(mapg_r[77 ]),.reg078(mapg_r[78 ]),.reg079(mapg_r[79 ]),
.reg080(mapg_r[80 ]),.reg081(mapg_r[81 ]),.reg082(mapg_r[82 ]),.reg083(mapg_r[83 ]),.reg084(mapg_r[84 ]),.reg085(mapg_r[85 ]),.reg086(mapg_r[86 ]),.reg087(mapg_r[87 ]),.reg088(mapg_r[88 ]),.reg089(mapg_r[89 ]),
.reg090(mapg_r[90 ]),.reg091(mapg_r[91 ]),.reg092(mapg_r[92 ]),.reg093(mapg_r[93 ]),.reg094(mapg_r[94 ]),.reg095(mapg_r[95 ]),.reg096(mapg_r[96 ]),.reg097(mapg_r[97 ]),.reg098(mapg_r[98 ]),.reg099(mapg_r[99 ]),
.reg100(mapg_r[100]),.reg101(mapg_r[101]),.reg102(mapg_r[102]),.reg103(mapg_r[103]),.reg104(mapg_r[104]),.reg105(mapg_r[105]),.reg106(mapg_r[106]),.reg107(mapg_r[107]),.reg108(mapg_r[108]),.reg109(mapg_r[109]),
.reg110(mapg_r[110]),.reg111(mapg_r[111]),.reg112(mapg_r[112]),.reg113(mapg_r[113]),.reg114(mapg_r[114]),.reg115(mapg_r[115]),.reg116(mapg_r[116]),.reg117(mapg_r[117]),.reg118(mapg_r[118]),.reg119(mapg_r[119]),.reg120(mapg_r[120]),
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

mul_gi i2gi(.en(en_mapgi_r),
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

mul_h i_i02h(.en(en_maph_r),.clk(clk),.rst(rst),
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
.reg000(maph_r[0  ]),.reg001(maph_r[1  ]),.reg002(maph_r[2  ]),.reg003(maph_r[3  ]),.reg004(maph_r[4  ]),.reg005(maph_r[5  ]),.reg006(maph_r[6  ]),.reg007(maph_r[7  ]),.reg008(maph_r[8  ]),.reg009(maph_r[9  ]),
.reg010(maph_r[10 ]),.reg011(maph_r[11 ]),.reg012(maph_r[12 ]),.reg013(maph_r[13 ]),.reg014(maph_r[14 ]),.reg015(maph_r[15 ]),.reg016(maph_r[16 ]),.reg017(maph_r[17 ]),.reg018(maph_r[18 ]),.reg019(maph_r[19 ]),
.reg020(maph_r[20 ]),.reg021(maph_r[21 ]),.reg022(maph_r[22 ]),.reg023(maph_r[23 ]),.reg024(maph_r[24 ]),.reg025(maph_r[25 ]),.reg026(maph_r[26 ]),.reg027(maph_r[27 ]),.reg028(maph_r[28 ]),.reg029(maph_r[29 ]),
.reg030(maph_r[30 ]),.reg031(maph_r[31 ]),.reg032(maph_r[32 ]),.reg033(maph_r[33 ]),.reg034(maph_r[34 ]),.reg035(maph_r[35 ]),.reg036(maph_r[36 ]),.reg037(maph_r[37 ]),.reg038(maph_r[38 ]),.reg039(maph_r[39 ]),
.reg040(maph_r[40 ]),.reg041(maph_r[41 ]),.reg042(maph_r[42 ]),.reg043(maph_r[43 ]),.reg044(maph_r[44 ]),.reg045(maph_r[45 ]),.reg046(maph_r[46 ]),.reg047(maph_r[47 ]),.reg048(maph_r[48 ]),.reg049(maph_r[49 ]),
.reg050(maph_r[50 ]),.reg051(maph_r[51 ]),.reg052(maph_r[52 ]),.reg053(maph_r[53 ]),.reg054(maph_r[54 ]),.reg055(maph_r[55 ]),.reg056(maph_r[56 ]),.reg057(maph_r[57 ]),.reg058(maph_r[58 ]),.reg059(maph_r[59 ]),
.reg060(maph_r[60 ]),.reg061(maph_r[61 ]),.reg062(maph_r[62 ]),.reg063(maph_r[63 ]),.reg064(maph_r[64 ]),.reg065(maph_r[65 ]),.reg066(maph_r[66 ]),.reg067(maph_r[67 ]),.reg068(maph_r[68 ]),.reg069(maph_r[69 ]),
.reg070(maph_r[70 ]),.reg071(maph_r[71 ]),.reg072(maph_r[72 ]),.reg073(maph_r[73 ]),.reg074(maph_r[74 ]),.reg075(maph_r[75 ]),.reg076(maph_r[76 ]),.reg077(maph_r[77 ]),.reg078(maph_r[78 ]),.reg079(maph_r[79 ]),
.reg080(maph_r[80 ]),.reg081(maph_r[81 ]),.reg082(maph_r[82 ]),.reg083(maph_r[83 ]),.reg084(maph_r[84 ]),.reg085(maph_r[85 ]),.reg086(maph_r[86 ]),.reg087(maph_r[87 ]),.reg088(maph_r[88 ]),.reg089(maph_r[89 ]),
.reg090(maph_r[90 ]),.reg091(maph_r[91 ]),.reg092(maph_r[92 ]),.reg093(maph_r[93 ]),.reg094(maph_r[94 ]),.reg095(maph_r[95 ]),.reg096(maph_r[96 ]),.reg097(maph_r[97 ]),.reg098(maph_r[98 ]),.reg099(maph_r[99 ]),
.reg100(maph_r[100]),.reg101(maph_r[101]),.reg102(maph_r[102]),.reg103(maph_r[103]),.reg104(maph_r[104]),.reg105(maph_r[105]),.reg106(maph_r[106]),.reg107(maph_r[107]),.reg108(maph_r[108]),.reg109(maph_r[109]),
.reg110(maph_r[110]),.reg111(maph_r[111]),.reg112(maph_r[112]),.reg113(maph_r[113]),.reg114(maph_r[114]),.reg115(maph_r[115]),.reg116(maph_r[116]),.reg117(maph_r[117]),.reg118(maph_r[118]),.reg119(maph_r[119]),.reg120(maph_r[120]),
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


mul_ghi gi2ghi(.en(en_mapghi_r),
.i000_gi(mapgi_r[0  ]),.i001_gi(mapgi_r[1  ]),.i002_gi(mapgi_r[2  ]),.i003_gi(mapgi_r[3  ]),.i004_gi(mapgi_r[4  ]),.i005_gi(mapgi_r[5  ]),.i006_gi(mapgi_r[6  ]),.i007_gi(mapgi_r[7  ]),.i008_gi(mapgi_r[8  ]),.i009_gi(mapgi_r[9  ]),
.i010_gi(mapgi_r[10 ]),.i011_gi(mapgi_r[11 ]),.i012_gi(mapgi_r[12 ]),.i013_gi(mapgi_r[13 ]),.i014_gi(mapgi_r[14 ]),.i015_gi(mapgi_r[15 ]),.i016_gi(mapgi_r[16 ]),.i017_gi(mapgi_r[17 ]),.i018_gi(mapgi_r[18 ]),.i019_gi(mapgi_r[19 ]),
.i020_gi(mapgi_r[20 ]),.i021_gi(mapgi_r[21 ]),.i022_gi(mapgi_r[22 ]),.i023_gi(mapgi_r[23 ]),.i024_gi(mapgi_r[24 ]),.i025_gi(mapgi_r[25 ]),.i026_gi(mapgi_r[26 ]),.i027_gi(mapgi_r[27 ]),.i028_gi(mapgi_r[28 ]),.i029_gi(mapgi_r[29 ]),
.i030_gi(mapgi_r[30 ]),.i031_gi(mapgi_r[31 ]),.i032_gi(mapgi_r[32 ]),.i033_gi(mapgi_r[33 ]),.i034_gi(mapgi_r[34 ]),.i035_gi(mapgi_r[35 ]),.i036_gi(mapgi_r[36 ]),.i037_gi(mapgi_r[37 ]),.i038_gi(mapgi_r[38 ]),.i039_gi(mapgi_r[39 ]),
.i040_gi(mapgi_r[40 ]),.i041_gi(mapgi_r[41 ]),.i042_gi(mapgi_r[42 ]),.i043_gi(mapgi_r[43 ]),.i044_gi(mapgi_r[44 ]),.i045_gi(mapgi_r[45 ]),.i046_gi(mapgi_r[46 ]),.i047_gi(mapgi_r[47 ]),.i048_gi(mapgi_r[48 ]),.i049_gi(mapgi_r[49 ]),
.i050_gi(mapgi_r[50 ]),.i051_gi(mapgi_r[51 ]),.i052_gi(mapgi_r[52 ]),.i053_gi(mapgi_r[53 ]),.i054_gi(mapgi_r[54 ]),.i055_gi(mapgi_r[55 ]),.i056_gi(mapgi_r[56 ]),.i057_gi(mapgi_r[57 ]),.i058_gi(mapgi_r[58 ]),.i059_gi(mapgi_r[59 ]),
.i060_gi(mapgi_r[60 ]),.i061_gi(mapgi_r[61 ]),.i062_gi(mapgi_r[62 ]),.i063_gi(mapgi_r[63 ]),.i064_gi(mapgi_r[64 ]),.i065_gi(mapgi_r[65 ]),.i066_gi(mapgi_r[66 ]),.i067_gi(mapgi_r[67 ]),.i068_gi(mapgi_r[68 ]),.i069_gi(mapgi_r[69 ]),
.i070_gi(mapgi_r[70 ]),.i071_gi(mapgi_r[71 ]),.i072_gi(mapgi_r[72 ]),.i073_gi(mapgi_r[73 ]),.i074_gi(mapgi_r[74 ]),.i075_gi(mapgi_r[75 ]),.i076_gi(mapgi_r[76 ]),.i077_gi(mapgi_r[77 ]),.i078_gi(mapgi_r[78 ]),.i079_gi(mapgi_r[79 ]),
.i080_gi(mapgi_r[80 ]),.i081_gi(mapgi_r[81 ]),.i082_gi(mapgi_r[82 ]),.i083_gi(mapgi_r[83 ]),.i084_gi(mapgi_r[84 ]),.i085_gi(mapgi_r[85 ]),.i086_gi(mapgi_r[86 ]),.i087_gi(mapgi_r[87 ]),.i088_gi(mapgi_r[88 ]),.i089_gi(mapgi_r[89 ]),
.i090_gi(mapgi_r[90 ]),.i091_gi(mapgi_r[91 ]),.i092_gi(mapgi_r[92 ]),.i093_gi(mapgi_r[93 ]),.i094_gi(mapgi_r[94 ]),.i095_gi(mapgi_r[95 ]),.i096_gi(mapgi_r[96 ]),.i097_gi(mapgi_r[97 ]),.i098_gi(mapgi_r[98 ]),.i099_gi(mapgi_r[99 ]),
.i100_gi(mapgi_r[100]),.i101_gi(mapgi_r[101]),.i102_gi(mapgi_r[102]),.i103_gi(mapgi_r[103]),.i104_gi(mapgi_r[104]),.i105_gi(mapgi_r[105]),.i106_gi(mapgi_r[106]),.i107_gi(mapgi_r[107]),.i108_gi(mapgi_r[108]),.i109_gi(mapgi_r[109]),
.i110_gi(mapgi_r[110]),.i111_gi(mapgi_r[111]),.i112_gi(mapgi_r[112]),.i113_gi(mapgi_r[113]),.i114_gi(mapgi_r[114]),.i115_gi(mapgi_r[115]),.i116_gi(mapgi_r[116]),.i117_gi(mapgi_r[117]),.i118_gi(mapgi_r[118]),.i119_gi(mapgi_r[119]),.i120_gi(mapgi_r[120]),
.i000_h(maph_r[0  ]),.i001_h(maph_r[1  ]),.i002_h(maph_r[2  ]),.i003_h(maph_r[3  ]),.i004_h(maph_r[4  ]),.i005_h(maph_r[5  ]),.i006_h(maph_r[6  ]),.i007_h(maph_r[7  ]),.i008_h(maph_r[8  ]),.i009_h(maph_r[9  ]),
.i010_h(maph_r[10 ]),.i011_h(maph_r[11 ]),.i012_h(maph_r[12 ]),.i013_h(maph_r[13 ]),.i014_h(maph_r[14 ]),.i015_h(maph_r[15 ]),.i016_h(maph_r[16 ]),.i017_h(maph_r[17 ]),.i018_h(maph_r[18 ]),.i019_h(maph_r[19 ]),
.i020_h(maph_r[20 ]),.i021_h(maph_r[21 ]),.i022_h(maph_r[22 ]),.i023_h(maph_r[23 ]),.i024_h(maph_r[24 ]),.i025_h(maph_r[25 ]),.i026_h(maph_r[26 ]),.i027_h(maph_r[27 ]),.i028_h(maph_r[28 ]),.i029_h(maph_r[29 ]),
.i030_h(maph_r[30 ]),.i031_h(maph_r[31 ]),.i032_h(maph_r[32 ]),.i033_h(maph_r[33 ]),.i034_h(maph_r[34 ]),.i035_h(maph_r[35 ]),.i036_h(maph_r[36 ]),.i037_h(maph_r[37 ]),.i038_h(maph_r[38 ]),.i039_h(maph_r[39 ]),
.i040_h(maph_r[40 ]),.i041_h(maph_r[41 ]),.i042_h(maph_r[42 ]),.i043_h(maph_r[43 ]),.i044_h(maph_r[44 ]),.i045_h(maph_r[45 ]),.i046_h(maph_r[46 ]),.i047_h(maph_r[47 ]),.i048_h(maph_r[48 ]),.i049_h(maph_r[49 ]),
.i050_h(maph_r[50 ]),.i051_h(maph_r[51 ]),.i052_h(maph_r[52 ]),.i053_h(maph_r[53 ]),.i054_h(maph_r[54 ]),.i055_h(maph_r[55 ]),.i056_h(maph_r[56 ]),.i057_h(maph_r[57 ]),.i058_h(maph_r[58 ]),.i059_h(maph_r[59 ]),
.i060_h(maph_r[60 ]),.i061_h(maph_r[61 ]),.i062_h(maph_r[62 ]),.i063_h(maph_r[63 ]),.i064_h(maph_r[64 ]),.i065_h(maph_r[65 ]),.i066_h(maph_r[66 ]),.i067_h(maph_r[67 ]),.i068_h(maph_r[68 ]),.i069_h(maph_r[69 ]),
.i070_h(maph_r[70 ]),.i071_h(maph_r[71 ]),.i072_h(maph_r[72 ]),.i073_h(maph_r[73 ]),.i074_h(maph_r[74 ]),.i075_h(maph_r[75 ]),.i076_h(maph_r[76 ]),.i077_h(maph_r[77 ]),.i078_h(maph_r[78 ]),.i079_h(maph_r[79 ]),
.i080_h(maph_r[80 ]),.i081_h(maph_r[81 ]),.i082_h(maph_r[82 ]),.i083_h(maph_r[83 ]),.i084_h(maph_r[84 ]),.i085_h(maph_r[85 ]),.i086_h(maph_r[86 ]),.i087_h(maph_r[87 ]),.i088_h(maph_r[88 ]),.i089_h(maph_r[89 ]),
.i090_h(maph_r[90 ]),.i091_h(maph_r[91 ]),.i092_h(maph_r[92 ]),.i093_h(maph_r[93 ]),.i094_h(maph_r[94 ]),.i095_h(maph_r[95 ]),.i096_h(maph_r[96 ]),.i097_h(maph_r[97 ]),.i098_h(maph_r[98 ]),.i099_h(maph_r[99 ]),
.i100_h(maph_r[100]),.i101_h(maph_r[101]),.i102_h(maph_r[102]),.i103_h(maph_r[103]),.i104_h(maph_r[104]),.i105_h(maph_r[105]),.i106_h(maph_r[106]),.i107_h(maph_r[107]),.i108_h(maph_r[108]),.i109_h(maph_r[109]),
.i110_h(maph_r[110]),.i111_h(maph_r[111]),.i112_h(maph_r[112]),.i113_h(maph_r[113]),.i114_h(maph_r[114]),.i115_h(maph_r[115]),.i116_h(maph_r[116]),.i117_h(maph_r[117]),.i118_h(maph_r[118]),.i119_h(maph_r[119]),.i120_h(maph_r[120]),
.reg000(mapghi_r[0  ]),.reg001(mapghi_r[1  ]),.reg002(mapghi_r[2  ]),.reg003(mapghi_r[3  ]),.reg004(mapghi_r[4  ]),.reg005(mapghi_r[5  ]),.reg006(mapghi_r[6  ]),.reg007(mapghi_r[7  ]),.reg008(mapghi_r[8  ]),.reg009(mapghi_r[9  ]),
.reg010(mapghi_r[10 ]),.reg011(mapghi_r[11 ]),.reg012(mapghi_r[12 ]),.reg013(mapghi_r[13 ]),.reg014(mapghi_r[14 ]),.reg015(mapghi_r[15 ]),.reg016(mapghi_r[16 ]),.reg017(mapghi_r[17 ]),.reg018(mapghi_r[18 ]),.reg019(mapghi_r[19 ]),
.reg020(mapghi_r[20 ]),.reg021(mapghi_r[21 ]),.reg022(mapghi_r[22 ]),.reg023(mapghi_r[23 ]),.reg024(mapghi_r[24 ]),.reg025(mapghi_r[25 ]),.reg026(mapghi_r[26 ]),.reg027(mapghi_r[27 ]),.reg028(mapghi_r[28 ]),.reg029(mapghi_r[29 ]),
.reg030(mapghi_r[30 ]),.reg031(mapghi_r[31 ]),.reg032(mapghi_r[32 ]),.reg033(mapghi_r[33 ]),.reg034(mapghi_r[34 ]),.reg035(mapghi_r[35 ]),.reg036(mapghi_r[36 ]),.reg037(mapghi_r[37 ]),.reg038(mapghi_r[38 ]),.reg039(mapghi_r[39 ]),
.reg040(mapghi_r[40 ]),.reg041(mapghi_r[41 ]),.reg042(mapghi_r[42 ]),.reg043(mapghi_r[43 ]),.reg044(mapghi_r[44 ]),.reg045(mapghi_r[45 ]),.reg046(mapghi_r[46 ]),.reg047(mapghi_r[47 ]),.reg048(mapghi_r[48 ]),.reg049(mapghi_r[49 ]),
.reg050(mapghi_r[50 ]),.reg051(mapghi_r[51 ]),.reg052(mapghi_r[52 ]),.reg053(mapghi_r[53 ]),.reg054(mapghi_r[54 ]),.reg055(mapghi_r[55 ]),.reg056(mapghi_r[56 ]),.reg057(mapghi_r[57 ]),.reg058(mapghi_r[58 ]),.reg059(mapghi_r[59 ]),
.reg060(mapghi_r[60 ]),.reg061(mapghi_r[61 ]),.reg062(mapghi_r[62 ]),.reg063(mapghi_r[63 ]),.reg064(mapghi_r[64 ]),.reg065(mapghi_r[65 ]),.reg066(mapghi_r[66 ]),.reg067(mapghi_r[67 ]),.reg068(mapghi_r[68 ]),.reg069(mapghi_r[69 ]),
.reg070(mapghi_r[70 ]),.reg071(mapghi_r[71 ]),.reg072(mapghi_r[72 ]),.reg073(mapghi_r[73 ]),.reg074(mapghi_r[74 ]),.reg075(mapghi_r[75 ]),.reg076(mapghi_r[76 ]),.reg077(mapghi_r[77 ]),.reg078(mapghi_r[78 ]),.reg079(mapghi_r[79 ]),
.reg080(mapghi_r[80 ]),.reg081(mapghi_r[81 ]),.reg082(mapghi_r[82 ]),.reg083(mapghi_r[83 ]),.reg084(mapghi_r[84 ]),.reg085(mapghi_r[85 ]),.reg086(mapghi_r[86 ]),.reg087(mapghi_r[87 ]),.reg088(mapghi_r[88 ]),.reg089(mapghi_r[89 ]),
.reg090(mapghi_r[90 ]),.reg091(mapghi_r[91 ]),.reg092(mapghi_r[92 ]),.reg093(mapghi_r[93 ]),.reg094(mapghi_r[94 ]),.reg095(mapghi_r[95 ]),.reg096(mapghi_r[96 ]),.reg097(mapghi_r[97 ]),.reg098(mapghi_r[98 ]),.reg099(mapghi_r[99 ]),
.reg100(mapghi_r[100]),.reg101(mapghi_r[101]),.reg102(mapghi_r[102]),.reg103(mapghi_r[103]),.reg104(mapghi_r[104]),.reg105(mapghi_r[105]),.reg106(mapghi_r[106]),.reg107(mapghi_r[107]),.reg108(mapghi_r[108]),.reg109(mapghi_r[109]),
.reg110(mapghi_r[110]),.reg111(mapghi_r[111]),.reg112(mapghi_r[112]),.reg113(mapghi_r[113]),.reg114(mapghi_r[114]),.reg115(mapghi_r[115]),.reg116(mapghi_r[116]),.reg117(mapghi_r[117]),.reg118(mapghi_r[118]),.reg119(mapghi_r[119]),.reg120(mapghi_r[120]),
.out000(mapghi_w[0  ]),.out001(mapghi_w[1  ]),.out002(mapghi_w[2  ]),.out003(mapghi_w[3  ]),.out004(mapghi_w[4  ]),.out005(mapghi_w[5  ]),.out006(mapghi_w[6  ]),.out007(mapghi_w[7  ]),.out008(mapghi_w[8  ]),.out009(mapghi_w[9  ]),
.out010(mapghi_w[10 ]),.out011(mapghi_w[11 ]),.out012(mapghi_w[12 ]),.out013(mapghi_w[13 ]),.out014(mapghi_w[14 ]),.out015(mapghi_w[15 ]),.out016(mapghi_w[16 ]),.out017(mapghi_w[17 ]),.out018(mapghi_w[18 ]),.out019(mapghi_w[19 ]),
.out020(mapghi_w[20 ]),.out021(mapghi_w[21 ]),.out022(mapghi_w[22 ]),.out023(mapghi_w[23 ]),.out024(mapghi_w[24 ]),.out025(mapghi_w[25 ]),.out026(mapghi_w[26 ]),.out027(mapghi_w[27 ]),.out028(mapghi_w[28 ]),.out029(mapghi_w[29 ]),
.out030(mapghi_w[30 ]),.out031(mapghi_w[31 ]),.out032(mapghi_w[32 ]),.out033(mapghi_w[33 ]),.out034(mapghi_w[34 ]),.out035(mapghi_w[35 ]),.out036(mapghi_w[36 ]),.out037(mapghi_w[37 ]),.out038(mapghi_w[38 ]),.out039(mapghi_w[39 ]),
.out040(mapghi_w[40 ]),.out041(mapghi_w[41 ]),.out042(mapghi_w[42 ]),.out043(mapghi_w[43 ]),.out044(mapghi_w[44 ]),.out045(mapghi_w[45 ]),.out046(mapghi_w[46 ]),.out047(mapghi_w[47 ]),.out048(mapghi_w[48 ]),.out049(mapghi_w[49 ]),
.out050(mapghi_w[50 ]),.out051(mapghi_w[51 ]),.out052(mapghi_w[52 ]),.out053(mapghi_w[53 ]),.out054(mapghi_w[54 ]),.out055(mapghi_w[55 ]),.out056(mapghi_w[56 ]),.out057(mapghi_w[57 ]),.out058(mapghi_w[58 ]),.out059(mapghi_w[59 ]),
.out060(mapghi_w[60 ]),.out061(mapghi_w[61 ]),.out062(mapghi_w[62 ]),.out063(mapghi_w[63 ]),.out064(mapghi_w[64 ]),.out065(mapghi_w[65 ]),.out066(mapghi_w[66 ]),.out067(mapghi_w[67 ]),.out068(mapghi_w[68 ]),.out069(mapghi_w[69 ]),
.out070(mapghi_w[70 ]),.out071(mapghi_w[71 ]),.out072(mapghi_w[72 ]),.out073(mapghi_w[73 ]),.out074(mapghi_w[74 ]),.out075(mapghi_w[75 ]),.out076(mapghi_w[76 ]),.out077(mapghi_w[77 ]),.out078(mapghi_w[78 ]),.out079(mapghi_w[79 ]),
.out080(mapghi_w[80 ]),.out081(mapghi_w[81 ]),.out082(mapghi_w[82 ]),.out083(mapghi_w[83 ]),.out084(mapghi_w[84 ]),.out085(mapghi_w[85 ]),.out086(mapghi_w[86 ]),.out087(mapghi_w[87 ]),.out088(mapghi_w[88 ]),.out089(mapghi_w[89 ]),
.out090(mapghi_w[90 ]),.out091(mapghi_w[91 ]),.out092(mapghi_w[92 ]),.out093(mapghi_w[93 ]),.out094(mapghi_w[94 ]),.out095(mapghi_w[95 ]),.out096(mapghi_w[96 ]),.out097(mapghi_w[97 ]),.out098(mapghi_w[98 ]),.out099(mapghi_w[99 ]),
.out100(mapghi_w[100]),.out101(mapghi_w[101]),.out102(mapghi_w[102]),.out103(mapghi_w[103]),.out104(mapghi_w[104]),.out105(mapghi_w[105]),.out106(mapghi_w[106]),.out107(mapghi_w[107]),.out108(mapghi_w[108]),.out109(mapghi_w[109]),
.out110(mapghi_w[110]),.out111(mapghi_w[111]),.out112(mapghi_w[112]),.out113(mapghi_w[113]),.out114(mapghi_w[114]),.out115(mapghi_w[115]),.out116(mapghi_w[116]),.out117(mapghi_w[117]),.out118(mapghi_w[118]),.out119(mapghi_w[119]),.out120(mapghi_w[120])
);

mul_hi h2hi(.en(en_maphi_r),
.i000_h(maph_r[0  ]),.i001_h(maph_r[1  ]),.i002_h(maph_r[2  ]),.i003_h(maph_r[3  ]),.i004_h(maph_r[4  ]),.i005_h(maph_r[5  ]),.i006_h(maph_r[6  ]),.i007_h(maph_r[7  ]),.i008_h(maph_r[8  ]),.i009_h(maph_r[9  ]),
.i010_h(maph_r[10 ]),.i011_h(maph_r[11 ]),.i012_h(maph_r[12 ]),.i013_h(maph_r[13 ]),.i014_h(maph_r[14 ]),.i015_h(maph_r[15 ]),.i016_h(maph_r[16 ]),.i017_h(maph_r[17 ]),.i018_h(maph_r[18 ]),.i019_h(maph_r[19 ]),
.i020_h(maph_r[20 ]),.i021_h(maph_r[21 ]),.i022_h(maph_r[22 ]),.i023_h(maph_r[23 ]),.i024_h(maph_r[24 ]),.i025_h(maph_r[25 ]),.i026_h(maph_r[26 ]),.i027_h(maph_r[27 ]),.i028_h(maph_r[28 ]),.i029_h(maph_r[29 ]),
.i030_h(maph_r[30 ]),.i031_h(maph_r[31 ]),.i032_h(maph_r[32 ]),.i033_h(maph_r[33 ]),.i034_h(maph_r[34 ]),.i035_h(maph_r[35 ]),.i036_h(maph_r[36 ]),.i037_h(maph_r[37 ]),.i038_h(maph_r[38 ]),.i039_h(maph_r[39 ]),
.i040_h(maph_r[40 ]),.i041_h(maph_r[41 ]),.i042_h(maph_r[42 ]),.i043_h(maph_r[43 ]),.i044_h(maph_r[44 ]),.i045_h(maph_r[45 ]),.i046_h(maph_r[46 ]),.i047_h(maph_r[47 ]),.i048_h(maph_r[48 ]),.i049_h(maph_r[49 ]),
.i050_h(maph_r[50 ]),.i051_h(maph_r[51 ]),.i052_h(maph_r[52 ]),.i053_h(maph_r[53 ]),.i054_h(maph_r[54 ]),.i055_h(maph_r[55 ]),.i056_h(maph_r[56 ]),.i057_h(maph_r[57 ]),.i058_h(maph_r[58 ]),.i059_h(maph_r[59 ]),
.i060_h(maph_r[60 ]),.i061_h(maph_r[61 ]),.i062_h(maph_r[62 ]),.i063_h(maph_r[63 ]),.i064_h(maph_r[64 ]),.i065_h(maph_r[65 ]),.i066_h(maph_r[66 ]),.i067_h(maph_r[67 ]),.i068_h(maph_r[68 ]),.i069_h(maph_r[69 ]),
.i070_h(maph_r[70 ]),.i071_h(maph_r[71 ]),.i072_h(maph_r[72 ]),.i073_h(maph_r[73 ]),.i074_h(maph_r[74 ]),.i075_h(maph_r[75 ]),.i076_h(maph_r[76 ]),.i077_h(maph_r[77 ]),.i078_h(maph_r[78 ]),.i079_h(maph_r[79 ]),
.i080_h(maph_r[80 ]),.i081_h(maph_r[81 ]),.i082_h(maph_r[82 ]),.i083_h(maph_r[83 ]),.i084_h(maph_r[84 ]),.i085_h(maph_r[85 ]),.i086_h(maph_r[86 ]),.i087_h(maph_r[87 ]),.i088_h(maph_r[88 ]),.i089_h(maph_r[89 ]),
.i090_h(maph_r[90 ]),.i091_h(maph_r[91 ]),.i092_h(maph_r[92 ]),.i093_h(maph_r[93 ]),.i094_h(maph_r[94 ]),.i095_h(maph_r[95 ]),.i096_h(maph_r[96 ]),.i097_h(maph_r[97 ]),.i098_h(maph_r[98 ]),.i099_h(maph_r[99 ]),
.i100_h(maph_r[100]),.i101_h(maph_r[101]),.i102_h(maph_r[102]),.i103_h(maph_r[103]),.i104_h(maph_r[104]),.i105_h(maph_r[105]),.i106_h(maph_r[106]),.i107_h(maph_r[107]),.i108_h(maph_r[108]),.i109_h(maph_r[109]),
.i110_h(maph_r[110]),.i111_h(maph_r[111]),.i112_h(maph_r[112]),.i113_h(maph_r[113]),.i114_h(maph_r[114]),.i115_h(maph_r[115]),.i116_h(maph_r[116]),.i117_h(maph_r[117]),.i118_h(maph_r[118]),.i119_h(maph_r[119]),.i120_h(maph_r[120]),
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
.reg000(maphi_r[0  ]),.reg001(maphi_r[1  ]),.reg002(maphi_r[2  ]),.reg003(maphi_r[3  ]),.reg004(maphi_r[4  ]),.reg005(maphi_r[5  ]),.reg006(maphi_r[6  ]),.reg007(maphi_r[7  ]),.reg008(maphi_r[8  ]),.reg009(maphi_r[9  ]),
.reg010(maphi_r[10 ]),.reg011(maphi_r[11 ]),.reg012(maphi_r[12 ]),.reg013(maphi_r[13 ]),.reg014(maphi_r[14 ]),.reg015(maphi_r[15 ]),.reg016(maphi_r[16 ]),.reg017(maphi_r[17 ]),.reg018(maphi_r[18 ]),.reg019(maphi_r[19 ]),
.reg020(maphi_r[20 ]),.reg021(maphi_r[21 ]),.reg022(maphi_r[22 ]),.reg023(maphi_r[23 ]),.reg024(maphi_r[24 ]),.reg025(maphi_r[25 ]),.reg026(maphi_r[26 ]),.reg027(maphi_r[27 ]),.reg028(maphi_r[28 ]),.reg029(maphi_r[29 ]),
.reg030(maphi_r[30 ]),.reg031(maphi_r[31 ]),.reg032(maphi_r[32 ]),.reg033(maphi_r[33 ]),.reg034(maphi_r[34 ]),.reg035(maphi_r[35 ]),.reg036(maphi_r[36 ]),.reg037(maphi_r[37 ]),.reg038(maphi_r[38 ]),.reg039(maphi_r[39 ]),
.reg040(maphi_r[40 ]),.reg041(maphi_r[41 ]),.reg042(maphi_r[42 ]),.reg043(maphi_r[43 ]),.reg044(maphi_r[44 ]),.reg045(maphi_r[45 ]),.reg046(maphi_r[46 ]),.reg047(maphi_r[47 ]),.reg048(maphi_r[48 ]),.reg049(maphi_r[49 ]),
.reg050(maphi_r[50 ]),.reg051(maphi_r[51 ]),.reg052(maphi_r[52 ]),.reg053(maphi_r[53 ]),.reg054(maphi_r[54 ]),.reg055(maphi_r[55 ]),.reg056(maphi_r[56 ]),.reg057(maphi_r[57 ]),.reg058(maphi_r[58 ]),.reg059(maphi_r[59 ]),
.reg060(maphi_r[60 ]),.reg061(maphi_r[61 ]),.reg062(maphi_r[62 ]),.reg063(maphi_r[63 ]),.reg064(maphi_r[64 ]),.reg065(maphi_r[65 ]),.reg066(maphi_r[66 ]),.reg067(maphi_r[67 ]),.reg068(maphi_r[68 ]),.reg069(maphi_r[69 ]),
.reg070(maphi_r[70 ]),.reg071(maphi_r[71 ]),.reg072(maphi_r[72 ]),.reg073(maphi_r[73 ]),.reg074(maphi_r[74 ]),.reg075(maphi_r[75 ]),.reg076(maphi_r[76 ]),.reg077(maphi_r[77 ]),.reg078(maphi_r[78 ]),.reg079(maphi_r[79 ]),
.reg080(maphi_r[80 ]),.reg081(maphi_r[81 ]),.reg082(maphi_r[82 ]),.reg083(maphi_r[83 ]),.reg084(maphi_r[84 ]),.reg085(maphi_r[85 ]),.reg086(maphi_r[86 ]),.reg087(maphi_r[87 ]),.reg088(maphi_r[88 ]),.reg089(maphi_r[89 ]),
.reg090(maphi_r[90 ]),.reg091(maphi_r[91 ]),.reg092(maphi_r[92 ]),.reg093(maphi_r[93 ]),.reg094(maphi_r[94 ]),.reg095(maphi_r[95 ]),.reg096(maphi_r[96 ]),.reg097(maphi_r[97 ]),.reg098(maphi_r[98 ]),.reg099(maphi_r[99 ]),
.reg100(maphi_r[100]),.reg101(maphi_r[101]),.reg102(maphi_r[102]),.reg103(maphi_r[103]),.reg104(maphi_r[104]),.reg105(maphi_r[105]),.reg106(maphi_r[106]),.reg107(maphi_r[107]),.reg108(maphi_r[108]),.reg109(maphi_r[109]),
.reg110(maphi_r[110]),.reg111(maphi_r[111]),.reg112(maphi_r[112]),.reg113(maphi_r[113]),.reg114(maphi_r[114]),.reg115(maphi_r[115]),.reg116(maphi_r[116]),.reg117(maphi_r[117]),.reg118(maphi_r[118]),.reg119(maphi_r[119]),.reg120(maphi_r[120]),
.out000(maphi_w[0  ]),.out001(maphi_w[1  ]),.out002(maphi_w[2  ]),.out003(maphi_w[3  ]),.out004(maphi_w[4  ]),.out005(maphi_w[5  ]),.out006(maphi_w[6  ]),.out007(maphi_w[7  ]),.out008(maphi_w[8  ]),.out009(maphi_w[9  ]),
.out010(maphi_w[10 ]),.out011(maphi_w[11 ]),.out012(maphi_w[12 ]),.out013(maphi_w[13 ]),.out014(maphi_w[14 ]),.out015(maphi_w[15 ]),.out016(maphi_w[16 ]),.out017(maphi_w[17 ]),.out018(maphi_w[18 ]),.out019(maphi_w[19 ]),
.out020(maphi_w[20 ]),.out021(maphi_w[21 ]),.out022(maphi_w[22 ]),.out023(maphi_w[23 ]),.out024(maphi_w[24 ]),.out025(maphi_w[25 ]),.out026(maphi_w[26 ]),.out027(maphi_w[27 ]),.out028(maphi_w[28 ]),.out029(maphi_w[29 ]),
.out030(maphi_w[30 ]),.out031(maphi_w[31 ]),.out032(maphi_w[32 ]),.out033(maphi_w[33 ]),.out034(maphi_w[34 ]),.out035(maphi_w[35 ]),.out036(maphi_w[36 ]),.out037(maphi_w[37 ]),.out038(maphi_w[38 ]),.out039(maphi_w[39 ]),
.out040(maphi_w[40 ]),.out041(maphi_w[41 ]),.out042(maphi_w[42 ]),.out043(maphi_w[43 ]),.out044(maphi_w[44 ]),.out045(maphi_w[45 ]),.out046(maphi_w[46 ]),.out047(maphi_w[47 ]),.out048(maphi_w[48 ]),.out049(maphi_w[49 ]),
.out050(maphi_w[50 ]),.out051(maphi_w[51 ]),.out052(maphi_w[52 ]),.out053(maphi_w[53 ]),.out054(maphi_w[54 ]),.out055(maphi_w[55 ]),.out056(maphi_w[56 ]),.out057(maphi_w[57 ]),.out058(maphi_w[58 ]),.out059(maphi_w[59 ]),
.out060(maphi_w[60 ]),.out061(maphi_w[61 ]),.out062(maphi_w[62 ]),.out063(maphi_w[63 ]),.out064(maphi_w[64 ]),.out065(maphi_w[65 ]),.out066(maphi_w[66 ]),.out067(maphi_w[67 ]),.out068(maphi_w[68 ]),.out069(maphi_w[69 ]),
.out070(maphi_w[70 ]),.out071(maphi_w[71 ]),.out072(maphi_w[72 ]),.out073(maphi_w[73 ]),.out074(maphi_w[74 ]),.out075(maphi_w[75 ]),.out076(maphi_w[76 ]),.out077(maphi_w[77 ]),.out078(maphi_w[78 ]),.out079(maphi_w[79 ]),
.out080(maphi_w[80 ]),.out081(maphi_w[81 ]),.out082(maphi_w[82 ]),.out083(maphi_w[83 ]),.out084(maphi_w[84 ]),.out085(maphi_w[85 ]),.out086(maphi_w[86 ]),.out087(maphi_w[87 ]),.out088(maphi_w[88 ]),.out089(maphi_w[89 ]),
.out090(maphi_w[90 ]),.out091(maphi_w[91 ]),.out092(maphi_w[92 ]),.out093(maphi_w[93 ]),.out094(maphi_w[94 ]),.out095(maphi_w[95 ]),.out096(maphi_w[96 ]),.out097(maphi_w[97 ]),.out098(maphi_w[98 ]),.out099(maphi_w[99 ]),
.out100(maphi_w[100]),.out101(maphi_w[101]),.out102(maphi_w[102]),.out103(maphi_w[103]),.out104(maphi_w[104]),.out105(maphi_w[105]),.out106(maphi_w[106]),.out107(maphi_w[107]),.out108(maphi_w[108]),.out109(maphi_w[109]),
.out110(maphi_w[110]),.out111(maphi_w[111]),.out112(maphi_w[112]),.out113(maphi_w[113]),.out114(maphi_w[114]),.out115(maphi_w[115]),.out116(maphi_w[116]),.out117(maphi_w[117]),.out118(maphi_w[118]),.out119(maphi_w[119]),.out120(maphi_w[120])
);

sum_ghi ghi2sum(.en(en_sum_ghi_r),.reg_sum(sum_ghi_r),.out_sum(sum_ghi_w),
.ghi000(mapghi_r[0  ]),.ghi001(mapghi_r[1  ]),.ghi002(mapghi_r[2  ]),.ghi003(mapghi_r[3  ]),.ghi004(mapghi_r[4  ]),.ghi005(mapghi_r[5  ]),.ghi006(mapghi_r[6  ]),.ghi007(mapghi_r[7  ]),.ghi008(mapghi_r[8  ]),.ghi009(mapghi_r[9  ]),
.ghi010(mapghi_r[10 ]),.ghi011(mapghi_r[11 ]),.ghi012(mapghi_r[12 ]),.ghi013(mapghi_r[13 ]),.ghi014(mapghi_r[14 ]),.ghi015(mapghi_r[15 ]),.ghi016(mapghi_r[16 ]),.ghi017(mapghi_r[17 ]),.ghi018(mapghi_r[18 ]),.ghi019(mapghi_r[19 ]),
.ghi020(mapghi_r[20 ]),.ghi021(mapghi_r[21 ]),.ghi022(mapghi_r[22 ]),.ghi023(mapghi_r[23 ]),.ghi024(mapghi_r[24 ]),.ghi025(mapghi_r[25 ]),.ghi026(mapghi_r[26 ]),.ghi027(mapghi_r[27 ]),.ghi028(mapghi_r[28 ]),.ghi029(mapghi_r[29 ]),
.ghi030(mapghi_r[30 ]),.ghi031(mapghi_r[31 ]),.ghi032(mapghi_r[32 ]),.ghi033(mapghi_r[33 ]),.ghi034(mapghi_r[34 ]),.ghi035(mapghi_r[35 ]),.ghi036(mapghi_r[36 ]),.ghi037(mapghi_r[37 ]),.ghi038(mapghi_r[38 ]),.ghi039(mapghi_r[39 ]),
.ghi040(mapghi_r[40 ]),.ghi041(mapghi_r[41 ]),.ghi042(mapghi_r[42 ]),.ghi043(mapghi_r[43 ]),.ghi044(mapghi_r[44 ]),.ghi045(mapghi_r[45 ]),.ghi046(mapghi_r[46 ]),.ghi047(mapghi_r[47 ]),.ghi048(mapghi_r[48 ]),.ghi049(mapghi_r[49 ]),
.ghi050(mapghi_r[50 ]),.ghi051(mapghi_r[51 ]),.ghi052(mapghi_r[52 ]),.ghi053(mapghi_r[53 ]),.ghi054(mapghi_r[54 ]),.ghi055(mapghi_r[55 ]),.ghi056(mapghi_r[56 ]),.ghi057(mapghi_r[57 ]),.ghi058(mapghi_r[58 ]),.ghi059(mapghi_r[59 ]),
.ghi060(mapghi_r[60 ]),.ghi061(mapghi_r[61 ]),.ghi062(mapghi_r[62 ]),.ghi063(mapghi_r[63 ]),.ghi064(mapghi_r[64 ]),.ghi065(mapghi_r[65 ]),.ghi066(mapghi_r[66 ]),.ghi067(mapghi_r[67 ]),.ghi068(mapghi_r[68 ]),.ghi069(mapghi_r[69 ]),
.ghi070(mapghi_r[70 ]),.ghi071(mapghi_r[71 ]),.ghi072(mapghi_r[72 ]),.ghi073(mapghi_r[73 ]),.ghi074(mapghi_r[74 ]),.ghi075(mapghi_r[75 ]),.ghi076(mapghi_r[76 ]),.ghi077(mapghi_r[77 ]),.ghi078(mapghi_r[78 ]),.ghi079(mapghi_r[79 ]),
.ghi080(mapghi_r[80 ]),.ghi081(mapghi_r[81 ]),.ghi082(mapghi_r[82 ]),.ghi083(mapghi_r[83 ]),.ghi084(mapghi_r[84 ]),.ghi085(mapghi_r[85 ]),.ghi086(mapghi_r[86 ]),.ghi087(mapghi_r[87 ]),.ghi088(mapghi_r[88 ]),.ghi089(mapghi_r[89 ]),
.ghi090(mapghi_r[90 ]),.ghi091(mapghi_r[91 ]),.ghi092(mapghi_r[92 ]),.ghi093(mapghi_r[93 ]),.ghi094(mapghi_r[94 ]),.ghi095(mapghi_r[95 ]),.ghi096(mapghi_r[96 ]),.ghi097(mapghi_r[97 ]),.ghi098(mapghi_r[98 ]),.ghi099(mapghi_r[99 ]),
.ghi100(mapghi_r[100]),.ghi101(mapghi_r[101]),.ghi102(mapghi_r[102]),.ghi103(mapghi_r[103]),.ghi104(mapghi_r[104]),.ghi105(mapghi_r[105]),.ghi106(mapghi_r[106]),.ghi107(mapghi_r[107]),.ghi108(mapghi_r[108]),.ghi109(mapghi_r[109]),
.ghi110(mapghi_r[110]),.ghi111(mapghi_r[111]),.ghi112(mapghi_r[112]),.ghi113(mapghi_r[113]),.ghi114(mapghi_r[114]),.ghi115(mapghi_r[115]),.ghi116(mapghi_r[116]),.ghi117(mapghi_r[117]),.ghi118(mapghi_r[118]),.ghi119(mapghi_r[119]),.ghi120(mapghi_r[120])
);

sum_hi hi2sum(.en(en_sum_hi_r),.reg_sum(sum_hi_r),.out_sum(sum_hi_w),
.hi000(maphi_r[0  ]),.hi001(maphi_r[1  ]),.hi002(maphi_r[2  ]),.hi003(maphi_r[3  ]),.hi004(maphi_r[4  ]),.hi005(maphi_r[5  ]),.hi006(maphi_r[6  ]),.hi007(maphi_r[7  ]),.hi008(maphi_r[8  ]),.hi009(maphi_r[9  ]),
.hi010(maphi_r[10 ]),.hi011(maphi_r[11 ]),.hi012(maphi_r[12 ]),.hi013(maphi_r[13 ]),.hi014(maphi_r[14 ]),.hi015(maphi_r[15 ]),.hi016(maphi_r[16 ]),.hi017(maphi_r[17 ]),.hi018(maphi_r[18 ]),.hi019(maphi_r[19 ]),
.hi020(maphi_r[20 ]),.hi021(maphi_r[21 ]),.hi022(maphi_r[22 ]),.hi023(maphi_r[23 ]),.hi024(maphi_r[24 ]),.hi025(maphi_r[25 ]),.hi026(maphi_r[26 ]),.hi027(maphi_r[27 ]),.hi028(maphi_r[28 ]),.hi029(maphi_r[29 ]),
.hi030(maphi_r[30 ]),.hi031(maphi_r[31 ]),.hi032(maphi_r[32 ]),.hi033(maphi_r[33 ]),.hi034(maphi_r[34 ]),.hi035(maphi_r[35 ]),.hi036(maphi_r[36 ]),.hi037(maphi_r[37 ]),.hi038(maphi_r[38 ]),.hi039(maphi_r[39 ]),
.hi040(maphi_r[40 ]),.hi041(maphi_r[41 ]),.hi042(maphi_r[42 ]),.hi043(maphi_r[43 ]),.hi044(maphi_r[44 ]),.hi045(maphi_r[45 ]),.hi046(maphi_r[46 ]),.hi047(maphi_r[47 ]),.hi048(maphi_r[48 ]),.hi049(maphi_r[49 ]),
.hi050(maphi_r[50 ]),.hi051(maphi_r[51 ]),.hi052(maphi_r[52 ]),.hi053(maphi_r[53 ]),.hi054(maphi_r[54 ]),.hi055(maphi_r[55 ]),.hi056(maphi_r[56 ]),.hi057(maphi_r[57 ]),.hi058(maphi_r[58 ]),.hi059(maphi_r[59 ]),
.hi060(maphi_r[60 ]),.hi061(maphi_r[61 ]),.hi062(maphi_r[62 ]),.hi063(maphi_r[63 ]),.hi064(maphi_r[64 ]),.hi065(maphi_r[65 ]),.hi066(maphi_r[66 ]),.hi067(maphi_r[67 ]),.hi068(maphi_r[68 ]),.hi069(maphi_r[69 ]),
.hi070(maphi_r[70 ]),.hi071(maphi_r[71 ]),.hi072(maphi_r[72 ]),.hi073(maphi_r[73 ]),.hi074(maphi_r[74 ]),.hi075(maphi_r[75 ]),.hi076(maphi_r[76 ]),.hi077(maphi_r[77 ]),.hi078(maphi_r[78 ]),.hi079(maphi_r[79 ]),
.hi080(maphi_r[80 ]),.hi081(maphi_r[81 ]),.hi082(maphi_r[82 ]),.hi083(maphi_r[83 ]),.hi084(maphi_r[84 ]),.hi085(maphi_r[85 ]),.hi086(maphi_r[86 ]),.hi087(maphi_r[87 ]),.hi088(maphi_r[88 ]),.hi089(maphi_r[89 ]),
.hi090(maphi_r[90 ]),.hi091(maphi_r[91 ]),.hi092(maphi_r[92 ]),.hi093(maphi_r[93 ]),.hi094(maphi_r[94 ]),.hi095(maphi_r[95 ]),.hi096(maphi_r[96 ]),.hi097(maphi_r[97 ]),.hi098(maphi_r[98 ]),.hi099(maphi_r[99 ]),
.hi100(maphi_r[100]),.hi101(maphi_r[101]),.hi102(maphi_r[102]),.hi103(maphi_r[103]),.hi104(maphi_r[104]),.hi105(maphi_r[105]),.hi106(maphi_r[106]),.hi107(maphi_r[107]),.hi108(maphi_r[108]),.hi109(maphi_r[109]),
.hi110(maphi_r[110]),.hi111(maphi_r[111]),.hi112(maphi_r[112]),.hi113(maphi_r[113]),.hi114(maphi_r[114]),.hi115(maphi_r[115]),.hi116(maphi_r[116]),.hi117(maphi_r[117]),.hi118(maphi_r[118]),.hi119(maphi_r[119]),.hi120(maphi_r[120])
);


endmodule