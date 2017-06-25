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

reg         en_g_map_r;
reg         en_g_map_w;
reg         en_gi_map_r;
reg         en_gi_map_w;
reg         en_ghi_map_r;
reg         en_ghi_map_w;
reg         en_sum_ghi_r;
reg         en_sum_ghi_w;

reg  [13:0] g_map_r[0:120];
wire [14:0] g_map_w[0:120];
reg  [21:0] gi_map_r[0:120];
wire [21:0] gi_map_w[0:120];
reg  [27:0] ghi_map_r[0:120];
wire [28:0] ghi_map_w[0:120];
reg  [34:0] sum_ghi_r;
wire [34:0] sum_ghi_w;

reg         en_i_i0_map_r;
reg         en_i_i0_map_w;
reg         en_h_map_r;
reg         en_h_map_w;
reg         en_hi_map_r;
reg         en_hi_map_w;
reg         en_sum_hi_r;
reg         en_sum_hi_w;

reg  [7:0]  i_i0_map_r[0:120];
reg  [7:0]  i_i0_map_w[0:120];
reg  [6:0]  h_map_r[0:120];
wire [6:0]  h_map_w[0:120];
reg  [13:0] hi_map_r[0:120];
wire [14:0] hi_map_w[0:120];
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
    
    addr_mapi_w     = addr_mapi_r;
    col_cntr_w      = col_cntr_r;
    row_cntr_w      = row_cntr_r;
    px_row_cntr_w   = px_row_cntr_w;
    px_col_cntr_w   = px_col_cntr_w;
    
    en_g_map_w      = en_g_map_r;
    en_gi_map_w     = en_gi_map_r;

    out_valid_w     = out_valid;
    out_addr_w      = { px_row_cntr_r , px_col_cntr_r };
    out_data_w      = out_data;
    finish_w        = finish;
    
    for(i=0;i<121;i=i+1) begin
        mapi_w[i]    = mapi_r[i];
        i_i0_map_w[i] = i_i0_map_r[i];
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

        en_g_map_w      = 1;
        en_gi_map_w     = 1;
        en_ghi_map_w    = 1;
        en_sum_ghi_w    = 1;
        
        en_i_i0_map_w    = 1;
        en_h_map_w      = 1;
        en_hi_map_w     = 1;
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
        
        if(en_i_i0_map_r) begin
            for(i=0;i<121;i=i+1)begin
                i_i0_map_w[i] = (mapi_r[i]>mapi_r[60])?mapi_r[i] + (-mapi_r[60]) : (-mapi_r[i]) + mapi_r[60];
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
            // out_data_w = mapi_r[60];
            out_data_w = sum_ghi_r / sum_hi_r;
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
        
        en_g_map_r      <= 0;
        en_gi_map_r     <= 0;
        en_ghi_map_r    <= 0;
        en_sum_ghi_r    <= 0;
        
        en_i_i0_map_r   <= 0;
        en_h_map_r      <= 0;
        en_hi_map_r     <= 0;
        en_sum_hi_r     <= 0;

        sum_ghi_r       <= 0;
        sum_hi_r        <= 0;
        
        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= 0;
            g_map_r[i]    <= 0;
            gi_map_r[i]   <= 0;
            ghi_map_r[i]  <= 0;

            i_i0_map_r[i] <= 0;
            h_map_r[i]    <= 0;
            hi_map_r[i]   <= 0;
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
        
        en_g_map_r      <= en_g_map_w;
        en_gi_map_r     <= en_gi_map_w;
        en_ghi_map_r    <= en_ghi_map_w;
        en_sum_ghi_r    <= en_sum_ghi_w;
        
        en_i_i0_map_r   <= en_i_i0_map_w;
        en_h_map_r      <= en_h_map_w;
        en_hi_map_r     <= en_hi_map_w;
        en_sum_hi_r     <= en_sum_hi_w;

        sum_ghi_r       <= sum_ghi_w;
        sum_hi_r        <= sum_hi_w;

        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= mapi_w[i];
            g_map_r[i]    <= g_map_w[i][13:0];
            gi_map_r[i]   <= gi_map_w[i];
            ghi_map_r[i]  <= ghi_map_w[i][27:0];

            i_i0_map_r[i] <= i_i0_map_w[i];
            h_map_r[i]    <= h_map_w[i];
            hi_map_r[i]   <= hi_map_w[i][13:0];
        end
        for(i=0;i<11;i=i+1) begin
            in_buffer_r[i] <= in_buffer_w[i];
        end
    end
end

mul_g i2g(.en(en_g_map_r),
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
.reg000(g_map_r[0  ]),.reg001(g_map_r[1  ]),.reg002(g_map_r[2  ]),.reg003(g_map_r[3  ]),.reg004(g_map_r[4  ]),.reg005(g_map_r[5  ]),.reg006(g_map_r[6  ]),.reg007(g_map_r[7  ]),.reg008(g_map_r[8  ]),.reg009(g_map_r[9  ]),
.reg010(g_map_r[10 ]),.reg011(g_map_r[11 ]),.reg012(g_map_r[12 ]),.reg013(g_map_r[13 ]),.reg014(g_map_r[14 ]),.reg015(g_map_r[15 ]),.reg016(g_map_r[16 ]),.reg017(g_map_r[17 ]),.reg018(g_map_r[18 ]),.reg019(g_map_r[19 ]),
.reg020(g_map_r[20 ]),.reg021(g_map_r[21 ]),.reg022(g_map_r[22 ]),.reg023(g_map_r[23 ]),.reg024(g_map_r[24 ]),.reg025(g_map_r[25 ]),.reg026(g_map_r[26 ]),.reg027(g_map_r[27 ]),.reg028(g_map_r[28 ]),.reg029(g_map_r[29 ]),
.reg030(g_map_r[30 ]),.reg031(g_map_r[31 ]),.reg032(g_map_r[32 ]),.reg033(g_map_r[33 ]),.reg034(g_map_r[34 ]),.reg035(g_map_r[35 ]),.reg036(g_map_r[36 ]),.reg037(g_map_r[37 ]),.reg038(g_map_r[38 ]),.reg039(g_map_r[39 ]),
.reg040(g_map_r[40 ]),.reg041(g_map_r[41 ]),.reg042(g_map_r[42 ]),.reg043(g_map_r[43 ]),.reg044(g_map_r[44 ]),.reg045(g_map_r[45 ]),.reg046(g_map_r[46 ]),.reg047(g_map_r[47 ]),.reg048(g_map_r[48 ]),.reg049(g_map_r[49 ]),
.reg050(g_map_r[50 ]),.reg051(g_map_r[51 ]),.reg052(g_map_r[52 ]),.reg053(g_map_r[53 ]),.reg054(g_map_r[54 ]),.reg055(g_map_r[55 ]),.reg056(g_map_r[56 ]),.reg057(g_map_r[57 ]),.reg058(g_map_r[58 ]),.reg059(g_map_r[59 ]),
.reg060(g_map_r[60 ]),.reg061(g_map_r[61 ]),.reg062(g_map_r[62 ]),.reg063(g_map_r[63 ]),.reg064(g_map_r[64 ]),.reg065(g_map_r[65 ]),.reg066(g_map_r[66 ]),.reg067(g_map_r[67 ]),.reg068(g_map_r[68 ]),.reg069(g_map_r[69 ]),
.reg070(g_map_r[70 ]),.reg071(g_map_r[71 ]),.reg072(g_map_r[72 ]),.reg073(g_map_r[73 ]),.reg074(g_map_r[74 ]),.reg075(g_map_r[75 ]),.reg076(g_map_r[76 ]),.reg077(g_map_r[77 ]),.reg078(g_map_r[78 ]),.reg079(g_map_r[79 ]),
.reg080(g_map_r[80 ]),.reg081(g_map_r[81 ]),.reg082(g_map_r[82 ]),.reg083(g_map_r[83 ]),.reg084(g_map_r[84 ]),.reg085(g_map_r[85 ]),.reg086(g_map_r[86 ]),.reg087(g_map_r[87 ]),.reg088(g_map_r[88 ]),.reg089(g_map_r[89 ]),
.reg090(g_map_r[90 ]),.reg091(g_map_r[91 ]),.reg092(g_map_r[92 ]),.reg093(g_map_r[93 ]),.reg094(g_map_r[94 ]),.reg095(g_map_r[95 ]),.reg096(g_map_r[96 ]),.reg097(g_map_r[97 ]),.reg098(g_map_r[98 ]),.reg099(g_map_r[99 ]),
.reg100(g_map_r[100]),.reg101(g_map_r[101]),.reg102(g_map_r[102]),.reg103(g_map_r[103]),.reg104(g_map_r[104]),.reg105(g_map_r[105]),.reg106(g_map_r[106]),.reg107(g_map_r[107]),.reg108(g_map_r[108]),.reg109(g_map_r[109]),
.reg110(g_map_r[110]),.reg111(g_map_r[111]),.reg112(g_map_r[112]),.reg113(g_map_r[113]),.reg114(g_map_r[114]),.reg115(g_map_r[115]),.reg116(g_map_r[116]),.reg117(g_map_r[117]),.reg118(g_map_r[118]),.reg119(g_map_r[119]),.reg120(g_map_r[120]),
.out000(g_map_w[0  ]),.out001(g_map_w[1  ]),.out002(g_map_w[2  ]),.out003(g_map_w[3  ]),.out004(g_map_w[4  ]),.out005(g_map_w[5  ]),.out006(g_map_w[6  ]),.out007(g_map_w[7  ]),.out008(g_map_w[8  ]),.out009(g_map_w[9  ]),
.out010(g_map_w[10 ]),.out011(g_map_w[11 ]),.out012(g_map_w[12 ]),.out013(g_map_w[13 ]),.out014(g_map_w[14 ]),.out015(g_map_w[15 ]),.out016(g_map_w[16 ]),.out017(g_map_w[17 ]),.out018(g_map_w[18 ]),.out019(g_map_w[19 ]),
.out020(g_map_w[20 ]),.out021(g_map_w[21 ]),.out022(g_map_w[22 ]),.out023(g_map_w[23 ]),.out024(g_map_w[24 ]),.out025(g_map_w[25 ]),.out026(g_map_w[26 ]),.out027(g_map_w[27 ]),.out028(g_map_w[28 ]),.out029(g_map_w[29 ]),
.out030(g_map_w[30 ]),.out031(g_map_w[31 ]),.out032(g_map_w[32 ]),.out033(g_map_w[33 ]),.out034(g_map_w[34 ]),.out035(g_map_w[35 ]),.out036(g_map_w[36 ]),.out037(g_map_w[37 ]),.out038(g_map_w[38 ]),.out039(g_map_w[39 ]),
.out040(g_map_w[40 ]),.out041(g_map_w[41 ]),.out042(g_map_w[42 ]),.out043(g_map_w[43 ]),.out044(g_map_w[44 ]),.out045(g_map_w[45 ]),.out046(g_map_w[46 ]),.out047(g_map_w[47 ]),.out048(g_map_w[48 ]),.out049(g_map_w[49 ]),
.out050(g_map_w[50 ]),.out051(g_map_w[51 ]),.out052(g_map_w[52 ]),.out053(g_map_w[53 ]),.out054(g_map_w[54 ]),.out055(g_map_w[55 ]),.out056(g_map_w[56 ]),.out057(g_map_w[57 ]),.out058(g_map_w[58 ]),.out059(g_map_w[59 ]),
.out060(g_map_w[60 ]),.out061(g_map_w[61 ]),.out062(g_map_w[62 ]),.out063(g_map_w[63 ]),.out064(g_map_w[64 ]),.out065(g_map_w[65 ]),.out066(g_map_w[66 ]),.out067(g_map_w[67 ]),.out068(g_map_w[68 ]),.out069(g_map_w[69 ]),
.out070(g_map_w[70 ]),.out071(g_map_w[71 ]),.out072(g_map_w[72 ]),.out073(g_map_w[73 ]),.out074(g_map_w[74 ]),.out075(g_map_w[75 ]),.out076(g_map_w[76 ]),.out077(g_map_w[77 ]),.out078(g_map_w[78 ]),.out079(g_map_w[79 ]),
.out080(g_map_w[80 ]),.out081(g_map_w[81 ]),.out082(g_map_w[82 ]),.out083(g_map_w[83 ]),.out084(g_map_w[84 ]),.out085(g_map_w[85 ]),.out086(g_map_w[86 ]),.out087(g_map_w[87 ]),.out088(g_map_w[88 ]),.out089(g_map_w[89 ]),
.out090(g_map_w[90 ]),.out091(g_map_w[91 ]),.out092(g_map_w[92 ]),.out093(g_map_w[93 ]),.out094(g_map_w[94 ]),.out095(g_map_w[95 ]),.out096(g_map_w[96 ]),.out097(g_map_w[97 ]),.out098(g_map_w[98 ]),.out099(g_map_w[99 ]),
.out100(g_map_w[100]),.out101(g_map_w[101]),.out102(g_map_w[102]),.out103(g_map_w[103]),.out104(g_map_w[104]),.out105(g_map_w[105]),.out106(g_map_w[106]),.out107(g_map_w[107]),.out108(g_map_w[108]),.out109(g_map_w[109]),
.out110(g_map_w[110]),.out111(g_map_w[111]),.out112(g_map_w[112]),.out113(g_map_w[113]),.out114(g_map_w[114]),.out115(g_map_w[115]),.out116(g_map_w[116]),.out117(g_map_w[117]),.out118(g_map_w[118]),.out119(g_map_w[119]),.out120(g_map_w[120])
);

