// Output SNR ≥ 40 dB (test pattern provided)
// Latency ~= 70k cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process

`include "mul_gi.v"
`include "mul_ghi.v"

`include "mul_h.v"
`include "mul_gh.v"

`include "sum_ghi.v"
`include "sum_gh.v"
`include "div_ghi_gh.v"

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

reg  [2:0]  state_r;
reg  [2:0]  state_w;
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


reg  [7:0]  mapi_r[0:120];      // 8bit  int + 0bit  frac
reg  [7:0]  mapi_w[0:120];      // 8bit  int + 0bit  frac
reg  [7:0]  in_buffer_r[0:10];  // 8bit  int + 0bit  frac
reg  [7:0]  in_buffer_w[0:10];  // 8bit  int + 0bit  frac

// reg         en_g_map_r      ,en_g_map_w;
reg         en_ghi_map_r    ,en_ghi_map_w;
reg         en_sum_ghi_r    ,en_sum_ghi_w;

reg  [13:0] g_map_r[0:120];     // 8bit  int + 6bit  frac
reg  [14:0] g_map_w[0:120];     // 8bit  int + 6bit  frac
reg  [19:0] ghi_map_r[0:120];   // 8bit  int + 12bit frac
wire [20:0] ghi_map_w[0:120];   // 8bit  int + 12bit frac
reg  [26:0] sum_ghi_r;          // 15bit int + 12bit frac 
wire [26:0] sum_ghi_w;          // 15bit int + 12bit frac 

reg         en_i_i0_map_r   ,en_i_i0_map_w;
reg         en_h_map_r      ,en_h_map_w;
// reg         en_gh_map_r     ,en_gh_map_w;
reg         en_sum_gh_r     ,en_sum_gh_w;


reg  [7:0]  i_i0_map_w[0:120];  // 8bit  int + 0bit  frac
reg  [6:0]  h_map_r[0:120];     // 1bit  int + 6bit  frac
wire [6:0]  h_map_w[0:120];     // 1bit  int + 6bit  frac
reg  [12:0] gh_map_r[0:120];    // 1bit  int + 12bit frac
reg  [13:0] gh_map_w[0:120];    // 1bit  int + 12bit frac
reg  [19:0] sum_gh_r;           // 8bit  int + 12bit frac
wire [19:0] sum_gh_w;           // 8bit  int + 12bit frac

reg         en_div_r,en_div_w;

reg  [8:0]  div_out_r;  // 8bit int + 1bit frac
wire [53:0] div_out_w;  // 36bit int + 33bit frac //[68:0]
reg  [26:0] div_x_r;    // 1bit int + (20+6)bit frac
wire [46:0] div_x_w;    // 21bit int + 26bit frac
// wire [73:0] div_x_w;    // 22bit int + 52bit frac


// wire        en_gigh_r; 
reg         en_gigh_r; 
reg         en_gigh_w; 
wire [7:0]  gigh_n[0:120]; //mapi_r[i]
wire [13:0] gigh_reg[0:120];//g_map_r[i]
wire [14:0] gigh_out[0:120];//g_map_w[i]


integer i;

parameter START  =0;
parameter LEFT   =1;
parameter MID    =2;
parameter RIGHT  =3;
parameter ENDING =4;

assign in_addr  = { row_cntr_r    , col_cntr_r };

always@(*) begin
    state_w         = state_r;
    sub_state_w     = sub_state_r;
    
    addr_mapi_w     = addr_mapi_r;
    col_cntr_w      = col_cntr_r;
    row_cntr_w      = row_cntr_r;
    px_row_cntr_w   = px_row_cntr_w;
    px_col_cntr_w   = px_col_cntr_w;
    
    // en_g_map_w      = en_g_map_r;
    en_ghi_map_w    = en_ghi_map_r;
    en_sum_ghi_w    = en_sum_ghi_r;

    en_i_i0_map_w   = en_i_i0_map_r;
    en_h_map_w      = en_h_map_r;
    // en_gh_map_w     = en_gh_map_r;
    en_sum_gh_w     = en_sum_gh_r;

    en_div_w        = en_div_r;
    en_gigh_w       = en_gigh_r;

    out_valid_w     = out_valid;
    out_addr_w      = { px_row_cntr_r , px_col_cntr_r };
    out_data_w      = out_data;
    finish_w        = finish;
    
    for(i=0;i<121;i=i+1) begin
        mapi_w[i]     = mapi_r[i];
        g_map_w[i]    = g_map_r[i];
        gh_map_w[i]   = gh_map_r[i];
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

        // en_g_map_w      = 1;
        // en_ghi_map_w    = 1;
        // en_sum_ghi_w    = 1;
        
        // en_i_i0_map_w   = 1;
        // en_h_map_w      = 1;
        // en_gh_map_w     = 1;
        // en_sum_gh_w     = 1;

        // en_div_w        = 1;
        // en_gigh_w       = 1;
    end
    
    LEFT: begin
        if(in_valid) begin
            mapi_w[addr_mapi_r]   = in_data;
            addr_mapi_w           = (addr_mapi_r==120)?110:addr_mapi_r+1;
            
            row_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? px_row_cntr_r-5 : row_cntr_r+1;
            col_cntr_w    = (row_cntr_r==px_row_cntr_r+5) ? col_cntr_r+1    : col_cntr_r;
            
            if(col_cntr_r==px_col_cntr_r+5 && row_cntr_r==px_row_cntr_r+5) begin
                state_w = MID;
                sub_state_w = 0;
                // en_g_map_w    = 1;
                en_gigh_w     = 1;
                en_i_i0_map_w = 1;
                en_h_map_w    = 1;
            end
        end
    end
    
    MID: begin
        if(in_valid) begin
            addr_mapi_w   = (addr_mapi_r==120)?110:addr_mapi_r+1;
            
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
        0: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
            out_valid_w = 0;
            en_i_i0_map_w = 0;
            // en_g_map_w    = 0;
            en_h_map_w    = 0;
            // en_gh_map_w   = 1;
            en_gigh_w     = 1;
            en_ghi_map_w  = 1;
            for(i=0;i<121;i=i+1) begin
                g_map_w[i] = gigh_out[i]; //gigh_out[0]  =(sub_state_r==0)? g_map_w[0]   : {1'b0, gh_map_w[0]};
            end
        end
        1: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
            // en_gh_map_w  = 0;
            en_ghi_map_w = 0;
            en_gigh_w    = 0;
            en_sum_ghi_w = 1;
            en_sum_gh_w  = 1;
            for(i=0;i<121;i=i+1) begin
                gh_map_w[i] = gigh_out[i][13:0]; //gigh_out[0]  =(sub_state_r==0)? g_map_w[0]   : {1'b0, gh_map_w[0]};
            end
        end
        2: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
            en_sum_ghi_w = 0;
            en_sum_gh_w  = 0;
            en_div_w     = 1;
        end
        3: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
        end
        4: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
        end
        5,6,7,8: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
        end
        9: begin
            sub_state_w = sub_state_r+1;
            in_buffer_w[sub_state_r] = in_data;
        end
        10: begin
            sub_state_w = 0;
            in_buffer_w[sub_state_r] = in_data;
            // en_g_map_w    = 1;
            en_div_w      = 0;
            en_gigh_w     = 1;
            en_i_i0_map_w = 1;
            en_h_map_w    = 1;

            mapi_w[sub_state_r+110]   = in_data;
            for(i=0;i<110;i=i+1) mapi_w[i] = mapi_r[i+11];
            for(i=0;i<10;i=i+1)  mapi_w[i+110] = in_buffer_r[i];
            out_valid_w = 1;
            out_data_w = div_out_w[34:26];
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
        
        // en_g_map_r      <= 0;
        en_ghi_map_r    <= 0;
        en_sum_ghi_r    <= 0;
        
        en_i_i0_map_r   <= 0;
        en_h_map_r      <= 0;
        // en_gh_map_r     <= 0;
        en_sum_gh_r     <= 0;

        en_div_r        <= 0;
        en_gigh_r       <= 0;

        sum_ghi_r       <= 0;
        sum_gh_r        <= 0;
        div_out_r       <= 0;
        div_x_r         <= 0;
        
        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= 0;
            g_map_r[i]    <= 0;
            ghi_map_r[i]  <= 0;

            h_map_r[i]    <= 0;
            gh_map_r[i]   <= 0;
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
        
        // en_g_map_r      <= en_g_map_w;
        en_ghi_map_r    <= en_ghi_map_w;
        en_sum_ghi_r    <= en_sum_ghi_w;
        
        en_i_i0_map_r   <= en_i_i0_map_w;
        en_h_map_r      <= en_h_map_w;
        // en_gh_map_r     <= en_gh_map_w;
        en_sum_gh_r     <= en_sum_gh_w;

        en_div_r        <= en_div_w;
        en_gigh_r       <= en_gigh_w;

        sum_ghi_r       <= sum_ghi_w;
        sum_gh_r        <= sum_gh_w;
        div_x_r         <= div_x_w[26:0];
        div_out_r       <= div_out_w[33:25];

        if(en_ghi_map_r) begin
            for(i=0;i<121;i=i+1) begin
                ghi_map_r[i]  <= ghi_map_w[i][19:0]; //[27:0]
            end
        end
        if(en_h_map_r) begin
            for(i=0;i<121;i=i+1) begin
                h_map_r[i]    <= h_map_w[i];
            end
        end
        if(en_gigh_r) begin
            for(i=0;i<121;i=i+1) begin
                g_map_r[i]    <= g_map_w[i][13:0];
                gh_map_r[i]   <= gh_map_w[i][12:0]; //[19:0]
            end
        end

        for(i=0;i<121;i=i+1) begin
            mapi_r[i]    <= mapi_w[i];
            //g_map_r[i]    <= g_map_w[i][13:0];
            //ghi_map_r[i]  <= ghi_map_w[i][19:0]; //[27:0]
            //h_map_r[i]    <= h_map_w[i];
            //gh_map_r[i]   <= gh_map_w[i][12:0]; //[19:0]
        end
        for(i=0;i<11;i=i+1) begin
            in_buffer_r[i] <= in_buffer_w[i];
        end
    end
end

// ---------------------------------------------
// ---------------------------------------------
// ---------------------------------------------

div_ghi_gh sum2out( .en(en_div_r),
    .clk(clk),.rst(rst),
    .sub_state_r(sub_state_r),
    .sum_ghi(sum_ghi_r),
    .N(sum_gh_r),
    .reg_div(div_out_r),
    .out_div(div_out_w),
    .reg_x(div_x_r),
    .out_x(div_x_w)
);

// assign en_gigh_r    =(sub_state_r==0)? en_g_map_r   : en_gh_map_r;

genvar ii;
generate
for (ii=0;ii<121;ii=ii+1) begin : GHGI_GEN
    assign gigh_n[ii]    =(sub_state_r==0)? mapi_r[ii]    : {1'b0, h_map_r[ii] };
    assign gigh_reg[ii]  =(sub_state_r==0)? g_map_r[ii]   : {1'b0, gh_map_r[ii]};
end
endgenerate

mul_gi i2gi_h2gh(.en(en_gigh_r),
.i000_n(gigh_n[0  ]),.i001_n(gigh_n[1  ]),.i002_n(gigh_n[2  ]),.i003_n(gigh_n[3  ]),.i004_n(gigh_n[4  ]),.i005_n(gigh_n[5  ]),.i006_n(gigh_n[6  ]),.i007_n(gigh_n[7  ]),.i008_n(gigh_n[8  ]),.i009_n(gigh_n[9  ]),
.i010_n(gigh_n[10 ]),.i011_n(gigh_n[11 ]),.i012_n(gigh_n[12 ]),.i013_n(gigh_n[13 ]),.i014_n(gigh_n[14 ]),.i015_n(gigh_n[15 ]),.i016_n(gigh_n[16 ]),.i017_n(gigh_n[17 ]),.i018_n(gigh_n[18 ]),.i019_n(gigh_n[19 ]),
.i020_n(gigh_n[20 ]),.i021_n(gigh_n[21 ]),.i022_n(gigh_n[22 ]),.i023_n(gigh_n[23 ]),.i024_n(gigh_n[24 ]),.i025_n(gigh_n[25 ]),.i026_n(gigh_n[26 ]),.i027_n(gigh_n[27 ]),.i028_n(gigh_n[28 ]),.i029_n(gigh_n[29 ]),
.i030_n(gigh_n[30 ]),.i031_n(gigh_n[31 ]),.i032_n(gigh_n[32 ]),.i033_n(gigh_n[33 ]),.i034_n(gigh_n[34 ]),.i035_n(gigh_n[35 ]),.i036_n(gigh_n[36 ]),.i037_n(gigh_n[37 ]),.i038_n(gigh_n[38 ]),.i039_n(gigh_n[39 ]),
.i040_n(gigh_n[40 ]),.i041_n(gigh_n[41 ]),.i042_n(gigh_n[42 ]),.i043_n(gigh_n[43 ]),.i044_n(gigh_n[44 ]),.i045_n(gigh_n[45 ]),.i046_n(gigh_n[46 ]),.i047_n(gigh_n[47 ]),.i048_n(gigh_n[48 ]),.i049_n(gigh_n[49 ]),
.i050_n(gigh_n[50 ]),.i051_n(gigh_n[51 ]),.i052_n(gigh_n[52 ]),.i053_n(gigh_n[53 ]),.i054_n(gigh_n[54 ]),.i055_n(gigh_n[55 ]),.i056_n(gigh_n[56 ]),.i057_n(gigh_n[57 ]),.i058_n(gigh_n[58 ]),.i059_n(gigh_n[59 ]),
.i060_n(gigh_n[60 ]),.i061_n(gigh_n[61 ]),.i062_n(gigh_n[62 ]),.i063_n(gigh_n[63 ]),.i064_n(gigh_n[64 ]),.i065_n(gigh_n[65 ]),.i066_n(gigh_n[66 ]),.i067_n(gigh_n[67 ]),.i068_n(gigh_n[68 ]),.i069_n(gigh_n[69 ]),
.i070_n(gigh_n[70 ]),.i071_n(gigh_n[71 ]),.i072_n(gigh_n[72 ]),.i073_n(gigh_n[73 ]),.i074_n(gigh_n[74 ]),.i075_n(gigh_n[75 ]),.i076_n(gigh_n[76 ]),.i077_n(gigh_n[77 ]),.i078_n(gigh_n[78 ]),.i079_n(gigh_n[79 ]),
.i080_n(gigh_n[80 ]),.i081_n(gigh_n[81 ]),.i082_n(gigh_n[82 ]),.i083_n(gigh_n[83 ]),.i084_n(gigh_n[84 ]),.i085_n(gigh_n[85 ]),.i086_n(gigh_n[86 ]),.i087_n(gigh_n[87 ]),.i088_n(gigh_n[88 ]),.i089_n(gigh_n[89 ]),
.i090_n(gigh_n[90 ]),.i091_n(gigh_n[91 ]),.i092_n(gigh_n[92 ]),.i093_n(gigh_n[93 ]),.i094_n(gigh_n[94 ]),.i095_n(gigh_n[95 ]),.i096_n(gigh_n[96 ]),.i097_n(gigh_n[97 ]),.i098_n(gigh_n[98 ]),.i099_n(gigh_n[99 ]),
.i100_n(gigh_n[100]),.i101_n(gigh_n[101]),.i102_n(gigh_n[102]),.i103_n(gigh_n[103]),.i104_n(gigh_n[104]),.i105_n(gigh_n[105]),.i106_n(gigh_n[106]),.i107_n(gigh_n[107]),.i108_n(gigh_n[108]),.i109_n(gigh_n[109]),
.i110_n(gigh_n[110]),.i111_n(gigh_n[111]),.i112_n(gigh_n[112]),.i113_n(gigh_n[113]),.i114_n(gigh_n[114]),.i115_n(gigh_n[115]),.i116_n(gigh_n[116]),.i117_n(gigh_n[117]),.i118_n(gigh_n[118]),.i119_n(gigh_n[119]),.i120_n(gigh_n[120]),
.reg000(gigh_reg[0  ]),.reg001(gigh_reg[1  ]),.reg002(gigh_reg[2  ]),.reg003(gigh_reg[3  ]),.reg004(gigh_reg[4  ]),.reg005(gigh_reg[5  ]),.reg006(gigh_reg[6  ]),.reg007(gigh_reg[7  ]),.reg008(gigh_reg[8  ]),.reg009(gigh_reg[9  ]),
.reg010(gigh_reg[10 ]),.reg011(gigh_reg[11 ]),.reg012(gigh_reg[12 ]),.reg013(gigh_reg[13 ]),.reg014(gigh_reg[14 ]),.reg015(gigh_reg[15 ]),.reg016(gigh_reg[16 ]),.reg017(gigh_reg[17 ]),.reg018(gigh_reg[18 ]),.reg019(gigh_reg[19 ]),
.reg020(gigh_reg[20 ]),.reg021(gigh_reg[21 ]),.reg022(gigh_reg[22 ]),.reg023(gigh_reg[23 ]),.reg024(gigh_reg[24 ]),.reg025(gigh_reg[25 ]),.reg026(gigh_reg[26 ]),.reg027(gigh_reg[27 ]),.reg028(gigh_reg[28 ]),.reg029(gigh_reg[29 ]),
.reg030(gigh_reg[30 ]),.reg031(gigh_reg[31 ]),.reg032(gigh_reg[32 ]),.reg033(gigh_reg[33 ]),.reg034(gigh_reg[34 ]),.reg035(gigh_reg[35 ]),.reg036(gigh_reg[36 ]),.reg037(gigh_reg[37 ]),.reg038(gigh_reg[38 ]),.reg039(gigh_reg[39 ]),
.reg040(gigh_reg[40 ]),.reg041(gigh_reg[41 ]),.reg042(gigh_reg[42 ]),.reg043(gigh_reg[43 ]),.reg044(gigh_reg[44 ]),.reg045(gigh_reg[45 ]),.reg046(gigh_reg[46 ]),.reg047(gigh_reg[47 ]),.reg048(gigh_reg[48 ]),.reg049(gigh_reg[49 ]),
.reg050(gigh_reg[50 ]),.reg051(gigh_reg[51 ]),.reg052(gigh_reg[52 ]),.reg053(gigh_reg[53 ]),.reg054(gigh_reg[54 ]),.reg055(gigh_reg[55 ]),.reg056(gigh_reg[56 ]),.reg057(gigh_reg[57 ]),.reg058(gigh_reg[58 ]),.reg059(gigh_reg[59 ]),
.reg060(gigh_reg[60 ]),.reg061(gigh_reg[61 ]),.reg062(gigh_reg[62 ]),.reg063(gigh_reg[63 ]),.reg064(gigh_reg[64 ]),.reg065(gigh_reg[65 ]),.reg066(gigh_reg[66 ]),.reg067(gigh_reg[67 ]),.reg068(gigh_reg[68 ]),.reg069(gigh_reg[69 ]),
.reg070(gigh_reg[70 ]),.reg071(gigh_reg[71 ]),.reg072(gigh_reg[72 ]),.reg073(gigh_reg[73 ]),.reg074(gigh_reg[74 ]),.reg075(gigh_reg[75 ]),.reg076(gigh_reg[76 ]),.reg077(gigh_reg[77 ]),.reg078(gigh_reg[78 ]),.reg079(gigh_reg[79 ]),
.reg080(gigh_reg[80 ]),.reg081(gigh_reg[81 ]),.reg082(gigh_reg[82 ]),.reg083(gigh_reg[83 ]),.reg084(gigh_reg[84 ]),.reg085(gigh_reg[85 ]),.reg086(gigh_reg[86 ]),.reg087(gigh_reg[87 ]),.reg088(gigh_reg[88 ]),.reg089(gigh_reg[89 ]),
.reg090(gigh_reg[90 ]),.reg091(gigh_reg[91 ]),.reg092(gigh_reg[92 ]),.reg093(gigh_reg[93 ]),.reg094(gigh_reg[94 ]),.reg095(gigh_reg[95 ]),.reg096(gigh_reg[96 ]),.reg097(gigh_reg[97 ]),.reg098(gigh_reg[98 ]),.reg099(gigh_reg[99 ]),
.reg100(gigh_reg[100]),.reg101(gigh_reg[101]),.reg102(gigh_reg[102]),.reg103(gigh_reg[103]),.reg104(gigh_reg[104]),.reg105(gigh_reg[105]),.reg106(gigh_reg[106]),.reg107(gigh_reg[107]),.reg108(gigh_reg[108]),.reg109(gigh_reg[109]),
.reg110(gigh_reg[110]),.reg111(gigh_reg[111]),.reg112(gigh_reg[112]),.reg113(gigh_reg[113]),.reg114(gigh_reg[114]),.reg115(gigh_reg[115]),.reg116(gigh_reg[116]),.reg117(gigh_reg[117]),.reg118(gigh_reg[118]),.reg119(gigh_reg[119]),.reg120(gigh_reg[120]),
.out000(gigh_out[0  ]),.out001(gigh_out[1  ]),.out002(gigh_out[2  ]),.out003(gigh_out[3  ]),.out004(gigh_out[4  ]),.out005(gigh_out[5  ]),.out006(gigh_out[6  ]),.out007(gigh_out[7  ]),.out008(gigh_out[8  ]),.out009(gigh_out[9  ]),
.out010(gigh_out[10 ]),.out011(gigh_out[11 ]),.out012(gigh_out[12 ]),.out013(gigh_out[13 ]),.out014(gigh_out[14 ]),.out015(gigh_out[15 ]),.out016(gigh_out[16 ]),.out017(gigh_out[17 ]),.out018(gigh_out[18 ]),.out019(gigh_out[19 ]),
.out020(gigh_out[20 ]),.out021(gigh_out[21 ]),.out022(gigh_out[22 ]),.out023(gigh_out[23 ]),.out024(gigh_out[24 ]),.out025(gigh_out[25 ]),.out026(gigh_out[26 ]),.out027(gigh_out[27 ]),.out028(gigh_out[28 ]),.out029(gigh_out[29 ]),
.out030(gigh_out[30 ]),.out031(gigh_out[31 ]),.out032(gigh_out[32 ]),.out033(gigh_out[33 ]),.out034(gigh_out[34 ]),.out035(gigh_out[35 ]),.out036(gigh_out[36 ]),.out037(gigh_out[37 ]),.out038(gigh_out[38 ]),.out039(gigh_out[39 ]),
.out040(gigh_out[40 ]),.out041(gigh_out[41 ]),.out042(gigh_out[42 ]),.out043(gigh_out[43 ]),.out044(gigh_out[44 ]),.out045(gigh_out[45 ]),.out046(gigh_out[46 ]),.out047(gigh_out[47 ]),.out048(gigh_out[48 ]),.out049(gigh_out[49 ]),
.out050(gigh_out[50 ]),.out051(gigh_out[51 ]),.out052(gigh_out[52 ]),.out053(gigh_out[53 ]),.out054(gigh_out[54 ]),.out055(gigh_out[55 ]),.out056(gigh_out[56 ]),.out057(gigh_out[57 ]),.out058(gigh_out[58 ]),.out059(gigh_out[59 ]),
.out060(gigh_out[60 ]),.out061(gigh_out[61 ]),.out062(gigh_out[62 ]),.out063(gigh_out[63 ]),.out064(gigh_out[64 ]),.out065(gigh_out[65 ]),.out066(gigh_out[66 ]),.out067(gigh_out[67 ]),.out068(gigh_out[68 ]),.out069(gigh_out[69 ]),
.out070(gigh_out[70 ]),.out071(gigh_out[71 ]),.out072(gigh_out[72 ]),.out073(gigh_out[73 ]),.out074(gigh_out[74 ]),.out075(gigh_out[75 ]),.out076(gigh_out[76 ]),.out077(gigh_out[77 ]),.out078(gigh_out[78 ]),.out079(gigh_out[79 ]),
.out080(gigh_out[80 ]),.out081(gigh_out[81 ]),.out082(gigh_out[82 ]),.out083(gigh_out[83 ]),.out084(gigh_out[84 ]),.out085(gigh_out[85 ]),.out086(gigh_out[86 ]),.out087(gigh_out[87 ]),.out088(gigh_out[88 ]),.out089(gigh_out[89 ]),
.out090(gigh_out[90 ]),.out091(gigh_out[91 ]),.out092(gigh_out[92 ]),.out093(gigh_out[93 ]),.out094(gigh_out[94 ]),.out095(gigh_out[95 ]),.out096(gigh_out[96 ]),.out097(gigh_out[97 ]),.out098(gigh_out[98 ]),.out099(gigh_out[99 ]),
.out100(gigh_out[100]),.out101(gigh_out[101]),.out102(gigh_out[102]),.out103(gigh_out[103]),.out104(gigh_out[104]),.out105(gigh_out[105]),.out106(gigh_out[106]),.out107(gigh_out[107]),.out108(gigh_out[108]),.out109(gigh_out[109]),
.out110(gigh_out[110]),.out111(gigh_out[111]),.out112(gigh_out[112]),.out113(gigh_out[113]),.out114(gigh_out[114]),.out115(gigh_out[115]),.out116(gigh_out[116]),.out117(gigh_out[117]),.out118(gigh_out[118]),.out119(gigh_out[119]),.out120(gigh_out[120])
);

// ---------------------------------------------
// ---------------------------------------------
// ---------------------------------------------

mul_ghi gi2ghi(.en(en_ghi_map_r),
.i000_gi(g_map_r[0  ]),.i001_gi(g_map_r[1  ]),.i002_gi(g_map_r[2  ]),.i003_gi(g_map_r[3  ]),.i004_gi(g_map_r[4  ]),.i005_gi(g_map_r[5  ]),.i006_gi(g_map_r[6  ]),.i007_gi(g_map_r[7  ]),.i008_gi(g_map_r[8  ]),.i009_gi(g_map_r[9  ]),
.i010_gi(g_map_r[10 ]),.i011_gi(g_map_r[11 ]),.i012_gi(g_map_r[12 ]),.i013_gi(g_map_r[13 ]),.i014_gi(g_map_r[14 ]),.i015_gi(g_map_r[15 ]),.i016_gi(g_map_r[16 ]),.i017_gi(g_map_r[17 ]),.i018_gi(g_map_r[18 ]),.i019_gi(g_map_r[19 ]),
.i020_gi(g_map_r[20 ]),.i021_gi(g_map_r[21 ]),.i022_gi(g_map_r[22 ]),.i023_gi(g_map_r[23 ]),.i024_gi(g_map_r[24 ]),.i025_gi(g_map_r[25 ]),.i026_gi(g_map_r[26 ]),.i027_gi(g_map_r[27 ]),.i028_gi(g_map_r[28 ]),.i029_gi(g_map_r[29 ]),
.i030_gi(g_map_r[30 ]),.i031_gi(g_map_r[31 ]),.i032_gi(g_map_r[32 ]),.i033_gi(g_map_r[33 ]),.i034_gi(g_map_r[34 ]),.i035_gi(g_map_r[35 ]),.i036_gi(g_map_r[36 ]),.i037_gi(g_map_r[37 ]),.i038_gi(g_map_r[38 ]),.i039_gi(g_map_r[39 ]),
.i040_gi(g_map_r[40 ]),.i041_gi(g_map_r[41 ]),.i042_gi(g_map_r[42 ]),.i043_gi(g_map_r[43 ]),.i044_gi(g_map_r[44 ]),.i045_gi(g_map_r[45 ]),.i046_gi(g_map_r[46 ]),.i047_gi(g_map_r[47 ]),.i048_gi(g_map_r[48 ]),.i049_gi(g_map_r[49 ]),
.i050_gi(g_map_r[50 ]),.i051_gi(g_map_r[51 ]),.i052_gi(g_map_r[52 ]),.i053_gi(g_map_r[53 ]),.i054_gi(g_map_r[54 ]),.i055_gi(g_map_r[55 ]),.i056_gi(g_map_r[56 ]),.i057_gi(g_map_r[57 ]),.i058_gi(g_map_r[58 ]),.i059_gi(g_map_r[59 ]),
.i060_gi(g_map_r[60 ]),.i061_gi(g_map_r[61 ]),.i062_gi(g_map_r[62 ]),.i063_gi(g_map_r[63 ]),.i064_gi(g_map_r[64 ]),.i065_gi(g_map_r[65 ]),.i066_gi(g_map_r[66 ]),.i067_gi(g_map_r[67 ]),.i068_gi(g_map_r[68 ]),.i069_gi(g_map_r[69 ]),
.i070_gi(g_map_r[70 ]),.i071_gi(g_map_r[71 ]),.i072_gi(g_map_r[72 ]),.i073_gi(g_map_r[73 ]),.i074_gi(g_map_r[74 ]),.i075_gi(g_map_r[75 ]),.i076_gi(g_map_r[76 ]),.i077_gi(g_map_r[77 ]),.i078_gi(g_map_r[78 ]),.i079_gi(g_map_r[79 ]),
.i080_gi(g_map_r[80 ]),.i081_gi(g_map_r[81 ]),.i082_gi(g_map_r[82 ]),.i083_gi(g_map_r[83 ]),.i084_gi(g_map_r[84 ]),.i085_gi(g_map_r[85 ]),.i086_gi(g_map_r[86 ]),.i087_gi(g_map_r[87 ]),.i088_gi(g_map_r[88 ]),.i089_gi(g_map_r[89 ]),
.i090_gi(g_map_r[90 ]),.i091_gi(g_map_r[91 ]),.i092_gi(g_map_r[92 ]),.i093_gi(g_map_r[93 ]),.i094_gi(g_map_r[94 ]),.i095_gi(g_map_r[95 ]),.i096_gi(g_map_r[96 ]),.i097_gi(g_map_r[97 ]),.i098_gi(g_map_r[98 ]),.i099_gi(g_map_r[99 ]),
.i100_gi(g_map_r[100]),.i101_gi(g_map_r[101]),.i102_gi(g_map_r[102]),.i103_gi(g_map_r[103]),.i104_gi(g_map_r[104]),.i105_gi(g_map_r[105]),.i106_gi(g_map_r[106]),.i107_gi(g_map_r[107]),.i108_gi(g_map_r[108]),.i109_gi(g_map_r[109]),
.i110_gi(g_map_r[110]),.i111_gi(g_map_r[111]),.i112_gi(g_map_r[112]),.i113_gi(g_map_r[113]),.i114_gi(g_map_r[114]),.i115_gi(g_map_r[115]),.i116_gi(g_map_r[116]),.i117_gi(g_map_r[117]),.i118_gi(g_map_r[118]),.i119_gi(g_map_r[119]),.i120_gi(g_map_r[120]),
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
.i000_n(i_i0_map_w[0  ]),.i001_n(i_i0_map_w[1  ]),.i002_n(i_i0_map_w[2  ]),.i003_n(i_i0_map_w[3  ]),.i004_n(i_i0_map_w[4  ]),.i005_n(i_i0_map_w[5  ]),.i006_n(i_i0_map_w[6  ]),.i007_n(i_i0_map_w[7  ]),.i008_n(i_i0_map_w[8  ]),.i009_n(i_i0_map_w[9  ]),
.i010_n(i_i0_map_w[10 ]),.i011_n(i_i0_map_w[11 ]),.i012_n(i_i0_map_w[12 ]),.i013_n(i_i0_map_w[13 ]),.i014_n(i_i0_map_w[14 ]),.i015_n(i_i0_map_w[15 ]),.i016_n(i_i0_map_w[16 ]),.i017_n(i_i0_map_w[17 ]),.i018_n(i_i0_map_w[18 ]),.i019_n(i_i0_map_w[19 ]),
.i020_n(i_i0_map_w[20 ]),.i021_n(i_i0_map_w[21 ]),.i022_n(i_i0_map_w[22 ]),.i023_n(i_i0_map_w[23 ]),.i024_n(i_i0_map_w[24 ]),.i025_n(i_i0_map_w[25 ]),.i026_n(i_i0_map_w[26 ]),.i027_n(i_i0_map_w[27 ]),.i028_n(i_i0_map_w[28 ]),.i029_n(i_i0_map_w[29 ]),
.i030_n(i_i0_map_w[30 ]),.i031_n(i_i0_map_w[31 ]),.i032_n(i_i0_map_w[32 ]),.i033_n(i_i0_map_w[33 ]),.i034_n(i_i0_map_w[34 ]),.i035_n(i_i0_map_w[35 ]),.i036_n(i_i0_map_w[36 ]),.i037_n(i_i0_map_w[37 ]),.i038_n(i_i0_map_w[38 ]),.i039_n(i_i0_map_w[39 ]),
.i040_n(i_i0_map_w[40 ]),.i041_n(i_i0_map_w[41 ]),.i042_n(i_i0_map_w[42 ]),.i043_n(i_i0_map_w[43 ]),.i044_n(i_i0_map_w[44 ]),.i045_n(i_i0_map_w[45 ]),.i046_n(i_i0_map_w[46 ]),.i047_n(i_i0_map_w[47 ]),.i048_n(i_i0_map_w[48 ]),.i049_n(i_i0_map_w[49 ]),
.i050_n(i_i0_map_w[50 ]),.i051_n(i_i0_map_w[51 ]),.i052_n(i_i0_map_w[52 ]),.i053_n(i_i0_map_w[53 ]),.i054_n(i_i0_map_w[54 ]),.i055_n(i_i0_map_w[55 ]),.i056_n(i_i0_map_w[56 ]),.i057_n(i_i0_map_w[57 ]),.i058_n(i_i0_map_w[58 ]),.i059_n(i_i0_map_w[59 ]),
.i060_n(i_i0_map_w[60 ]),.i061_n(i_i0_map_w[61 ]),.i062_n(i_i0_map_w[62 ]),.i063_n(i_i0_map_w[63 ]),.i064_n(i_i0_map_w[64 ]),.i065_n(i_i0_map_w[65 ]),.i066_n(i_i0_map_w[66 ]),.i067_n(i_i0_map_w[67 ]),.i068_n(i_i0_map_w[68 ]),.i069_n(i_i0_map_w[69 ]),
.i070_n(i_i0_map_w[70 ]),.i071_n(i_i0_map_w[71 ]),.i072_n(i_i0_map_w[72 ]),.i073_n(i_i0_map_w[73 ]),.i074_n(i_i0_map_w[74 ]),.i075_n(i_i0_map_w[75 ]),.i076_n(i_i0_map_w[76 ]),.i077_n(i_i0_map_w[77 ]),.i078_n(i_i0_map_w[78 ]),.i079_n(i_i0_map_w[79 ]),
.i080_n(i_i0_map_w[80 ]),.i081_n(i_i0_map_w[81 ]),.i082_n(i_i0_map_w[82 ]),.i083_n(i_i0_map_w[83 ]),.i084_n(i_i0_map_w[84 ]),.i085_n(i_i0_map_w[85 ]),.i086_n(i_i0_map_w[86 ]),.i087_n(i_i0_map_w[87 ]),.i088_n(i_i0_map_w[88 ]),.i089_n(i_i0_map_w[89 ]),
.i090_n(i_i0_map_w[90 ]),.i091_n(i_i0_map_w[91 ]),.i092_n(i_i0_map_w[92 ]),.i093_n(i_i0_map_w[93 ]),.i094_n(i_i0_map_w[94 ]),.i095_n(i_i0_map_w[95 ]),.i096_n(i_i0_map_w[96 ]),.i097_n(i_i0_map_w[97 ]),.i098_n(i_i0_map_w[98 ]),.i099_n(i_i0_map_w[99 ]),
.i100_n(i_i0_map_w[100]),.i101_n(i_i0_map_w[101]),.i102_n(i_i0_map_w[102]),.i103_n(i_i0_map_w[103]),.i104_n(i_i0_map_w[104]),.i105_n(i_i0_map_w[105]),.i106_n(i_i0_map_w[106]),.i107_n(i_i0_map_w[107]),.i108_n(i_i0_map_w[108]),.i109_n(i_i0_map_w[109]),
.i110_n(i_i0_map_w[110]),.i111_n(i_i0_map_w[111]),.i112_n(i_i0_map_w[112]),.i113_n(i_i0_map_w[113]),.i114_n(i_i0_map_w[114]),.i115_n(i_i0_map_w[115]),.i116_n(i_i0_map_w[116]),.i117_n(i_i0_map_w[117]),.i118_n(i_i0_map_w[118]),.i119_n(i_i0_map_w[119]),.i120_n(i_i0_map_w[120]),
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

sum_gh gh2sum(.en(en_sum_gh_r),.reg_sum(sum_gh_r),.out_sum(sum_gh_w),
.gh000(gh_map_r[0  ]),.gh001(gh_map_r[1  ]),.gh002(gh_map_r[2  ]),.gh003(gh_map_r[3  ]),.gh004(gh_map_r[4  ]),.gh005(gh_map_r[5  ]),.gh006(gh_map_r[6  ]),.gh007(gh_map_r[7  ]),.gh008(gh_map_r[8  ]),.gh009(gh_map_r[9  ]),
.gh010(gh_map_r[10 ]),.gh011(gh_map_r[11 ]),.gh012(gh_map_r[12 ]),.gh013(gh_map_r[13 ]),.gh014(gh_map_r[14 ]),.gh015(gh_map_r[15 ]),.gh016(gh_map_r[16 ]),.gh017(gh_map_r[17 ]),.gh018(gh_map_r[18 ]),.gh019(gh_map_r[19 ]),
.gh020(gh_map_r[20 ]),.gh021(gh_map_r[21 ]),.gh022(gh_map_r[22 ]),.gh023(gh_map_r[23 ]),.gh024(gh_map_r[24 ]),.gh025(gh_map_r[25 ]),.gh026(gh_map_r[26 ]),.gh027(gh_map_r[27 ]),.gh028(gh_map_r[28 ]),.gh029(gh_map_r[29 ]),
.gh030(gh_map_r[30 ]),.gh031(gh_map_r[31 ]),.gh032(gh_map_r[32 ]),.gh033(gh_map_r[33 ]),.gh034(gh_map_r[34 ]),.gh035(gh_map_r[35 ]),.gh036(gh_map_r[36 ]),.gh037(gh_map_r[37 ]),.gh038(gh_map_r[38 ]),.gh039(gh_map_r[39 ]),
.gh040(gh_map_r[40 ]),.gh041(gh_map_r[41 ]),.gh042(gh_map_r[42 ]),.gh043(gh_map_r[43 ]),.gh044(gh_map_r[44 ]),.gh045(gh_map_r[45 ]),.gh046(gh_map_r[46 ]),.gh047(gh_map_r[47 ]),.gh048(gh_map_r[48 ]),.gh049(gh_map_r[49 ]),
.gh050(gh_map_r[50 ]),.gh051(gh_map_r[51 ]),.gh052(gh_map_r[52 ]),.gh053(gh_map_r[53 ]),.gh054(gh_map_r[54 ]),.gh055(gh_map_r[55 ]),.gh056(gh_map_r[56 ]),.gh057(gh_map_r[57 ]),.gh058(gh_map_r[58 ]),.gh059(gh_map_r[59 ]),
.gh060(gh_map_r[60 ]),.gh061(gh_map_r[61 ]),.gh062(gh_map_r[62 ]),.gh063(gh_map_r[63 ]),.gh064(gh_map_r[64 ]),.gh065(gh_map_r[65 ]),.gh066(gh_map_r[66 ]),.gh067(gh_map_r[67 ]),.gh068(gh_map_r[68 ]),.gh069(gh_map_r[69 ]),
.gh070(gh_map_r[70 ]),.gh071(gh_map_r[71 ]),.gh072(gh_map_r[72 ]),.gh073(gh_map_r[73 ]),.gh074(gh_map_r[74 ]),.gh075(gh_map_r[75 ]),.gh076(gh_map_r[76 ]),.gh077(gh_map_r[77 ]),.gh078(gh_map_r[78 ]),.gh079(gh_map_r[79 ]),
.gh080(gh_map_r[80 ]),.gh081(gh_map_r[81 ]),.gh082(gh_map_r[82 ]),.gh083(gh_map_r[83 ]),.gh084(gh_map_r[84 ]),.gh085(gh_map_r[85 ]),.gh086(gh_map_r[86 ]),.gh087(gh_map_r[87 ]),.gh088(gh_map_r[88 ]),.gh089(gh_map_r[89 ]),
.gh090(gh_map_r[90 ]),.gh091(gh_map_r[91 ]),.gh092(gh_map_r[92 ]),.gh093(gh_map_r[93 ]),.gh094(gh_map_r[94 ]),.gh095(gh_map_r[95 ]),.gh096(gh_map_r[96 ]),.gh097(gh_map_r[97 ]),.gh098(gh_map_r[98 ]),.gh099(gh_map_r[99 ]),
.gh100(gh_map_r[100]),.gh101(gh_map_r[101]),.gh102(gh_map_r[102]),.gh103(gh_map_r[103]),.gh104(gh_map_r[104]),.gh105(gh_map_r[105]),.gh106(gh_map_r[106]),.gh107(gh_map_r[107]),.gh108(gh_map_r[108]),.gh109(gh_map_r[109]),
.gh110(gh_map_r[110]),.gh111(gh_map_r[111]),.gh112(gh_map_r[112]),.gh113(gh_map_r[113]),.gh114(gh_map_r[114]),.gh115(gh_map_r[115]),.gh116(gh_map_r[116]),.gh117(gh_map_r[117]),.gh118(gh_map_r[118]),.gh119(gh_map_r[119]),.gh120(gh_map_r[120])
);

/*
mul_gi i2gi(.en(en_g_map_r),
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
*/
/*
mul_gh h2gh(.en(en_gh_map_r),
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
.reg000(gh_map_r[0  ]),.reg001(gh_map_r[1  ]),.reg002(gh_map_r[2  ]),.reg003(gh_map_r[3  ]),.reg004(gh_map_r[4  ]),.reg005(gh_map_r[5  ]),.reg006(gh_map_r[6  ]),.reg007(gh_map_r[7  ]),.reg008(gh_map_r[8  ]),.reg009(gh_map_r[9  ]),
.reg010(gh_map_r[10 ]),.reg011(gh_map_r[11 ]),.reg012(gh_map_r[12 ]),.reg013(gh_map_r[13 ]),.reg014(gh_map_r[14 ]),.reg015(gh_map_r[15 ]),.reg016(gh_map_r[16 ]),.reg017(gh_map_r[17 ]),.reg018(gh_map_r[18 ]),.reg019(gh_map_r[19 ]),
.reg020(gh_map_r[20 ]),.reg021(gh_map_r[21 ]),.reg022(gh_map_r[22 ]),.reg023(gh_map_r[23 ]),.reg024(gh_map_r[24 ]),.reg025(gh_map_r[25 ]),.reg026(gh_map_r[26 ]),.reg027(gh_map_r[27 ]),.reg028(gh_map_r[28 ]),.reg029(gh_map_r[29 ]),
.reg030(gh_map_r[30 ]),.reg031(gh_map_r[31 ]),.reg032(gh_map_r[32 ]),.reg033(gh_map_r[33 ]),.reg034(gh_map_r[34 ]),.reg035(gh_map_r[35 ]),.reg036(gh_map_r[36 ]),.reg037(gh_map_r[37 ]),.reg038(gh_map_r[38 ]),.reg039(gh_map_r[39 ]),
.reg040(gh_map_r[40 ]),.reg041(gh_map_r[41 ]),.reg042(gh_map_r[42 ]),.reg043(gh_map_r[43 ]),.reg044(gh_map_r[44 ]),.reg045(gh_map_r[45 ]),.reg046(gh_map_r[46 ]),.reg047(gh_map_r[47 ]),.reg048(gh_map_r[48 ]),.reg049(gh_map_r[49 ]),
.reg050(gh_map_r[50 ]),.reg051(gh_map_r[51 ]),.reg052(gh_map_r[52 ]),.reg053(gh_map_r[53 ]),.reg054(gh_map_r[54 ]),.reg055(gh_map_r[55 ]),.reg056(gh_map_r[56 ]),.reg057(gh_map_r[57 ]),.reg058(gh_map_r[58 ]),.reg059(gh_map_r[59 ]),
.reg060(gh_map_r[60 ]),.reg061(gh_map_r[61 ]),.reg062(gh_map_r[62 ]),.reg063(gh_map_r[63 ]),.reg064(gh_map_r[64 ]),.reg065(gh_map_r[65 ]),.reg066(gh_map_r[66 ]),.reg067(gh_map_r[67 ]),.reg068(gh_map_r[68 ]),.reg069(gh_map_r[69 ]),
.reg070(gh_map_r[70 ]),.reg071(gh_map_r[71 ]),.reg072(gh_map_r[72 ]),.reg073(gh_map_r[73 ]),.reg074(gh_map_r[74 ]),.reg075(gh_map_r[75 ]),.reg076(gh_map_r[76 ]),.reg077(gh_map_r[77 ]),.reg078(gh_map_r[78 ]),.reg079(gh_map_r[79 ]),
.reg080(gh_map_r[80 ]),.reg081(gh_map_r[81 ]),.reg082(gh_map_r[82 ]),.reg083(gh_map_r[83 ]),.reg084(gh_map_r[84 ]),.reg085(gh_map_r[85 ]),.reg086(gh_map_r[86 ]),.reg087(gh_map_r[87 ]),.reg088(gh_map_r[88 ]),.reg089(gh_map_r[89 ]),
.reg090(gh_map_r[90 ]),.reg091(gh_map_r[91 ]),.reg092(gh_map_r[92 ]),.reg093(gh_map_r[93 ]),.reg094(gh_map_r[94 ]),.reg095(gh_map_r[95 ]),.reg096(gh_map_r[96 ]),.reg097(gh_map_r[97 ]),.reg098(gh_map_r[98 ]),.reg099(gh_map_r[99 ]),
.reg100(gh_map_r[100]),.reg101(gh_map_r[101]),.reg102(gh_map_r[102]),.reg103(gh_map_r[103]),.reg104(gh_map_r[104]),.reg105(gh_map_r[105]),.reg106(gh_map_r[106]),.reg107(gh_map_r[107]),.reg108(gh_map_r[108]),.reg109(gh_map_r[109]),
.reg110(gh_map_r[110]),.reg111(gh_map_r[111]),.reg112(gh_map_r[112]),.reg113(gh_map_r[113]),.reg114(gh_map_r[114]),.reg115(gh_map_r[115]),.reg116(gh_map_r[116]),.reg117(gh_map_r[117]),.reg118(gh_map_r[118]),.reg119(gh_map_r[119]),.reg120(gh_map_r[120]),
.out000(gh_map_w[0  ]),.out001(gh_map_w[1  ]),.out002(gh_map_w[2  ]),.out003(gh_map_w[3  ]),.out004(gh_map_w[4  ]),.out005(gh_map_w[5  ]),.out006(gh_map_w[6  ]),.out007(gh_map_w[7  ]),.out008(gh_map_w[8  ]),.out009(gh_map_w[9  ]),
.out010(gh_map_w[10 ]),.out011(gh_map_w[11 ]),.out012(gh_map_w[12 ]),.out013(gh_map_w[13 ]),.out014(gh_map_w[14 ]),.out015(gh_map_w[15 ]),.out016(gh_map_w[16 ]),.out017(gh_map_w[17 ]),.out018(gh_map_w[18 ]),.out019(gh_map_w[19 ]),
.out020(gh_map_w[20 ]),.out021(gh_map_w[21 ]),.out022(gh_map_w[22 ]),.out023(gh_map_w[23 ]),.out024(gh_map_w[24 ]),.out025(gh_map_w[25 ]),.out026(gh_map_w[26 ]),.out027(gh_map_w[27 ]),.out028(gh_map_w[28 ]),.out029(gh_map_w[29 ]),
.out030(gh_map_w[30 ]),.out031(gh_map_w[31 ]),.out032(gh_map_w[32 ]),.out033(gh_map_w[33 ]),.out034(gh_map_w[34 ]),.out035(gh_map_w[35 ]),.out036(gh_map_w[36 ]),.out037(gh_map_w[37 ]),.out038(gh_map_w[38 ]),.out039(gh_map_w[39 ]),
.out040(gh_map_w[40 ]),.out041(gh_map_w[41 ]),.out042(gh_map_w[42 ]),.out043(gh_map_w[43 ]),.out044(gh_map_w[44 ]),.out045(gh_map_w[45 ]),.out046(gh_map_w[46 ]),.out047(gh_map_w[47 ]),.out048(gh_map_w[48 ]),.out049(gh_map_w[49 ]),
.out050(gh_map_w[50 ]),.out051(gh_map_w[51 ]),.out052(gh_map_w[52 ]),.out053(gh_map_w[53 ]),.out054(gh_map_w[54 ]),.out055(gh_map_w[55 ]),.out056(gh_map_w[56 ]),.out057(gh_map_w[57 ]),.out058(gh_map_w[58 ]),.out059(gh_map_w[59 ]),
.out060(gh_map_w[60 ]),.out061(gh_map_w[61 ]),.out062(gh_map_w[62 ]),.out063(gh_map_w[63 ]),.out064(gh_map_w[64 ]),.out065(gh_map_w[65 ]),.out066(gh_map_w[66 ]),.out067(gh_map_w[67 ]),.out068(gh_map_w[68 ]),.out069(gh_map_w[69 ]),
.out070(gh_map_w[70 ]),.out071(gh_map_w[71 ]),.out072(gh_map_w[72 ]),.out073(gh_map_w[73 ]),.out074(gh_map_w[74 ]),.out075(gh_map_w[75 ]),.out076(gh_map_w[76 ]),.out077(gh_map_w[77 ]),.out078(gh_map_w[78 ]),.out079(gh_map_w[79 ]),
.out080(gh_map_w[80 ]),.out081(gh_map_w[81 ]),.out082(gh_map_w[82 ]),.out083(gh_map_w[83 ]),.out084(gh_map_w[84 ]),.out085(gh_map_w[85 ]),.out086(gh_map_w[86 ]),.out087(gh_map_w[87 ]),.out088(gh_map_w[88 ]),.out089(gh_map_w[89 ]),
.out090(gh_map_w[90 ]),.out091(gh_map_w[91 ]),.out092(gh_map_w[92 ]),.out093(gh_map_w[93 ]),.out094(gh_map_w[94 ]),.out095(gh_map_w[95 ]),.out096(gh_map_w[96 ]),.out097(gh_map_w[97 ]),.out098(gh_map_w[98 ]),.out099(gh_map_w[99 ]),
.out100(gh_map_w[100]),.out101(gh_map_w[101]),.out102(gh_map_w[102]),.out103(gh_map_w[103]),.out104(gh_map_w[104]),.out105(gh_map_w[105]),.out106(gh_map_w[106]),.out107(gh_map_w[107]),.out108(gh_map_w[108]),.out109(gh_map_w[109]),
.out110(gh_map_w[110]),.out111(gh_map_w[111]),.out112(gh_map_w[112]),.out113(gh_map_w[113]),.out114(gh_map_w[114]),.out115(gh_map_w[115]),.out116(gh_map_w[116]),.out117(gh_map_w[117]),.out118(gh_map_w[118]),.out119(gh_map_w[119]),.out120(gh_map_w[120])
);
*/

endmodule