mul_gi i2gi(.en(en_gi_map_r),
.i000_g(g_map_r[0  ]),.i001_g(g_map_r[1  ]),.i002_g(g_map_r[2  ]),.i003_g(g_map_r[3  ]),.i004_g(g_map_r[4  ]),.i005_g(g_map_r[5  ]),.i006_g(g_map_r[6  ]),.i007_g(g_map_r[7  ]),.i008_g(g_map_r[8  ]),.i009_g(g_map_r[9  ]),
.i010_g(g_map_r[10 ]),.i011_g(g_map_r[11 ]),.i012_g(g_map_r[12 ]),.i013_g(g_map_r[13 ]),.i014_g(g_map_r[14 ]),.i015_g(g_map_r[15 ]),.i016_g(g_map_r[16 ]),.i017_g(g_map_r[17 ]),.i018_g(g_map_r[18 ]),.i019_g(g_map_r[19 ]),
.i020_g(g_map_r[20 ]),.i021_g(g_map_r[21 ]),.i022_g(g_map_r[22 ]),.i023_g(g_map_r[23 ]),.i024_g(g_map_r[24 ]),.i025_g(g_map_r[25 ]),.i026_g(g_map_r[26 ]),.i027_g(g_map_r[27 ]),.i028_g(g_map_r[28 ]),.i029_g(g_map_r[29 ]),
.i030_g(g_map_r[30 ]),.i031_g(g_map_r[31 ]),.i032_g(g_map_r[32 ]),.i033_g(g_map_r[33 ]),.i034_g(g_map_r[34 ]),.i035_g(g_map_r[35 ]),.i036_g(g_map_r[36 ]),.i037_g(g_map_r[37 ]),.i038_g(g_map_r[38 ]),.i039_g(g_map_r[39 ]),
.i040_g(g_map_r[40 ]),.i041_g(g_map_r[41 ]),.i042_g(g_map_r[42 ]),.i043_g(g_map_r[43 ]),.i044_g(g_map_r[44 ]),.i045_g(g_map_r[45 ]),.i046_g(g_map_r[46 ]),.i047_g(g_map_r[47 ]),.i048_g(g_map_r[48 ]),.i049_g(g_map_r[49 ]),
.i050_g(g_map_r[50 ]),.i051_g(g_map_r[51 ]),.i052_g(g_map_r[52 ]),.i053_g(g_map_r[53 ]),.i054_g(g_map_r[54 ]),.i055_g(g_map_r[55 ]),.i056_g(g_map_r[56 ]),.i057_g(g_map_r[57 ]),.i058_g(g_map_r[58 ]),.i059_g(g_map_r[59 ]),
.i060_g(g_map_r[60 ]),.i061_g(g_map_r[61 ]),.i062_g(g_map_r[62 ]),.i063_g(g_map_r[63 ]),.i064_g(g_map_r[64 ]),.i065_g(g_map_r[65 ]),.i066_g(g_map_r[66 ]),.i067_g(g_map_r[67 ]),.i068_g(g_map_r[68 ]),.i069_g(g_map_r[69 ]),
.i070_g(g_map_r[70 ]),.i071_g(g_map_r[71 ]),.i072_g(g_map_r[72 ]),.i073_g(g_map_r[73 ]),.i074_g(g_map_r[74 ]),.i075_g(g_map_r[75 ]),.i076_g(g_map_r[76 ]),.i077_g(g_map_r[77 ]),.i078_g(g_map_r[78 ]),.i079_g(g_map_r[79 ]),
.i080_g(g_map_r[80 ]),.i081_g(g_map_r[81 ]),.i082_g(g_map_r[82 ]),.i083_g(g_map_r[83 ]),.i084_g(g_map_r[84 ]),.i085_g(g_map_r[85 ]),.i086_g(g_map_r[86 ]),.i087_g(g_map_r[87 ]),.i088_g(g_map_r[88 ]),.i089_g(g_map_r[89 ]),
.i090_g(g_map_r[90 ]),.i091_g(g_map_r[91 ]),.i092_g(g_map_r[92 ]),.i093_g(g_map_r[93 ]),.i094_g(g_map_r[94 ]),.i095_g(g_map_r[95 ]),.i096_g(g_map_r[96 ]),.i097_g(g_map_r[97 ]),.i098_g(g_map_r[98 ]),.i099_g(g_map_r[99 ]),
.i100_g(g_map_r[100]),.i101_g(g_map_r[101]),.i102_g(g_map_r[102]),.i103_g(g_map_r[103]),.i104_g(g_map_r[104]),.i105_g(g_map_r[105]),.i106_g(g_map_r[106]),.i107_g(g_map_r[107]),.i108_g(g_map_r[108]),.i109_g(g_map_r[109]),
.i110_g(g_map_r[110]),.i111_g(g_map_r[111]),.i112_g(g_map_r[112]),.i113_g(g_map_r[113]),.i114_g(g_map_r[114]),.i115_g(g_map_r[115]),.i116_g(g_map_r[116]),.i117_g(g_map_r[117]),.i118_g(g_map_r[118]),.i119_g(g_map_r[119]),.i120_g(g_map_r[120]),
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
.reg000(gi_map_r[0  ]),.reg001(gi_map_r[1  ]),.reg002(gi_map_r[2  ]),.reg003(gi_map_r[3  ]),.reg004(gi_map_r[4  ]),.reg005(gi_map_r[5  ]),.reg006(gi_map_r[6  ]),.reg007(gi_map_r[7  ]),.reg008(gi_map_r[8  ]),.reg009(gi_map_r[9  ]),
.reg010(gi_map_r[10 ]),.reg011(gi_map_r[11 ]),.reg012(gi_map_r[12 ]),.reg013(gi_map_r[13 ]),.reg014(gi_map_r[14 ]),.reg015(gi_map_r[15 ]),.reg016(gi_map_r[16 ]),.reg017(gi_map_r[17 ]),.reg018(gi_map_r[18 ]),.reg019(gi_map_r[19 ]),
.reg020(gi_map_r[20 ]),.reg021(gi_map_r[21 ]),.reg022(gi_map_r[22 ]),.reg023(gi_map_r[23 ]),.reg024(gi_map_r[24 ]),.reg025(gi_map_r[25 ]),.reg026(gi_map_r[26 ]),.reg027(gi_map_r[27 ]),.reg028(gi_map_r[28 ]),.reg029(gi_map_r[29 ]),
.reg030(gi_map_r[30 ]),.reg031(gi_map_r[31 ]),.reg032(gi_map_r[32 ]),.reg033(gi_map_r[33 ]),.reg034(gi_map_r[34 ]),.reg035(gi_map_r[35 ]),.reg036(gi_map_r[36 ]),.reg037(gi_map_r[37 ]),.reg038(gi_map_r[38 ]),.reg039(gi_map_r[39 ]),
.reg040(gi_map_r[40 ]),.reg041(gi_map_r[41 ]),.reg042(gi_map_r[42 ]),.reg043(gi_map_r[43 ]),.reg044(gi_map_r[44 ]),.reg045(gi_map_r[45 ]),.reg046(gi_map_r[46 ]),.reg047(gi_map_r[47 ]),.reg048(gi_map_r[48 ]),.reg049(gi_map_r[49 ]),
.reg050(gi_map_r[50 ]),.reg051(gi_map_r[51 ]),.reg052(gi_map_r[52 ]),.reg053(gi_map_r[53 ]),.reg054(gi_map_r[54 ]),.reg055(gi_map_r[55 ]),.reg056(gi_map_r[56 ]),.reg057(gi_map_r[57 ]),.reg058(gi_map_r[58 ]),.reg059(gi_map_r[59 ]),
.reg060(gi_map_r[60 ]),.reg061(gi_map_r[61 ]),.reg062(gi_map_r[62 ]),.reg063(gi_map_r[63 ]),.reg064(gi_map_r[64 ]),.reg065(gi_map_r[65 ]),.reg066(gi_map_r[66 ]),.reg067(gi_map_r[67 ]),.reg068(gi_map_r[68 ]),.reg069(gi_map_r[69 ]),
.reg070(gi_map_r[70 ]),.reg071(gi_map_r[71 ]),.reg072(gi_map_r[72 ]),.reg073(gi_map_r[73 ]),.reg074(gi_map_r[74 ]),.reg075(gi_map_r[75 ]),.reg076(gi_map_r[76 ]),.reg077(gi_map_r[77 ]),.reg078(gi_map_r[78 ]),.reg079(gi_map_r[79 ]),
.reg080(gi_map_r[80 ]),.reg081(gi_map_r[81 ]),.reg082(gi_map_r[82 ]),.reg083(gi_map_r[83 ]),.reg084(gi_map_r[84 ]),.reg085(gi_map_r[85 ]),.reg086(gi_map_r[86 ]),.reg087(gi_map_r[87 ]),.reg088(gi_map_r[88 ]),.reg089(gi_map_r[89 ]),
.reg090(gi_map_r[90 ]),.reg091(gi_map_r[91 ]),.reg092(gi_map_r[92 ]),.reg093(gi_map_r[93 ]),.reg094(gi_map_r[94 ]),.reg095(gi_map_r[95 ]),.reg096(gi_map_r[96 ]),.reg097(gi_map_r[97 ]),.reg098(gi_map_r[98 ]),.reg099(gi_map_r[99 ]),
.reg100(gi_map_r[100]),.reg101(gi_map_r[101]),.reg102(gi_map_r[102]),.reg103(gi_map_r[103]),.reg104(gi_map_r[104]),.reg105(gi_map_r[105]),.reg106(gi_map_r[106]),.reg107(gi_map_r[107]),.reg108(gi_map_r[108]),.reg109(gi_map_r[109]),
.reg110(gi_map_r[110]),.reg111(gi_map_r[111]),.reg112(gi_map_r[112]),.reg113(gi_map_r[113]),.reg114(gi_map_r[114]),.reg115(gi_map_r[115]),.reg116(gi_map_r[116]),.reg117(gi_map_r[117]),.reg118(gi_map_r[118]),.reg119(gi_map_r[119]),.reg120(gi_map_r[120]),
.out000(gi_map_w[0  ]),.out001(gi_map_w[1  ]),.out002(gi_map_w[2  ]),.out003(gi_map_w[3  ]),.out004(gi_map_w[4  ]),.out005(gi_map_w[5  ]),.out006(gi_map_w[6  ]),.out007(gi_map_w[7  ]),.out008(gi_map_w[8  ]),.out009(gi_map_w[9  ]),
.out010(gi_map_w[10 ]),.out011(gi_map_w[11 ]),.out012(gi_map_w[12 ]),.out013(gi_map_w[13 ]),.out014(gi_map_w[14 ]),.out015(gi_map_w[15 ]),.out016(gi_map_w[16 ]),.out017(gi_map_w[17 ]),.out018(gi_map_w[18 ]),.out019(gi_map_w[19 ]),
.out020(gi_map_w[20 ]),.out021(gi_map_w[21 ]),.out022(gi_map_w[22 ]),.out023(gi_map_w[23 ]),.out024(gi_map_w[24 ]),.out025(gi_map_w[25 ]),.out026(gi_map_w[26 ]),.out027(gi_map_w[27 ]),.out028(gi_map_w[28 ]),.out029(gi_map_w[29 ]),
.out030(gi_map_w[30 ]),.out031(gi_map_w[31 ]),.out032(gi_map_w[32 ]),.out033(gi_map_w[33 ]),.out034(gi_map_w[34 ]),.out035(gi_map_w[35 ]),.out036(gi_map_w[36 ]),.out037(gi_map_w[37 ]),.out038(gi_map_w[38 ]),.out039(gi_map_w[39 ]),
.out040(gi_map_w[40 ]),.out041(gi_map_w[41 ]),.out042(gi_map_w[42 ]),.out043(gi_map_w[43 ]),.out044(gi_map_w[44 ]),.out045(gi_map_w[45 ]),.out046(gi_map_w[46 ]),.out047(gi_map_w[47 ]),.out048(gi_map_w[48 ]),.out049(gi_map_w[49 ]),
.out050(gi_map_w[50 ]),.out051(gi_map_w[51 ]),.out052(gi_map_w[52 ]),.out053(gi_map_w[53 ]),.out054(gi_map_w[54 ]),.out055(gi_map_w[55 ]),.out056(gi_map_w[56 ]),.out057(gi_map_w[57 ]),.out058(gi_map_w[58 ]),.out059(gi_map_w[59 ]),
.out060(gi_map_w[60 ]),.out061(gi_map_w[61 ]),.out062(gi_map_w[62 ]),.out063(gi_map_w[63 ]),.out064(gi_map_w[64 ]),.out065(gi_map_w[65 ]),.out066(gi_map_w[66 ]),.out067(gi_map_w[67 ]),.out068(gi_map_w[68 ]),.out069(gi_map_w[69 ]),
.out070(gi_map_w[70 ]),.out071(gi_map_w[71 ]),.out072(gi_map_w[72 ]),.out073(gi_map_w[73 ]),.out074(gi_map_w[74 ]),.out075(gi_map_w[75 ]),.out076(gi_map_w[76 ]),.out077(gi_map_w[77 ]),.out078(gi_map_w[78 ]),.out079(gi_map_w[79 ]),
.out080(gi_map_w[80 ]),.out081(gi_map_w[81 ]),.out082(gi_map_w[82 ]),.out083(gi_map_w[83 ]),.out084(gi_map_w[84 ]),.out085(gi_map_w[85 ]),.out086(gi_map_w[86 ]),.out087(gi_map_w[87 ]),.out088(gi_map_w[88 ]),.out089(gi_map_w[89 ]),
.out090(gi_map_w[90 ]),.out091(gi_map_w[91 ]),.out092(gi_map_w[92 ]),.out093(gi_map_w[93 ]),.out094(gi_map_w[94 ]),.out095(gi_map_w[95 ]),.out096(gi_map_w[96 ]),.out097(gi_map_w[97 ]),.out098(gi_map_w[98 ]),.out099(gi_map_w[99 ]),
.out100(gi_map_w[100]),.out101(gi_map_w[101]),.out102(gi_map_w[102]),.out103(gi_map_w[103]),.out104(gi_map_w[104]),.out105(gi_map_w[105]),.out106(gi_map_w[106]),.out107(gi_map_w[107]),.out108(gi_map_w[108]),.out109(gi_map_w[109]),
.out110(gi_map_w[110]),.out111(gi_map_w[111]),.out112(gi_map_w[112]),.out113(gi_map_w[113]),.out114(gi_map_w[114]),.out115(gi_map_w[115]),.out116(gi_map_w[116]),.out117(gi_map_w[117]),.out118(gi_map_w[118]),.out119(gi_map_w[119]),.out120(gi_map_w[120])
);

mul_ghi gi2ghi(.en(en_ghi_map_r),
.i000_gi(gi_map_r[0  ]),.i001_gi(gi_map_r[1  ]),.i002_gi(gi_map_r[2  ]),.i003_gi(gi_map_r[3  ]),.i004_gi(gi_map_r[4  ]),.i005_gi(gi_map_r[5  ]),.i006_gi(gi_map_r[6  ]),.i007_gi(gi_map_r[7  ]),.i008_gi(gi_map_r[8  ]),.i009_gi(gi_map_r[9  ]),
.i010_gi(gi_map_r[10 ]),.i011_gi(gi_map_r[11 ]),.i012_gi(gi_map_r[12 ]),.i013_gi(gi_map_r[13 ]),.i014_gi(gi_map_r[14 ]),.i015_gi(gi_map_r[15 ]),.i016_gi(gi_map_r[16 ]),.i017_gi(gi_map_r[17 ]),.i018_gi(gi_map_r[18 ]),.i019_gi(gi_map_r[19 ]),
.i020_gi(gi_map_r[20 ]),.i021_gi(gi_map_r[21 ]),.i022_gi(gi_map_r[22 ]),.i023_gi(gi_map_r[23 ]),.i024_gi(gi_map_r[24 ]),.i025_gi(gi_map_r[25 ]),.i026_gi(gi_map_r[26 ]),.i027_gi(gi_map_r[27 ]),.i028_gi(gi_map_r[28 ]),.i029_gi(gi_map_r[29 ]),
.i030_gi(gi_map_r[30 ]),.i031_gi(gi_map_r[31 ]),.i032_gi(gi_map_r[32 ]),.i033_gi(gi_map_r[33 ]),.i034_gi(gi_map_r[34 ]),.i035_gi(gi_map_r[35 ]),.i036_gi(gi_map_r[36 ]),.i037_gi(gi_map_r[37 ]),.i038_gi(gi_map_r[38 ]),.i039_gi(gi_map_r[39 ]),
.i040_gi(gi_map_r[40 ]),.i041_gi(gi_map_r[41 ]),.i042_gi(gi_map_r[42 ]),.i043_gi(gi_map_r[43 ]),.i044_gi(gi_map_r[44 ]),.i045_gi(gi_map_r[45 ]),.i046_gi(gi_map_r[46 ]),.i047_gi(gi_map_r[47 ]),.i048_gi(gi_map_r[48 ]),.i049_gi(gi_map_r[49 ]),
.i050_gi(gi_map_r[50 ]),.i051_gi(gi_map_r[51 ]),.i052_gi(gi_map_r[52 ]),.i053_gi(gi_map_r[53 ]),.i054_gi(gi_map_r[54 ]),.i055_gi(gi_map_r[55 ]),.i056_gi(gi_map_r[56 ]),.i057_gi(gi_map_r[57 ]),.i058_gi(gi_map_r[58 ]),.i059_gi(gi_map_r[59 ]),
.i060_gi(gi_map_r[60 ]),.i061_gi(gi_map_r[61 ]),.i062_gi(gi_map_r[62 ]),.i063_gi(gi_map_r[63 ]),.i064_gi(gi_map_r[64 ]),.i065_gi(gi_map_r[65 ]),.i066_gi(gi_map_r[66 ]),.i067_gi(gi_map_r[67 ]),.i068_gi(gi_map_r[68 ]),.i069_gi(gi_map_r[69 ]),
.i070_gi(gi_map_r[70 ]),.i071_gi(gi_map_r[71 ]),.i072_gi(gi_map_r[72 ]),.i073_gi(gi_map_r[73 ]),.i074_gi(gi_map_r[74 ]),.i075_gi(gi_map_r[75 ]),.i076_gi(gi_map_r[76 ]),.i077_gi(gi_map_r[77 ]),.i078_gi(gi_map_r[78 ]),.i079_gi(gi_map_r[79 ]),
.i080_gi(gi_map_r[80 ]),.i081_gi(gi_map_r[81 ]),.i082_gi(gi_map_r[82 ]),.i083_gi(gi_map_r[83 ]),.i084_gi(gi_map_r[84 ]),.i085_gi(gi_map_r[85 ]),.i086_gi(gi_map_r[86 ]),.i087_gi(gi_map_r[87 ]),.i088_gi(gi_map_r[88 ]),.i089_gi(gi_map_r[89 ]),
.i090_gi(gi_map_r[90 ]),.i091_gi(gi_map_r[91 ]),.i092_gi(gi_map_r[92 ]),.i093_gi(gi_map_r[93 ]),.i094_gi(gi_map_r[94 ]),.i095_gi(gi_map_r[95 ]),.i096_gi(gi_map_r[96 ]),.i097_gi(gi_map_r[97 ]),.i098_gi(gi_map_r[98 ]),.i099_gi(gi_map_r[99 ]),
.i100_gi(gi_map_r[100]),.i101_gi(gi_map_r[101]),.i102_gi(gi_map_r[102]),.i103_gi(gi_map_r[103]),.i104_gi(gi_map_r[104]),.i105_gi(gi_map_r[105]),.i106_gi(gi_map_r[106]),.i107_gi(gi_map_r[107]),.i108_gi(gi_map_r[108]),.i109_gi(gi_map_r[109]),
.i110_gi(gi_map_r[110]),.i111_gi(gi_map_r[111]),.i112_gi(gi_map_r[112]),.i113_gi(gi_map_r[113]),.i114_gi(gi_map_r[114]),.i115_gi(gi_map_r[115]),.i116_gi(gi_map_r[116]),.i117_gi(gi_map_r[117]),.i118_gi(gi_map_r[118]),.i119_gi(gi_map_r[119]),.i120_gi(gi_map_r[120]),
.i000_h(h_map_r[0  ]),.i001_h(h_map_r[1  ]),.i002_h(h_map_r[2  ]),.i003_h(h_map_r[3  ]),.i004_h(h_map_r[4  ]),.i005_h(h_map_r[5  ]),.i006_h(h_map_r[6  ]),.i007_h(h_map_r[7  ]),.i008_h(h_map_r[8  ]),.i009_h(h_map_r[9  ]),
.i010_h(h_map_r[10 ]),.i011_h(h_map_r[11 ]),.i012_h(h_map_r[12 ]),.i013_h(h_map_r[13 ]),.i014_h(h_map_r[14 ]),.i015_h(h_map_r[15 ]),.i016_h(h_map_r[16 ]),.i017_h(h_map_r[17 ]),.i018_h(h_map_r[18 ]),.i019_h(h_map_r[19 ]),
.i020_h(h_map_r[20 ]),.i021_h(h_map_r[21 ]),.i022_h(h_map_r[22 ]),.i023_h(h_map_r[23 ]),.i024_h(h_map_r[24 ]),.i025_h(h_map_r[25 ]),.i026_h(h_map_r[26 ]),.i027_h(h_map_r[27 ]),.i028_h(h_map_r[28 ]),.i029_h(h_map_r[29 ]),
.i030_h(h_map_r[30 ]),.i031_h(h_map_r[31 ]),.i032_h(h_map_r[32 ]),.i033_h(h_map_r[33 ]),.i034_h(h_map_r[34 ]),.i035_h(h_map_r[35 ]),.i036_h(h_map_r[36 ]),.i037_h(h_map_r[37 ]),.i038_h(h_map_r[38 ]),.i039_h(h_map_r[39 ]),
.i040_h(h_map_r[40 ]),.i041_h(h_map_r[41 ]),.i042_h(h_map_r[42 ]),.i043_h(h_map_r[43 ]),.i044_h(h_map_r[44 ]),.i045_h(h_map_r[45 ]),.i046_h(h_map_r[46 ]),.i047_h(h_map_r[47 ]),.i048_h(h_map_r[48 ]),.i049_h(h_map_r[49 ]),
.i050_h(h_map_r[50 ]),.i051_h(h_map_r[51 ]),.i052_h(h_map_r[52 ]),.i053_h(h_map_r[53 ]),.i054_h(h_map_r[54 ]),.i055_h(h_map_r[55 ]),.i056_h(h_map_r[56 ]),.i057_h(h_map_r[57 ]),.i058_h(h_map_r[58 ]),.i059_h(h_map_r[59 ]),
.i060_h(h_map_r[60 ]),.i061_h(h_map_r[61 ]),.i062_h(h_map_r[62 ]),.i063_h(h_map_r[63 ]),.i064_h(h_map_r[64 ]),.i065_h(h_map_r[65 ]),.i066_h(h_map_r[66 ]),.i067_h(h_map_r[67 ]),.i068_h(h_map_r[68 ]),.i069_h(h_map_r[69 ]),
.i070_h(h_map_r[70 ]),.i071_h(h_map_r[71 ]),.i072_h(h_map_r[72 ]),.i073_h(h_map_r[73 ]),.i074_h(h_map_r[74 ]),.i075_h(h_map_r[75 ]),.i076_h(h_map_r[76 ]),.i077_h(h_map_r[77 ]),.i078_h(h_map_r[78 ]),.i079_h(h_map_r[79 ]),
.i080_h(h_map_r[80 ]),.i081_h(h_map_r[81 ]),.i082_h(h_map_r[82 ]),.i083_h(h_map_r[83 ]),.i084_h(h_map_r[84 ]),.i085_h(h_map_r[85 ]),.i086_h(h_map_r[86 ]),.i087_h(h_map_r[87 ]),.i088_h(h_map_r[88 ]),.i089_h(h_map_r[89 ]),
.i090_h(h_map_r[90 ]),.i091_h(h_map_r[91 ]),.i092_h(h_map_r[92 ]),.i093_h(h_map_r[93 ]),.i094_h(h_map_r[94 ]),.i095_h(h_map_r[95 ]),.i096_h(h_map_r[96 ]),.i097_h(h_map_r[97 ]),.i098_h(h_map_r[98 ]),.i099_h(h_map_r[99 ]),
.i100_h(h_map_r[100]),.i101_h(h_map_r[101]),.i102_h(h_map_r[102]),.i103_h(h_map_r[103]),.i104_h(h_map_r[104]),.i105_h(h_map_r[105]),.i106_h(h_map_r[106]),.i107_h(h_map_r[107]),.i108_h(h_map_r[108]),.i109_h(h_map_r[109]),
.i110_h(h_map_r[110]),.i111_h(h_map_r[111]),.i112_h(h_map_r[112]),.i113_h(h_map_r[113]),.i114_h(h_map_r[114]),.i115_h(h_map_r[115]),.i116_h(h_map_r[116]),.i117_h(h_map_r[117]),.i118_h(h_map_r[118]),.i119_h(h_map_r[119]),.i120_h(h_map_r[120]),
.reg000(ghi_map_r[0  ]),.reg001(ghi_map_r[1  ]),.reg002(ghi_map_r[2  ]),.reg003(ghi_map_r[3  ]),.reg004(ghi_map_r[4  ]),.reg005(ghi_map_r[5  ]),.reg006(ghi_map_r[6  ]),.reg007(ghi_map_r[7  ]),.reg008(ghi_map_r[8  ]),.reg009(ghi_map_r[9  ]),
.reg010(ghi_map_r[10 ]),.reg011(ghi_map_r[11 ]),.reg012(ghi_map_r[12 ]),.reg013(ghi_map_r[13 ]),.reg014(ghi_map_r[14 ]),.reg015(ghi_map_r[15 ]),.reg016(ghi_map_r[16 ]),.reg017(ghi_map_r[17 ]),.reg018(ghi_map_r[18 ]),.reg019(ghi_map_r[19 ]),
.reg020(ghi_map_r[20 ]),.reg021(ghi_map_r[21 ]),.reg022(ghi_map_r[22 ]),.reg023(ghi_map_r[23 ]),.reg024(ghi_map_r[24 ]),.reg025(ghi_map_r[25 ]),.reg026(ghi_map_r[26 ]),.reg027(ghi_map_r[27 ]),.reg028(ghi_map_r[28 ]),.reg029(ghi_map_r[29 ]),
.reg030(ghi_map_r[30 ]),.reg031(ghi_map_r[31 ]),.reg032(ghi_map_r[32 ]),.reg033(ghi_map_r[33 ]),.reg034(ghi_map_r[34 ]),.reg035(ghi_map_r[35 ]),.reg036(ghi_map_r[36 ]),.reg037(ghi_map_r[37 ]),.reg038(ghi_map_r[38 ]),.reg039(ghi_map_r[39 ]),
.reg040(ghi_map_r[40 ]),.reg041(ghi_map_r[41 ]),.reg042(ghi_map_r[42 ]),.reg043(ghi_map_r[43 ]),.reg044(ghi_map_r[44 ]),.reg045(ghi_map_r[45 ]),.reg046(ghi_map_r[46 ]),.reg047(ghi_map_r[47 ]),.reg048(ghi_map_r[48 ]),.reg049(ghi_map_r[49 ]),
.reg050(ghi_map_r[50 ]),.reg051(ghi_map_r[51 ]),.reg052(ghi_map_r[52 ]),.reg053(ghi_map_r[53 ]),.reg054(ghi_map_r[54 ]),.reg055(ghi_map_r[55 ]),.reg056(ghi_map_r[56 ]),.reg057(ghi_map_r[57 ]),.reg058(ghi_map_r[58 ]),.reg059(ghi_map_r[59 ]),
.reg060(ghi_map_r[60 ]),.reg061(ghi_map_r[61 ]),.reg062(ghi_map_r[62 ]),.reg063(ghi_map_r[63 ]),.reg064(ghi_map_r[64 ]),.reg065(ghi_map_r[65 ]),.reg066(ghi_map_r[66 ]),.reg067(ghi_map_r[67 ]),.reg068(ghi_map_r[68 ]),.reg069(ghi_map_r[69 ]),
.reg070(ghi_map_r[70 ]),.reg071(ghi_map_r[71 ]),.reg072(ghi_map_r[72 ]),.reg073(ghi_map_r[73 ]),.reg074(ghi_map_r[74 ]),.reg075(ghi_map_r[75 ]),.reg076(ghi_map_r[76 ]),.reg077(ghi_map_r[77 ]),.reg078(ghi_map_r[78 ]),.reg079(ghi_map_r[79 ]),
.reg080(ghi_map_r[80 ]),.reg081(ghi_map_r[81 ]),.reg082(ghi_map_r[82 ]),.reg083(ghi_map_r[83 ]),.reg084(ghi_map_r[84 ]),.reg085(ghi_map_r[85 ]),.reg086(ghi_map_r[86 ]),.reg087(ghi_map_r[87 ]),.reg088(ghi_map_r[88 ]),.reg089(ghi_map_r[89 ]),
.reg090(ghi_map_r[90 ]),.reg091(ghi_map_r[91 ]),.reg092(ghi_map_r[92 ]),.reg093(ghi_map_r[93 ]),.reg094(ghi_map_r[94 ]),.reg095(ghi_map_r[95 ]),.reg096(ghi_map_r[96 ]),.reg097(ghi_map_r[97 ]),.reg098(ghi_map_r[98 ]),.reg099(ghi_map_r[99 ]),
.reg100(ghi_map_r[100]),.reg101(ghi_map_r[101]),.reg102(ghi_map_r[102]),.reg103(ghi_map_r[103]),.reg104(ghi_map_r[104]),.reg105(ghi_map_r[105]),.reg106(ghi_map_r[106]),.reg107(ghi_map_r[107]),.reg108(ghi_map_r[108]),.reg109(ghi_map_r[109]),
.reg110(ghi_map_r[110]),.reg111(ghi_map_r[111]),.reg112(ghi_map_r[112]),.reg113(ghi_map_r[113]),.reg114(ghi_map_r[114]),.reg115(ghi_map_r[115]),.reg116(ghi_map_r[116]),.reg117(ghi_map_r[117]),.reg118(ghi_map_r[118]),.reg119(ghi_map_r[119]),.reg120(ghi_map_r[120]),
.out000(ghi_map_w[0  ]),.out001(ghi_map_w[1  ]),.out002(ghi_map_w[2  ]),.out003(ghi_map_w[3  ]),.out004(ghi_map_w[4  ]),.out005(ghi_map_w[5  ]),.out006(ghi_map_w[6  ]),.out007(ghi_map_w[7  ]),.out008(ghi_map_w[8  ]),.out009(ghi_map_w[9  ]),
.out010(ghi_map_w[10 ]),.out011(ghi_map_w[11 ]),.out012(ghi_map_w[12 ]),.out013(ghi_map_w[13 ]),.out014(ghi_map_w[14 ]),.out015(ghi_map_w[15 ]),.out016(ghi_map_w[16 ]),.out017(ghi_map_w[17 ]),.out018(ghi_map_w[18 ]),.out019(ghi_map_w[19 ]),
.out020(ghi_map_w[20 ]),.out021(ghi_map_w[21 ]),.out022(ghi_map_w[22 ]),.out023(ghi_map_w[23 ]),.out024(ghi_map_w[24 ]),.out025(ghi_map_w[25 ]),.out026(ghi_map_w[26 ]),.out027(ghi_map_w[27 ]),.out028(ghi_map_w[28 ]),.out029(ghi_map_w[29 ]),
.out030(ghi_map_w[30 ]),.out031(ghi_map_w[31 ]),.out032(ghi_map_w[32 ]),.out033(ghi_map_w[33 ]),.out034(ghi_map_w[34 ]),.out035(ghi_map_w[35 ]),.out036(ghi_map_w[36 ]),.out037(ghi_map_w[37 ]),.out038(ghi_map_w[38 ]),.out039(ghi_map_w[39 ]),
.out040(ghi_map_w[40 ]),.out041(ghi_map_w[41 ]),.out042(ghi_map_w[42 ]),.out043(ghi_map_w[43 ]),.out044(ghi_map_w[44 ]),.out045(ghi_map_w[45 ]),.out046(ghi_map_w[46 ]),.out047(ghi_map_w[47 ]),.out048(ghi_map_w[48 ]),.out049(ghi_map_w[49 ]),
.out050(ghi_map_w[50 ]),.out051(ghi_map_w[51 ]),.out052(ghi_map_w[52 ]),.out053(ghi_map_w[53 ]),.out054(ghi_map_w[54 ]),.out055(ghi_map_w[55 ]),.out056(ghi_map_w[56 ]),.out057(ghi_map_w[57 ]),.out058(ghi_map_w[58 ]),.out059(ghi_map_w[59 ]),
.out060(ghi_map_w[60 ]),.out061(ghi_map_w[61 ]),.out062(ghi_map_w[62 ]),.out063(ghi_map_w[63 ]),.out064(ghi_map_w[64 ]),.out065(ghi_map_w[65 ]),.out066(ghi_map_w[66 ]),.out067(ghi_map_w[67 ]),.out068(ghi_map_w[68 ]),.out069(ghi_map_w[69 ]),
.out070(ghi_map_w[70 ]),.out071(ghi_map_w[71 ]),.out072(ghi_map_w[72 ]),.out073(ghi_map_w[73 ]),.out074(ghi_map_w[74 ]),.out075(ghi_map_w[75 ]),.out076(ghi_map_w[76 ]),.out077(ghi_map_w[77 ]),.out078(ghi_map_w[78 ]),.out079(ghi_map_w[79 ]),
.out080(ghi_map_w[80 ]),.out081(ghi_map_w[81 ]),.out082(ghi_map_w[82 ]),.out083(ghi_map_w[83 ]),.out084(ghi_map_w[84 ]),.out085(ghi_map_w[85 ]),.out086(ghi_map_w[86 ]),.out087(ghi_map_w[87 ]),.out088(ghi_map_w[88 ]),.out089(ghi_map_w[89 ]),
.out090(ghi_map_w[90 ]),.out091(ghi_map_w[91 ]),.out092(ghi_map_w[92 ]),.out093(ghi_map_w[93 ]),.out094(ghi_map_w[94 ]),.out095(ghi_map_w[95 ]),.out096(ghi_map_w[96 ]),.out097(ghi_map_w[97 ]),.out098(ghi_map_w[98 ]),.out099(ghi_map_w[99 ]),
.out100(ghi_map_w[100]),.out101(ghi_map_w[101]),.out102(ghi_map_w[102]),.out103(ghi_map_w[103]),.out104(ghi_map_w[104]),.out105(ghi_map_w[105]),.out106(ghi_map_w[106]),.out107(ghi_map_w[107]),.out108(ghi_map_w[108]),.out109(ghi_map_w[109]),
.out110(ghi_map_w[110]),.out111(ghi_map_w[111]),.out112(ghi_map_w[112]),.out113(ghi_map_w[113]),.out114(ghi_map_w[114]),.out115(ghi_map_w[115]),.out116(ghi_map_w[116]),.out117(ghi_map_w[117]),.out118(ghi_map_w[118]),.out119(ghi_map_w[119]),.out120(ghi_map_w[120])
);

sum_ghi ghi2sum(.en(en_sum_ghi_r),.reg_sum(sum_ghi_r),.out_sum(sum_ghi_w),
.ghi000(ghi_map_r[0  ]),.ghi001(ghi_map_r[1  ]),.ghi002(ghi_map_r[2  ]),.ghi003(ghi_map_r[3  ]),.ghi004(ghi_map_r[4  ]),.ghi005(ghi_map_r[5  ]),.ghi006(ghi_map_r[6  ]),.ghi007(ghi_map_r[7  ]),.ghi008(ghi_map_r[8  ]),.ghi009(ghi_map_r[9  ]),
.ghi010(ghi_map_r[10 ]),.ghi011(ghi_map_r[11 ]),.ghi012(ghi_map_r[12 ]),.ghi013(ghi_map_r[13 ]),.ghi014(ghi_map_r[14 ]),.ghi015(ghi_map_r[15 ]),.ghi016(ghi_map_r[16 ]),.ghi017(ghi_map_r[17 ]),.ghi018(ghi_map_r[18 ]),.ghi019(ghi_map_r[19 ]),
.ghi020(ghi_map_r[20 ]),.ghi021(ghi_map_r[21 ]),.ghi022(ghi_map_r[22 ]),.ghi023(ghi_map_r[23 ]),.ghi024(ghi_map_r[24 ]),.ghi025(ghi_map_r[25 ]),.ghi026(ghi_map_r[26 ]),.ghi027(ghi_map_r[27 ]),.ghi028(ghi_map_r[28 ]),.ghi029(ghi_map_r[29 ]),
.ghi030(ghi_map_r[30 ]),.ghi031(ghi_map_r[31 ]),.ghi032(ghi_map_r[32 ]),.ghi033(ghi_map_r[33 ]),.ghi034(ghi_map_r[34 ]),.ghi035(ghi_map_r[35 ]),.ghi036(ghi_map_r[36 ]),.ghi037(ghi_map_r[37 ]),.ghi038(ghi_map_r[38 ]),.ghi039(ghi_map_r[39 ]),
.ghi040(ghi_map_r[40 ]),.ghi041(ghi_map_r[41 ]),.ghi042(ghi_map_r[42 ]),.ghi043(ghi_map_r[43 ]),.ghi044(ghi_map_r[44 ]),.ghi045(ghi_map_r[45 ]),.ghi046(ghi_map_r[46 ]),.ghi047(ghi_map_r[47 ]),.ghi048(ghi_map_r[48 ]),.ghi049(ghi_map_r[49 ]),
.ghi050(ghi_map_r[50 ]),.ghi051(ghi_map_r[51 ]),.ghi052(ghi_map_r[52 ]),.ghi053(ghi_map_r[53 ]),.ghi054(ghi_map_r[54 ]),.ghi055(ghi_map_r[55 ]),.ghi056(ghi_map_r[56 ]),.ghi057(ghi_map_r[57 ]),.ghi058(ghi_map_r[58 ]),.ghi059(ghi_map_r[59 ]),
.ghi060(ghi_map_r[60 ]),.ghi061(ghi_map_r[61 ]),.ghi062(ghi_map_r[62 ]),.ghi063(ghi_map_r[63 ]),.ghi064(ghi_map_r[64 ]),.ghi065(ghi_map_r[65 ]),.ghi066(ghi_map_r[66 ]),.ghi067(ghi_map_r[67 ]),.ghi068(ghi_map_r[68 ]),.ghi069(ghi_map_r[69 ]),
.ghi070(ghi_map_r[70 ]),.ghi071(ghi_map_r[71 ]),.ghi072(ghi_map_r[72 ]),.ghi073(ghi_map_r[73 ]),.ghi074(ghi_map_r[74 ]),.ghi075(ghi_map_r[75 ]),.ghi076(ghi_map_r[76 ]),.ghi077(ghi_map_r[77 ]),.ghi078(ghi_map_r[78 ]),.ghi079(ghi_map_r[79 ]),
.ghi080(ghi_map_r[80 ]),.ghi081(ghi_map_r[81 ]),.ghi082(ghi_map_r[82 ]),.ghi083(ghi_map_r[83 ]),.ghi084(ghi_map_r[84 ]),.ghi085(ghi_map_r[85 ]),.ghi086(ghi_map_r[86 ]),.ghi087(ghi_map_r[87 ]),.ghi088(ghi_map_r[88 ]),.ghi089(ghi_map_r[89 ]),
.ghi090(ghi_map_r[90 ]),.ghi091(ghi_map_r[91 ]),.ghi092(ghi_map_r[92 ]),.ghi093(ghi_map_r[93 ]),.ghi094(ghi_map_r[94 ]),.ghi095(ghi_map_r[95 ]),.ghi096(ghi_map_r[96 ]),.ghi097(ghi_map_r[97 ]),.ghi098(ghi_map_r[98 ]),.ghi099(ghi_map_r[99 ]),
.ghi100(ghi_map_r[100]),.ghi101(ghi_map_r[101]),.ghi102(ghi_map_r[102]),.ghi103(ghi_map_r[103]),.ghi104(ghi_map_r[104]),.ghi105(ghi_map_r[105]),.ghi106(ghi_map_r[106]),.ghi107(ghi_map_r[107]),.ghi108(ghi_map_r[108]),.ghi109(ghi_map_r[109]),
.ghi110(ghi_map_r[110]),.ghi111(ghi_map_r[111]),.ghi112(ghi_map_r[112]),.ghi113(ghi_map_r[113]),.ghi114(ghi_map_r[114]),.ghi115(ghi_map_r[115]),.ghi116(ghi_map_r[116]),.ghi117(ghi_map_r[117]),.ghi118(ghi_map_r[118]),.ghi119(ghi_map_r[119]),.ghi120(ghi_map_r[120])
);


// ---------------------------------------------
// ---------------------------------------------
// ---------------------------------------------


mul_h i_i02h(.en(en_h_map_r),.clk(clk),.rst(rst),
.i000_n(i_i0_map_r[0  ]),.i001_n(i_i0_map_r[1  ]),.i002_n(i_i0_map_r[2  ]),.i003_n(i_i0_map_r[3  ]),.i004_n(i_i0_map_r[4  ]),.i005_n(i_i0_map_r[5  ]),.i006_n(i_i0_map_r[6  ]),.i007_n(i_i0_map_r[7  ]),.i008_n(i_i0_map_r[8  ]),.i009_n(i_i0_map_r[9  ]),
.i010_n(i_i0_map_r[10 ]),.i011_n(i_i0_map_r[11 ]),.i012_n(i_i0_map_r[12 ]),.i013_n(i_i0_map_r[13 ]),.i014_n(i_i0_map_r[14 ]),.i015_n(i_i0_map_r[15 ]),.i016_n(i_i0_map_r[16 ]),.i017_n(i_i0_map_r[17 ]),.i018_n(i_i0_map_r[18 ]),.i019_n(i_i0_map_r[19 ]),
.i020_n(i_i0_map_r[20 ]),.i021_n(i_i0_map_r[21 ]),.i022_n(i_i0_map_r[22 ]),.i023_n(i_i0_map_r[23 ]),.i024_n(i_i0_map_r[24 ]),.i025_n(i_i0_map_r[25 ]),.i026_n(i_i0_map_r[26 ]),.i027_n(i_i0_map_r[27 ]),.i028_n(i_i0_map_r[28 ]),.i029_n(i_i0_map_r[29 ]),
.i030_n(i_i0_map_r[30 ]),.i031_n(i_i0_map_r[31 ]),.i032_n(i_i0_map_r[32 ]),.i033_n(i_i0_map_r[33 ]),.i034_n(i_i0_map_r[34 ]),.i035_n(i_i0_map_r[35 ]),.i036_n(i_i0_map_r[36 ]),.i037_n(i_i0_map_r[37 ]),.i038_n(i_i0_map_r[38 ]),.i039_n(i_i0_map_r[39 ]),
.i040_n(i_i0_map_r[40 ]),.i041_n(i_i0_map_r[41 ]),.i042_n(i_i0_map_r[42 ]),.i043_n(i_i0_map_r[43 ]),.i044_n(i_i0_map_r[44 ]),.i045_n(i_i0_map_r[45 ]),.i046_n(i_i0_map_r[46 ]),.i047_n(i_i0_map_r[47 ]),.i048_n(i_i0_map_r[48 ]),.i049_n(i_i0_map_r[49 ]),
.i050_n(i_i0_map_r[50 ]),.i051_n(i_i0_map_r[51 ]),.i052_n(i_i0_map_r[52 ]),.i053_n(i_i0_map_r[53 ]),.i054_n(i_i0_map_r[54 ]),.i055_n(i_i0_map_r[55 ]),.i056_n(i_i0_map_r[56 ]),.i057_n(i_i0_map_r[57 ]),.i058_n(i_i0_map_r[58 ]),.i059_n(i_i0_map_r[59 ]),
.i060_n(i_i0_map_r[60 ]),.i061_n(i_i0_map_r[61 ]),.i062_n(i_i0_map_r[62 ]),.i063_n(i_i0_map_r[63 ]),.i064_n(i_i0_map_r[64 ]),.i065_n(i_i0_map_r[65 ]),.i066_n(i_i0_map_r[66 ]),.i067_n(i_i0_map_r[67 ]),.i068_n(i_i0_map_r[68 ]),.i069_n(i_i0_map_r[69 ]),
.i070_n(i_i0_map_r[70 ]),.i071_n(i_i0_map_r[71 ]),.i072_n(i_i0_map_r[72 ]),.i073_n(i_i0_map_r[73 ]),.i074_n(i_i0_map_r[74 ]),.i075_n(i_i0_map_r[75 ]),.i076_n(i_i0_map_r[76 ]),.i077_n(i_i0_map_r[77 ]),.i078_n(i_i0_map_r[78 ]),.i079_n(i_i0_map_r[79 ]),
.i080_n(i_i0_map_r[80 ]),.i081_n(i_i0_map_r[81 ]),.i082_n(i_i0_map_r[82 ]),.i083_n(i_i0_map_r[83 ]),.i084_n(i_i0_map_r[84 ]),.i085_n(i_i0_map_r[85 ]),.i086_n(i_i0_map_r[86 ]),.i087_n(i_i0_map_r[87 ]),.i088_n(i_i0_map_r[88 ]),.i089_n(i_i0_map_r[89 ]),
.i090_n(i_i0_map_r[90 ]),.i091_n(i_i0_map_r[91 ]),.i092_n(i_i0_map_r[92 ]),.i093_n(i_i0_map_r[93 ]),.i094_n(i_i0_map_r[94 ]),.i095_n(i_i0_map_r[95 ]),.i096_n(i_i0_map_r[96 ]),.i097_n(i_i0_map_r[97 ]),.i098_n(i_i0_map_r[98 ]),.i099_n(i_i0_map_r[99 ]),
.i100_n(i_i0_map_r[100]),.i101_n(i_i0_map_r[101]),.i102_n(i_i0_map_r[102]),.i103_n(i_i0_map_r[103]),.i104_n(i_i0_map_r[104]),.i105_n(i_i0_map_r[105]),.i106_n(i_i0_map_r[106]),.i107_n(i_i0_map_r[107]),.i108_n(i_i0_map_r[108]),.i109_n(i_i0_map_r[109]),
.i110_n(i_i0_map_r[110]),.i111_n(i_i0_map_r[111]),.i112_n(i_i0_map_r[112]),.i113_n(i_i0_map_r[113]),.i114_n(i_i0_map_r[114]),.i115_n(i_i0_map_r[115]),.i116_n(i_i0_map_r[116]),.i117_n(i_i0_map_r[117]),.i118_n(i_i0_map_r[118]),.i119_n(i_i0_map_r[119]),.i120_n(i_i0_map_r[120]),
.reg000(h_map_r[0  ]),.reg001(h_map_r[1  ]),.reg002(h_map_r[2  ]),.reg003(h_map_r[3  ]),.reg004(h_map_r[4  ]),.reg005(h_map_r[5  ]),.reg006(h_map_r[6  ]),.reg007(h_map_r[7  ]),.reg008(h_map_r[8  ]),.reg009(h_map_r[9  ]),
.reg010(h_map_r[10 ]),.reg011(h_map_r[11 ]),.reg012(h_map_r[12 ]),.reg013(h_map_r[13 ]),.reg014(h_map_r[14 ]),.reg015(h_map_r[15 ]),.reg016(h_map_r[16 ]),.reg017(h_map_r[17 ]),.reg018(h_map_r[18 ]),.reg019(h_map_r[19 ]),
.reg020(h_map_r[20 ]),.reg021(h_map_r[21 ]),.reg022(h_map_r[22 ]),.reg023(h_map_r[23 ]),.reg024(h_map_r[24 ]),.reg025(h_map_r[25 ]),.reg026(h_map_r[26 ]),.reg027(h_map_r[27 ]),.reg028(h_map_r[28 ]),.reg029(h_map_r[29 ]),
.reg030(h_map_r[30 ]),.reg031(h_map_r[31 ]),.reg032(h_map_r[32 ]),.reg033(h_map_r[33 ]),.reg034(h_map_r[34 ]),.reg035(h_map_r[35 ]),.reg036(h_map_r[36 ]),.reg037(h_map_r[37 ]),.reg038(h_map_r[38 ]),.reg039(h_map_r[39 ]),
.reg040(h_map_r[40 ]),.reg041(h_map_r[41 ]),.reg042(h_map_r[42 ]),.reg043(h_map_r[43 ]),.reg044(h_map_r[44 ]),.reg045(h_map_r[45 ]),.reg046(h_map_r[46 ]),.reg047(h_map_r[47 ]),.reg048(h_map_r[48 ]),.reg049(h_map_r[49 ]),
.reg050(h_map_r[50 ]),.reg051(h_map_r[51 ]),.reg052(h_map_r[52 ]),.reg053(h_map_r[53 ]),.reg054(h_map_r[54 ]),.reg055(h_map_r[55 ]),.reg056(h_map_r[56 ]),.reg057(h_map_r[57 ]),.reg058(h_map_r[58 ]),.reg059(h_map_r[59 ]),
.reg060(h_map_r[60 ]),.reg061(h_map_r[61 ]),.reg062(h_map_r[62 ]),.reg063(h_map_r[63 ]),.reg064(h_map_r[64 ]),.reg065(h_map_r[65 ]),.reg066(h_map_r[66 ]),.reg067(h_map_r[67 ]),.reg068(h_map_r[68 ]),.reg069(h_map_r[69 ]),
.reg070(h_map_r[70 ]),.reg071(h_map_r[71 ]),.reg072(h_map_r[72 ]),.reg073(h_map_r[73 ]),.reg074(h_map_r[74 ]),.reg075(h_map_r[75 ]),.reg076(h_map_r[76 ]),.reg077(h_map_r[77 ]),.reg078(h_map_r[78 ]),.reg079(h_map_r[79 ]),
.reg080(h_map_r[80 ]),.reg081(h_map_r[81 ]),.reg082(h_map_r[82 ]),.reg083(h_map_r[83 ]),.reg084(h_map_r[84 ]),.reg085(h_map_r[85 ]),.reg086(h_map_r[86 ]),.reg087(h_map_r[87 ]),.reg088(h_map_r[88 ]),.reg089(h_map_r[89 ]),
.reg090(h_map_r[90 ]),.reg091(h_map_r[91 ]),.reg092(h_map_r[92 ]),.reg093(h_map_r[93 ]),.reg094(h_map_r[94 ]),.reg095(h_map_r[95 ]),.reg096(h_map_r[96 ]),.reg097(h_map_r[97 ]),.reg098(h_map_r[98 ]),.reg099(h_map_r[99 ]),
.reg100(h_map_r[100]),.reg101(h_map_r[101]),.reg102(h_map_r[102]),.reg103(h_map_r[103]),.reg104(h_map_r[104]),.reg105(h_map_r[105]),.reg106(h_map_r[106]),.reg107(h_map_r[107]),.reg108(h_map_r[108]),.reg109(h_map_r[109]),
.reg110(h_map_r[110]),.reg111(h_map_r[111]),.reg112(h_map_r[112]),.reg113(h_map_r[113]),.reg114(h_map_r[114]),.reg115(h_map_r[115]),.reg116(h_map_r[116]),.reg117(h_map_r[117]),.reg118(h_map_r[118]),.reg119(h_map_r[119]),.reg120(h_map_r[120]),
.out000(h_map_w[0  ]),.out001(h_map_w[1  ]),.out002(h_map_w[2  ]),.out003(h_map_w[3  ]),.out004(h_map_w[4  ]),.out005(h_map_w[5  ]),.out006(h_map_w[6  ]),.out007(h_map_w[7  ]),.out008(h_map_w[8  ]),.out009(h_map_w[9  ]),
.out010(h_map_w[10 ]),.out011(h_map_w[11 ]),.out012(h_map_w[12 ]),.out013(h_map_w[13 ]),.out014(h_map_w[14 ]),.out015(h_map_w[15 ]),.out016(h_map_w[16 ]),.out017(h_map_w[17 ]),.out018(h_map_w[18 ]),.out019(h_map_w[19 ]),
.out020(h_map_w[20 ]),.out021(h_map_w[21 ]),.out022(h_map_w[22 ]),.out023(h_map_w[23 ]),.out024(h_map_w[24 ]),.out025(h_map_w[25 ]),.out026(h_map_w[26 ]),.out027(h_map_w[27 ]),.out028(h_map_w[28 ]),.out029(h_map_w[29 ]),
.out030(h_map_w[30 ]),.out031(h_map_w[31 ]),.out032(h_map_w[32 ]),.out033(h_map_w[33 ]),.out034(h_map_w[34 ]),.out035(h_map_w[35 ]),.out036(h_map_w[36 ]),.out037(h_map_w[37 ]),.out038(h_map_w[38 ]),.out039(h_map_w[39 ]),
.out040(h_map_w[40 ]),.out041(h_map_w[41 ]),.out042(h_map_w[42 ]),.out043(h_map_w[43 ]),.out044(h_map_w[44 ]),.out045(h_map_w[45 ]),.out046(h_map_w[46 ]),.out047(h_map_w[47 ]),.out048(h_map_w[48 ]),.out049(h_map_w[49 ]),
.out050(h_map_w[50 ]),.out051(h_map_w[51 ]),.out052(h_map_w[52 ]),.out053(h_map_w[53 ]),.out054(h_map_w[54 ]),.out055(h_map_w[55 ]),.out056(h_map_w[56 ]),.out057(h_map_w[57 ]),.out058(h_map_w[58 ]),.out059(h_map_w[59 ]),
.out060(h_map_w[60 ]),.out061(h_map_w[61 ]),.out062(h_map_w[62 ]),.out063(h_map_w[63 ]),.out064(h_map_w[64 ]),.out065(h_map_w[65 ]),.out066(h_map_w[66 ]),.out067(h_map_w[67 ]),.out068(h_map_w[68 ]),.out069(h_map_w[69 ]),
.out070(h_map_w[70 ]),.out071(h_map_w[71 ]),.out072(h_map_w[72 ]),.out073(h_map_w[73 ]),.out074(h_map_w[74 ]),.out075(h_map_w[75 ]),.out076(h_map_w[76 ]),.out077(h_map_w[77 ]),.out078(h_map_w[78 ]),.out079(h_map_w[79 ]),
.out080(h_map_w[80 ]),.out081(h_map_w[81 ]),.out082(h_map_w[82 ]),.out083(h_map_w[83 ]),.out084(h_map_w[84 ]),.out085(h_map_w[85 ]),.out086(h_map_w[86 ]),.out087(h_map_w[87 ]),.out088(h_map_w[88 ]),.out089(h_map_w[89 ]),
.out090(h_map_w[90 ]),.out091(h_map_w[91 ]),.out092(h_map_w[92 ]),.out093(h_map_w[93 ]),.out094(h_map_w[94 ]),.out095(h_map_w[95 ]),.out096(h_map_w[96 ]),.out097(h_map_w[97 ]),.out098(h_map_w[98 ]),.out099(h_map_w[99 ]),
.out100(h_map_w[100]),.out101(h_map_w[101]),.out102(h_map_w[102]),.out103(h_map_w[103]),.out104(h_map_w[104]),.out105(h_map_w[105]),.out106(h_map_w[106]),.out107(h_map_w[107]),.out108(h_map_w[108]),.out109(h_map_w[109]),
.out110(h_map_w[110]),.out111(h_map_w[111]),.out112(h_map_w[112]),.out113(h_map_w[113]),.out114(h_map_w[114]),.out115(h_map_w[115]),.out116(h_map_w[116]),.out117(h_map_w[117]),.out118(h_map_w[118]),.out119(h_map_w[119]),.out120(h_map_w[120])
);

mul_hi h2hi(.en(en_hi_map_r),
.i000_h(h_map_r[0  ]),.i001_h(h_map_r[1  ]),.i002_h(h_map_r[2  ]),.i003_h(h_map_r[3  ]),.i004_h(h_map_r[4  ]),.i005_h(h_map_r[5  ]),.i006_h(h_map_r[6  ]),.i007_h(h_map_r[7  ]),.i008_h(h_map_r[8  ]),.i009_h(h_map_r[9  ]),
.i010_h(h_map_r[10 ]),.i011_h(h_map_r[11 ]),.i012_h(h_map_r[12 ]),.i013_h(h_map_r[13 ]),.i014_h(h_map_r[14 ]),.i015_h(h_map_r[15 ]),.i016_h(h_map_r[16 ]),.i017_h(h_map_r[17 ]),.i018_h(h_map_r[18 ]),.i019_h(h_map_r[19 ]),
.i020_h(h_map_r[20 ]),.i021_h(h_map_r[21 ]),.i022_h(h_map_r[22 ]),.i023_h(h_map_r[23 ]),.i024_h(h_map_r[24 ]),.i025_h(h_map_r[25 ]),.i026_h(h_map_r[26 ]),.i027_h(h_map_r[27 ]),.i028_h(h_map_r[28 ]),.i029_h(h_map_r[29 ]),
.i030_h(h_map_r[30 ]),.i031_h(h_map_r[31 ]),.i032_h(h_map_r[32 ]),.i033_h(h_map_r[33 ]),.i034_h(h_map_r[34 ]),.i035_h(h_map_r[35 ]),.i036_h(h_map_r[36 ]),.i037_h(h_map_r[37 ]),.i038_h(h_map_r[38 ]),.i039_h(h_map_r[39 ]),
.i040_h(h_map_r[40 ]),.i041_h(h_map_r[41 ]),.i042_h(h_map_r[42 ]),.i043_h(h_map_r[43 ]),.i044_h(h_map_r[44 ]),.i045_h(h_map_r[45 ]),.i046_h(h_map_r[46 ]),.i047_h(h_map_r[47 ]),.i048_h(h_map_r[48 ]),.i049_h(h_map_r[49 ]),
.i050_h(h_map_r[50 ]),.i051_h(h_map_r[51 ]),.i052_h(h_map_r[52 ]),.i053_h(h_map_r[53 ]),.i054_h(h_map_r[54 ]),.i055_h(h_map_r[55 ]),.i056_h(h_map_r[56 ]),.i057_h(h_map_r[57 ]),.i058_h(h_map_r[58 ]),.i059_h(h_map_r[59 ]),
.i060_h(h_map_r[60 ]),.i061_h(h_map_r[61 ]),.i062_h(h_map_r[62 ]),.i063_h(h_map_r[63 ]),.i064_h(h_map_r[64 ]),.i065_h(h_map_r[65 ]),.i066_h(h_map_r[66 ]),.i067_h(h_map_r[67 ]),.i068_h(h_map_r[68 ]),.i069_h(h_map_r[69 ]),
.i070_h(h_map_r[70 ]),.i071_h(h_map_r[71 ]),.i072_h(h_map_r[72 ]),.i073_h(h_map_r[73 ]),.i074_h(h_map_r[74 ]),.i075_h(h_map_r[75 ]),.i076_h(h_map_r[76 ]),.i077_h(h_map_r[77 ]),.i078_h(h_map_r[78 ]),.i079_h(h_map_r[79 ]),
.i080_h(h_map_r[80 ]),.i081_h(h_map_r[81 ]),.i082_h(h_map_r[82 ]),.i083_h(h_map_r[83 ]),.i084_h(h_map_r[84 ]),.i085_h(h_map_r[85 ]),.i086_h(h_map_r[86 ]),.i087_h(h_map_r[87 ]),.i088_h(h_map_r[88 ]),.i089_h(h_map_r[89 ]),
.i090_h(h_map_r[90 ]),.i091_h(h_map_r[91 ]),.i092_h(h_map_r[92 ]),.i093_h(h_map_r[93 ]),.i094_h(h_map_r[94 ]),.i095_h(h_map_r[95 ]),.i096_h(h_map_r[96 ]),.i097_h(h_map_r[97 ]),.i098_h(h_map_r[98 ]),.i099_h(h_map_r[99 ]),
.i100_h(h_map_r[100]),.i101_h(h_map_r[101]),.i102_h(h_map_r[102]),.i103_h(h_map_r[103]),.i104_h(h_map_r[104]),.i105_h(h_map_r[105]),.i106_h(h_map_r[106]),.i107_h(h_map_r[107]),.i108_h(h_map_r[108]),.i109_h(h_map_r[109]),
.i110_h(h_map_r[110]),.i111_h(h_map_r[111]),.i112_h(h_map_r[112]),.i113_h(h_map_r[113]),.i114_h(h_map_r[114]),.i115_h(h_map_r[115]),.i116_h(h_map_r[116]),.i117_h(h_map_r[117]),.i118_h(h_map_r[118]),.i119_h(h_map_r[119]),.i120_h(h_map_r[120]),
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
.reg000(hi_map_r[0  ]),.reg001(hi_map_r[1  ]),.reg002(hi_map_r[2  ]),.reg003(hi_map_r[3  ]),.reg004(hi_map_r[4  ]),.reg005(hi_map_r[5  ]),.reg006(hi_map_r[6  ]),.reg007(hi_map_r[7  ]),.reg008(hi_map_r[8  ]),.reg009(hi_map_r[9  ]),
.reg010(hi_map_r[10 ]),.reg011(hi_map_r[11 ]),.reg012(hi_map_r[12 ]),.reg013(hi_map_r[13 ]),.reg014(hi_map_r[14 ]),.reg015(hi_map_r[15 ]),.reg016(hi_map_r[16 ]),.reg017(hi_map_r[17 ]),.reg018(hi_map_r[18 ]),.reg019(hi_map_r[19 ]),
.reg020(hi_map_r[20 ]),.reg021(hi_map_r[21 ]),.reg022(hi_map_r[22 ]),.reg023(hi_map_r[23 ]),.reg024(hi_map_r[24 ]),.reg025(hi_map_r[25 ]),.reg026(hi_map_r[26 ]),.reg027(hi_map_r[27 ]),.reg028(hi_map_r[28 ]),.reg029(hi_map_r[29 ]),
.reg030(hi_map_r[30 ]),.reg031(hi_map_r[31 ]),.reg032(hi_map_r[32 ]),.reg033(hi_map_r[33 ]),.reg034(hi_map_r[34 ]),.reg035(hi_map_r[35 ]),.reg036(hi_map_r[36 ]),.reg037(hi_map_r[37 ]),.reg038(hi_map_r[38 ]),.reg039(hi_map_r[39 ]),
.reg040(hi_map_r[40 ]),.reg041(hi_map_r[41 ]),.reg042(hi_map_r[42 ]),.reg043(hi_map_r[43 ]),.reg044(hi_map_r[44 ]),.reg045(hi_map_r[45 ]),.reg046(hi_map_r[46 ]),.reg047(hi_map_r[47 ]),.reg048(hi_map_r[48 ]),.reg049(hi_map_r[49 ]),
.reg050(hi_map_r[50 ]),.reg051(hi_map_r[51 ]),.reg052(hi_map_r[52 ]),.reg053(hi_map_r[53 ]),.reg054(hi_map_r[54 ]),.reg055(hi_map_r[55 ]),.reg056(hi_map_r[56 ]),.reg057(hi_map_r[57 ]),.reg058(hi_map_r[58 ]),.reg059(hi_map_r[59 ]),
.reg060(hi_map_r[60 ]),.reg061(hi_map_r[61 ]),.reg062(hi_map_r[62 ]),.reg063(hi_map_r[63 ]),.reg064(hi_map_r[64 ]),.reg065(hi_map_r[65 ]),.reg066(hi_map_r[66 ]),.reg067(hi_map_r[67 ]),.reg068(hi_map_r[68 ]),.reg069(hi_map_r[69 ]),
.reg070(hi_map_r[70 ]),.reg071(hi_map_r[71 ]),.reg072(hi_map_r[72 ]),.reg073(hi_map_r[73 ]),.reg074(hi_map_r[74 ]),.reg075(hi_map_r[75 ]),.reg076(hi_map_r[76 ]),.reg077(hi_map_r[77 ]),.reg078(hi_map_r[78 ]),.reg079(hi_map_r[79 ]),
.reg080(hi_map_r[80 ]),.reg081(hi_map_r[81 ]),.reg082(hi_map_r[82 ]),.reg083(hi_map_r[83 ]),.reg084(hi_map_r[84 ]),.reg085(hi_map_r[85 ]),.reg086(hi_map_r[86 ]),.reg087(hi_map_r[87 ]),.reg088(hi_map_r[88 ]),.reg089(hi_map_r[89 ]),
.reg090(hi_map_r[90 ]),.reg091(hi_map_r[91 ]),.reg092(hi_map_r[92 ]),.reg093(hi_map_r[93 ]),.reg094(hi_map_r[94 ]),.reg095(hi_map_r[95 ]),.reg096(hi_map_r[96 ]),.reg097(hi_map_r[97 ]),.reg098(hi_map_r[98 ]),.reg099(hi_map_r[99 ]),
.reg100(hi_map_r[100]),.reg101(hi_map_r[101]),.reg102(hi_map_r[102]),.reg103(hi_map_r[103]),.reg104(hi_map_r[104]),.reg105(hi_map_r[105]),.reg106(hi_map_r[106]),.reg107(hi_map_r[107]),.reg108(hi_map_r[108]),.reg109(hi_map_r[109]),
.reg110(hi_map_r[110]),.reg111(hi_map_r[111]),.reg112(hi_map_r[112]),.reg113(hi_map_r[113]),.reg114(hi_map_r[114]),.reg115(hi_map_r[115]),.reg116(hi_map_r[116]),.reg117(hi_map_r[117]),.reg118(hi_map_r[118]),.reg119(hi_map_r[119]),.reg120(hi_map_r[120]),
.out000(hi_map_w[0  ]),.out001(hi_map_w[1  ]),.out002(hi_map_w[2  ]),.out003(hi_map_w[3  ]),.out004(hi_map_w[4  ]),.out005(hi_map_w[5  ]),.out006(hi_map_w[6  ]),.out007(hi_map_w[7  ]),.out008(hi_map_w[8  ]),.out009(hi_map_w[9  ]),
.out010(hi_map_w[10 ]),.out011(hi_map_w[11 ]),.out012(hi_map_w[12 ]),.out013(hi_map_w[13 ]),.out014(hi_map_w[14 ]),.out015(hi_map_w[15 ]),.out016(hi_map_w[16 ]),.out017(hi_map_w[17 ]),.out018(hi_map_w[18 ]),.out019(hi_map_w[19 ]),
.out020(hi_map_w[20 ]),.out021(hi_map_w[21 ]),.out022(hi_map_w[22 ]),.out023(hi_map_w[23 ]),.out024(hi_map_w[24 ]),.out025(hi_map_w[25 ]),.out026(hi_map_w[26 ]),.out027(hi_map_w[27 ]),.out028(hi_map_w[28 ]),.out029(hi_map_w[29 ]),
.out030(hi_map_w[30 ]),.out031(hi_map_w[31 ]),.out032(hi_map_w[32 ]),.out033(hi_map_w[33 ]),.out034(hi_map_w[34 ]),.out035(hi_map_w[35 ]),.out036(hi_map_w[36 ]),.out037(hi_map_w[37 ]),.out038(hi_map_w[38 ]),.out039(hi_map_w[39 ]),
.out040(hi_map_w[40 ]),.out041(hi_map_w[41 ]),.out042(hi_map_w[42 ]),.out043(hi_map_w[43 ]),.out044(hi_map_w[44 ]),.out045(hi_map_w[45 ]),.out046(hi_map_w[46 ]),.out047(hi_map_w[47 ]),.out048(hi_map_w[48 ]),.out049(hi_map_w[49 ]),
.out050(hi_map_w[50 ]),.out051(hi_map_w[51 ]),.out052(hi_map_w[52 ]),.out053(hi_map_w[53 ]),.out054(hi_map_w[54 ]),.out055(hi_map_w[55 ]),.out056(hi_map_w[56 ]),.out057(hi_map_w[57 ]),.out058(hi_map_w[58 ]),.out059(hi_map_w[59 ]),
.out060(hi_map_w[60 ]),.out061(hi_map_w[61 ]),.out062(hi_map_w[62 ]),.out063(hi_map_w[63 ]),.out064(hi_map_w[64 ]),.out065(hi_map_w[65 ]),.out066(hi_map_w[66 ]),.out067(hi_map_w[67 ]),.out068(hi_map_w[68 ]),.out069(hi_map_w[69 ]),
.out070(hi_map_w[70 ]),.out071(hi_map_w[71 ]),.out072(hi_map_w[72 ]),.out073(hi_map_w[73 ]),.out074(hi_map_w[74 ]),.out075(hi_map_w[75 ]),.out076(hi_map_w[76 ]),.out077(hi_map_w[77 ]),.out078(hi_map_w[78 ]),.out079(hi_map_w[79 ]),
.out080(hi_map_w[80 ]),.out081(hi_map_w[81 ]),.out082(hi_map_w[82 ]),.out083(hi_map_w[83 ]),.out084(hi_map_w[84 ]),.out085(hi_map_w[85 ]),.out086(hi_map_w[86 ]),.out087(hi_map_w[87 ]),.out088(hi_map_w[88 ]),.out089(hi_map_w[89 ]),
.out090(hi_map_w[90 ]),.out091(hi_map_w[91 ]),.out092(hi_map_w[92 ]),.out093(hi_map_w[93 ]),.out094(hi_map_w[94 ]),.out095(hi_map_w[95 ]),.out096(hi_map_w[96 ]),.out097(hi_map_w[97 ]),.out098(hi_map_w[98 ]),.out099(hi_map_w[99 ]),
.out100(hi_map_w[100]),.out101(hi_map_w[101]),.out102(hi_map_w[102]),.out103(hi_map_w[103]),.out104(hi_map_w[104]),.out105(hi_map_w[105]),.out106(hi_map_w[106]),.out107(hi_map_w[107]),.out108(hi_map_w[108]),.out109(hi_map_w[109]),
.out110(hi_map_w[110]),.out111(hi_map_w[111]),.out112(hi_map_w[112]),.out113(hi_map_w[113]),.out114(hi_map_w[114]),.out115(hi_map_w[115]),.out116(hi_map_w[116]),.out117(hi_map_w[117]),.out118(hi_map_w[118]),.out119(hi_map_w[119]),.out120(hi_map_w[120])
);

sum_hi hi2sum(.en(en_sum_hi_r),.reg_sum(sum_hi_r),.out_sum(sum_hi_w),
.hi000(hi_map_r[0  ]),.hi001(hi_map_r[1  ]),.hi002(hi_map_r[2  ]),.hi003(hi_map_r[3  ]),.hi004(hi_map_r[4  ]),.hi005(hi_map_r[5  ]),.hi006(hi_map_r[6  ]),.hi007(hi_map_r[7  ]),.hi008(hi_map_r[8  ]),.hi009(hi_map_r[9  ]),
.hi010(hi_map_r[10 ]),.hi011(hi_map_r[11 ]),.hi012(hi_map_r[12 ]),.hi013(hi_map_r[13 ]),.hi014(hi_map_r[14 ]),.hi015(hi_map_r[15 ]),.hi016(hi_map_r[16 ]),.hi017(hi_map_r[17 ]),.hi018(hi_map_r[18 ]),.hi019(hi_map_r[19 ]),
.hi020(hi_map_r[20 ]),.hi021(hi_map_r[21 ]),.hi022(hi_map_r[22 ]),.hi023(hi_map_r[23 ]),.hi024(hi_map_r[24 ]),.hi025(hi_map_r[25 ]),.hi026(hi_map_r[26 ]),.hi027(hi_map_r[27 ]),.hi028(hi_map_r[28 ]),.hi029(hi_map_r[29 ]),
.hi030(hi_map_r[30 ]),.hi031(hi_map_r[31 ]),.hi032(hi_map_r[32 ]),.hi033(hi_map_r[33 ]),.hi034(hi_map_r[34 ]),.hi035(hi_map_r[35 ]),.hi036(hi_map_r[36 ]),.hi037(hi_map_r[37 ]),.hi038(hi_map_r[38 ]),.hi039(hi_map_r[39 ]),
.hi040(hi_map_r[40 ]),.hi041(hi_map_r[41 ]),.hi042(hi_map_r[42 ]),.hi043(hi_map_r[43 ]),.hi044(hi_map_r[44 ]),.hi045(hi_map_r[45 ]),.hi046(hi_map_r[46 ]),.hi047(hi_map_r[47 ]),.hi048(hi_map_r[48 ]),.hi049(hi_map_r[49 ]),
.hi050(hi_map_r[50 ]),.hi051(hi_map_r[51 ]),.hi052(hi_map_r[52 ]),.hi053(hi_map_r[53 ]),.hi054(hi_map_r[54 ]),.hi055(hi_map_r[55 ]),.hi056(hi_map_r[56 ]),.hi057(hi_map_r[57 ]),.hi058(hi_map_r[58 ]),.hi059(hi_map_r[59 ]),
.hi060(hi_map_r[60 ]),.hi061(hi_map_r[61 ]),.hi062(hi_map_r[62 ]),.hi063(hi_map_r[63 ]),.hi064(hi_map_r[64 ]),.hi065(hi_map_r[65 ]),.hi066(hi_map_r[66 ]),.hi067(hi_map_r[67 ]),.hi068(hi_map_r[68 ]),.hi069(hi_map_r[69 ]),
.hi070(hi_map_r[70 ]),.hi071(hi_map_r[71 ]),.hi072(hi_map_r[72 ]),.hi073(hi_map_r[73 ]),.hi074(hi_map_r[74 ]),.hi075(hi_map_r[75 ]),.hi076(hi_map_r[76 ]),.hi077(hi_map_r[77 ]),.hi078(hi_map_r[78 ]),.hi079(hi_map_r[79 ]),
.hi080(hi_map_r[80 ]),.hi081(hi_map_r[81 ]),.hi082(hi_map_r[82 ]),.hi083(hi_map_r[83 ]),.hi084(hi_map_r[84 ]),.hi085(hi_map_r[85 ]),.hi086(hi_map_r[86 ]),.hi087(hi_map_r[87 ]),.hi088(hi_map_r[88 ]),.hi089(hi_map_r[89 ]),
.hi090(hi_map_r[90 ]),.hi091(hi_map_r[91 ]),.hi092(hi_map_r[92 ]),.hi093(hi_map_r[93 ]),.hi094(hi_map_r[94 ]),.hi095(hi_map_r[95 ]),.hi096(hi_map_r[96 ]),.hi097(hi_map_r[97 ]),.hi098(hi_map_r[98 ]),.hi099(hi_map_r[99 ]),
.hi100(hi_map_r[100]),.hi101(hi_map_r[101]),.hi102(hi_map_r[102]),.hi103(hi_map_r[103]),.hi104(hi_map_r[104]),.hi105(hi_map_r[105]),.hi106(hi_map_r[106]),.hi107(hi_map_r[107]),.hi108(hi_map_r[108]),.hi109(hi_map_r[109]),
.hi110(hi_map_r[110]),.hi111(hi_map_r[111]),.hi112(hi_map_r[112]),.hi113(hi_map_r[113]),.hi114(hi_map_r[114]),.hi115(hi_map_r[115]),.hi116(hi_map_r[116]),.hi117(hi_map_r[117]),.hi118(hi_map_r[118]),.hi119(hi_map_r[119]),.hi120(hi_map_r[120])
);


endmodule