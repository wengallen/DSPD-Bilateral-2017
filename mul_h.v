
module mul_h(
    i000_n,i001_n,i002_n,i003_n,i004_n,i005_n,i006_n,i007_n,i008_n,i009_n,
    i010_n,i011_n,i012_n,i013_n,i014_n,i015_n,i016_n,i017_n,i018_n,i019_n,
    i020_n,i021_n,i022_n,i023_n,i024_n,i025_n,i026_n,i027_n,i028_n,i029_n,
    i030_n,i031_n,i032_n,i033_n,i034_n,i035_n,i036_n,i037_n,i038_n,i039_n,
    i040_n,i041_n,i042_n,i043_n,i044_n,i045_n,i046_n,i047_n,i048_n,i049_n,
    i050_n,i051_n,i052_n,i053_n,i054_n,i055_n,i056_n,i057_n,i058_n,i059_n,
    i060_n,i061_n,i062_n,i063_n,i064_n,i065_n,i066_n,i067_n,i068_n,i069_n,
    i070_n,i071_n,i072_n,i073_n,i074_n,i075_n,i076_n,i077_n,i078_n,i079_n,
    i080_n,i081_n,i082_n,i083_n,i084_n,i085_n,i086_n,i087_n,i088_n,i089_n,
    i090_n,i091_n,i092_n,i093_n,i094_n,i095_n,i096_n,i097_n,i098_n,i099_n,
    i100_n,i101_n,i102_n,i103_n,i104_n,i105_n,i106_n,i107_n,i108_n,i109_n,
    i110_n,i111_n,i112_n,i113_n,i114_n,i115_n,i116_n,i117_n,i118_n,i119_n,i120_n,
    reg000,reg001,reg002,reg003,reg004,reg005,reg006,reg007,reg008,reg009,
    reg010,reg011,reg012,reg013,reg014,reg015,reg016,reg017,reg018,reg019,
    reg020,reg021,reg022,reg023,reg024,reg025,reg026,reg027,reg028,reg029,
    reg030,reg031,reg032,reg033,reg034,reg035,reg036,reg037,reg038,reg039,
    reg040,reg041,reg042,reg043,reg044,reg045,reg046,reg047,reg048,reg049,
    reg050,reg051,reg052,reg053,reg054,reg055,reg056,reg057,reg058,reg059,
    reg060,reg061,reg062,reg063,reg064,reg065,reg066,reg067,reg068,reg069,
    reg070,reg071,reg072,reg073,reg074,reg075,reg076,reg077,reg078,reg079,
    reg080,reg081,reg082,reg083,reg084,reg085,reg086,reg087,reg088,reg089,
    reg090,reg091,reg092,reg093,reg094,reg095,reg096,reg097,reg098,reg099,
    reg100,reg101,reg102,reg103,reg104,reg105,reg106,reg107,reg108,reg109,
    reg110,reg111,reg112,reg113,reg114,reg115,reg116,reg117,reg118,reg119,reg120,
    out000,out001,out002,out003,out004,out005,out006,out007,out008,out009,
    out010,out011,out012,out013,out014,out015,out016,out017,out018,out019,
    out020,out021,out022,out023,out024,out025,out026,out027,out028,out029,
    out030,out031,out032,out033,out034,out035,out036,out037,out038,out039,
    out040,out041,out042,out043,out044,out045,out046,out047,out048,out049,
    out050,out051,out052,out053,out054,out055,out056,out057,out058,out059,
    out060,out061,out062,out063,out064,out065,out066,out067,out068,out069,
    out070,out071,out072,out073,out074,out075,out076,out077,out078,out079,
    out080,out081,out082,out083,out084,out085,out086,out087,out088,out089,
    out090,out091,out092,out093,out094,out095,out096,out097,out098,out099,
    out100,out101,out102,out103,out104,out105,out106,out107,out108,out109,
    out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120,
    en,clk,rst
);

//==== I/O port ==========================
input  [7:0]  i000_n,i001_n,i002_n,i003_n,i004_n,i005_n,i006_n,i007_n,i008_n,i009_n;
input  [7:0]  i010_n,i011_n,i012_n,i013_n,i014_n,i015_n,i016_n,i017_n,i018_n,i019_n;
input  [7:0]  i020_n,i021_n,i022_n,i023_n,i024_n,i025_n,i026_n,i027_n,i028_n,i029_n;
input  [7:0]  i030_n,i031_n,i032_n,i033_n,i034_n,i035_n,i036_n,i037_n,i038_n,i039_n;
input  [7:0]  i040_n,i041_n,i042_n,i043_n,i044_n,i045_n,i046_n,i047_n,i048_n,i049_n;
input  [7:0]  i050_n,i051_n,i052_n,i053_n,i054_n,i055_n,i056_n,i057_n,i058_n,i059_n;
input  [7:0]  i060_n,i061_n,i062_n,i063_n,i064_n,i065_n,i066_n,i067_n,i068_n,i069_n;
input  [7:0]  i070_n,i071_n,i072_n,i073_n,i074_n,i075_n,i076_n,i077_n,i078_n,i079_n;
input  [7:0]  i080_n,i081_n,i082_n,i083_n,i084_n,i085_n,i086_n,i087_n,i088_n,i089_n;
input  [7:0]  i090_n,i091_n,i092_n,i093_n,i094_n,i095_n,i096_n,i097_n,i098_n,i099_n;
input  [7:0]  i100_n,i101_n,i102_n,i103_n,i104_n,i105_n,i106_n,i107_n,i108_n,i109_n;
input  [7:0]  i110_n,i111_n,i112_n,i113_n,i114_n,i115_n,i116_n,i117_n,i118_n,i119_n,i120_n;

input  [13:0] reg000,reg001,reg002,reg003,reg004,reg005,reg006,reg007,reg008,reg009;
input  [13:0] reg010,reg011,reg012,reg013,reg014,reg015,reg016,reg017,reg018,reg019;
input  [13:0] reg020,reg021,reg022,reg023,reg024,reg025,reg026,reg027,reg028,reg029;
input  [13:0] reg030,reg031,reg032,reg033,reg034,reg035,reg036,reg037,reg038,reg039;
input  [13:0] reg040,reg041,reg042,reg043,reg044,reg045,reg046,reg047,reg048,reg049;
input  [13:0] reg050,reg051,reg052,reg053,reg054,reg055,reg056,reg057,reg058,reg059;
input  [13:0] reg060,reg061,reg062,reg063,reg064,reg065,reg066,reg067,reg068,reg069;
input  [13:0] reg070,reg071,reg072,reg073,reg074,reg075,reg076,reg077,reg078,reg079;
input  [13:0] reg080,reg081,reg082,reg083,reg084,reg085,reg086,reg087,reg088,reg089;
input  [13:0] reg090,reg091,reg092,reg093,reg094,reg095,reg096,reg097,reg098,reg099;
input  [13:0] reg100,reg101,reg102,reg103,reg104,reg105,reg106,reg107,reg108,reg109;
input  [13:0] reg110,reg111,reg112,reg113,reg114,reg115,reg116,reg117,reg118,reg119,reg120;


output reg [13:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009;
output reg [13:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019;
output reg [13:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029;
output reg [13:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039;
output reg [13:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049;
output reg [13:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059;
output reg [13:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069;
output reg [13:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079;
output reg [13:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089;
output reg [13:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099;
output reg [13:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109;
output reg [13:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120;

input  en;
input  clk;
input  rst;

reg        state_r;
reg        state_w;
reg [13:0] LUT_r[0:255];
reg [13:0] LUT_w[0:255];
integer i;

always@(*) begin
    case(state_r)
    0:begin
        state_w =1;
        LUT_w[0  ] = 14'b1_000000; // 1.0000
        LUT_w[1  ] = 14'b1_000000; // 1.0000
        LUT_w[2  ] = 14'b1_000000; // 1.0000
        LUT_w[3  ] = 14'b1_000000; // 1.0000
        LUT_w[4  ] = 14'b0_111111; // 0.9844
        LUT_w[5  ] = 14'b0_111111; // 0.9844
        LUT_w[6  ] = 14'b0_111110; // 0.9688
        LUT_w[7  ] = 14'b0_111110; // 0.9688
        LUT_w[8  ] = 14'b0_111101; // 0.9531
        LUT_w[9  ] = 14'b0_111100; // 0.9375
        LUT_w[10 ] = 14'b0_111011; // 0.9219
        LUT_w[11 ] = 14'b0_111010; // 0.9063
        LUT_w[12 ] = 14'b0_111001; // 0.8906
        LUT_w[13 ] = 14'b0_111000; // 0.8750
        LUT_w[14 ] = 14'b0_110111; // 0.8594
        LUT_w[15 ] = 14'b0_110110; // 0.8438
        LUT_w[16 ] = 14'b0_110101; // 0.8281
        LUT_w[17 ] = 14'b0_110011; // 0.7969
        LUT_w[18 ] = 14'b0_110010; // 0.7813
        LUT_w[19 ] = 14'b0_110000; // 0.7500
        LUT_w[20 ] = 14'b0_101111; // 0.7344
        LUT_w[21 ] = 14'b0_101110; // 0.7188
        LUT_w[22 ] = 14'b0_101100; // 0.6875
        LUT_w[23 ] = 14'b0_101011; // 0.6719
        LUT_w[24 ] = 14'b0_101001; // 0.6406
        LUT_w[25 ] = 14'b0_101000; // 0.6250
        LUT_w[26 ] = 14'b0_100110; // 0.5938
        LUT_w[27 ] = 14'b0_100101; // 0.5781
        LUT_w[28 ] = 14'b0_100011; // 0.5469
        LUT_w[29 ] = 14'b0_100010; // 0.5313
        LUT_w[30 ] = 14'b0_100000; // 0.5000
        LUT_w[31 ] = 14'b0_011111; // 0.4844
        LUT_w[32 ] = 14'b0_011101; // 0.4531
        LUT_w[33 ] = 14'b0_011100; // 0.4375
        LUT_w[34 ] = 14'b0_011010; // 0.4063
        LUT_w[35 ] = 14'b0_011001; // 0.3906
        LUT_w[36 ] = 14'b0_011000; // 0.3750
        LUT_w[37 ] = 14'b0_010110; // 0.3438
        LUT_w[38 ] = 14'b0_010101; // 0.3281
        LUT_w[39 ] = 14'b0_010100; // 0.3125
        LUT_w[40 ] = 14'b0_010011; // 0.2969
        LUT_w[41 ] = 14'b0_010010; // 0.2813
        LUT_w[42 ] = 14'b0_010000; // 0.2500
        LUT_w[43 ] = 14'b0_001111; // 0.2344
        LUT_w[44 ] = 14'b0_001110; // 0.2188
        LUT_w[45 ] = 14'b0_001101; // 0.2031
        LUT_w[46 ] = 14'b0_001101; // 0.2031
        LUT_w[47 ] = 14'b0_001100; // 0.1875
        LUT_w[48 ] = 14'b0_001011; // 0.1719
        LUT_w[49 ] = 14'b0_001010; // 0.1563
        LUT_w[50 ] = 14'b0_001001; // 0.1406
        LUT_w[51 ] = 14'b0_001001; // 0.1406
        LUT_w[52 ] = 14'b0_001000; // 0.1250
        LUT_w[53 ] = 14'b0_000111; // 0.1094
        LUT_w[54 ] = 14'b0_000111; // 0.1094
        LUT_w[55 ] = 14'b0_000110; // 0.0938
        LUT_w[56 ] = 14'b0_000110; // 0.0938
        LUT_w[57 ] = 14'b0_000101; // 0.0781
        LUT_w[58 ] = 14'b0_000101; // 0.0781
        LUT_w[59 ] = 14'b0_000100; // 0.0625
        LUT_w[60 ] = 14'b0_000100; // 0.0625
        LUT_w[61 ] = 14'b0_000100; // 0.0625
        LUT_w[62 ] = 14'b0_000011; // 0.0469
        LUT_w[63 ] = 14'b0_000011; // 0.0469
        LUT_w[64 ] = 14'b0_000011; // 0.0469
        LUT_w[65 ] = 14'b0_000010; // 0.0313
        LUT_w[66 ] = 14'b0_000010; // 0.0313
        LUT_w[67 ] = 14'b0_000010; // 0.0313
        LUT_w[68 ] = 14'b0_000010; // 0.0313
        LUT_w[69 ] = 14'b0_000010; // 0.0313
        LUT_w[70 ] = 14'b0_000001; // 0.0156
        LUT_w[71 ] = 14'b0_000001; // 0.0156
        LUT_w[72 ] = 14'b0_000001; // 0.0156
        LUT_w[73 ] = 14'b0_000001; // 0.0156
        LUT_w[74 ] = 14'b0_000001; // 0.0156
        LUT_w[75 ] = 14'b0_000001; // 0.0156
        LUT_w[76 ] = 14'b0_000001; // 0.0156
        LUT_w[77 ] = 14'b0_000001; // 0.0156
        LUT_w[78 ] = 14'b0_000001; // 0.0156
        LUT_w[79 ] = 14'b0_000001; // 0.0156
        
        for(i=80;i<=255;i=i+1)begin
            LUT_w[i]=14'b0_000000; // 0
        end
        /*
        LUT_w[80 ] = 14'b0_000000; // 0
        LUT_w[81 ] = 14'b0_000000; // 0
        LUT_w[82 ] = 14'b0_000000; // 0
        LUT_w[83 ] = 14'b0_000000; // 0
        LUT_w[84 ] = 14'b0_000000; // 0
        LUT_w[85 ] = 14'b0_000000; // 0
        LUT_w[86 ] = 14'b0_000000; // 0
        LUT_w[87 ] = 14'b0_000000; // 0
        LUT_w[88 ] = 14'b0_000000; // 0
        LUT_w[89 ] = 14'b0_000000; // 0
        LUT_w[90 ] = 14'b0_000000; // 0
        LUT_w[91 ] = 14'b0_000000; // 0
        LUT_w[92 ] = 14'b0_000000; // 0
        LUT_w[93 ] = 14'b0_000000; // 0
        LUT_w[94 ] = 14'b0_000000; // 0
        LUT_w[95 ] = 14'b0_000000; // 0
        LUT_w[96 ] = 14'b0_000000; // 0
        LUT_w[97 ] = 14'b0_000000; // 0
        LUT_w[98 ] = 14'b0_000000; // 0
        LUT_w[99 ] = 14'b0_000000; // 0
        LUT_w[100] = 14'b0_000000; // 0
        LUT_w[101] = 14'b0_000000; // 0
        LUT_w[102] = 14'b0_000000; // 0
        LUT_w[103] = 14'b0_000000; // 0
        LUT_w[104] = 14'b0_000000; // 0
        LUT_w[105] = 14'b0_000000; // 0
        LUT_w[106] = 14'b0_000000; // 0
        LUT_w[107] = 14'b0_000000; // 0
        LUT_w[108] = 14'b0_000000; // 0
        LUT_w[109] = 14'b0_000000; // 0
        LUT_w[110] = 14'b0_000000; // 0
        LUT_w[111] = 14'b0_000000; // 0
        LUT_w[112] = 14'b0_000000; // 0
        LUT_w[113] = 14'b0_000000; // 0
        LUT_w[114] = 14'b0_000000; // 0
        LUT_w[115] = 14'b0_000000; // 0
        LUT_w[116] = 14'b0_000000; // 0
        LUT_w[117] = 14'b0_000000; // 0
        LUT_w[118] = 14'b0_000000; // 0
        LUT_w[119] = 14'b0_000000; // 0
        LUT_w[120] = 14'b0_000000; // 0
        LUT_w[121] = 14'b0_000000; // 0
        LUT_w[122] = 14'b0_000000; // 0
        LUT_w[123] = 14'b0_000000; // 0
        LUT_w[124] = 14'b0_000000; // 0
        LUT_w[125] = 14'b0_000000; // 0
        LUT_w[126] = 14'b0_000000; // 0
        LUT_w[127] = 14'b0_000000; // 0
        LUT_w[128] = 14'b0_000000; // 0
        LUT_w[129] = 14'b0_000000; // 0
        LUT_w[130] = 14'b0_000000; // 0
        LUT_w[131] = 14'b0_000000; // 0
        LUT_w[132] = 14'b0_000000; // 0
        LUT_w[133] = 14'b0_000000; // 0
        LUT_w[134] = 14'b0_000000; // 0
        LUT_w[135] = 14'b0_000000; // 0
        LUT_w[136] = 14'b0_000000; // 0
        LUT_w[137] = 14'b0_000000; // 0
        LUT_w[138] = 14'b0_000000; // 0
        LUT_w[139] = 14'b0_000000; // 0
        LUT_w[140] = 14'b0_000000; // 0
        LUT_w[141] = 14'b0_000000; // 0
        LUT_w[142] = 14'b0_000000; // 0
        LUT_w[143] = 14'b0_000000; // 0
        LUT_w[144] = 14'b0_000000; // 0
        LUT_w[145] = 14'b0_000000; // 0
        LUT_w[146] = 14'b0_000000; // 0
        LUT_w[147] = 14'b0_000000; // 0
        LUT_w[148] = 14'b0_000000; // 0
        LUT_w[149] = 14'b0_000000; // 0
        LUT_w[150] = 14'b0_000000; // 0
        LUT_w[151] = 14'b0_000000; // 0
        LUT_w[152] = 14'b0_000000; // 0
        LUT_w[153] = 14'b0_000000; // 0
        LUT_w[154] = 14'b0_000000; // 0
        LUT_w[155] = 14'b0_000000; // 0
        LUT_w[156] = 14'b0_000000; // 0
        LUT_w[157] = 14'b0_000000; // 0
        LUT_w[158] = 14'b0_000000; // 0
        LUT_w[159] = 14'b0_000000; // 0
        LUT_w[160] = 14'b0_000000; // 0
        LUT_w[161] = 14'b0_000000; // 0
        LUT_w[162] = 14'b0_000000; // 0
        LUT_w[163] = 14'b0_000000; // 0
        LUT_w[164] = 14'b0_000000; // 0
        LUT_w[165] = 14'b0_000000; // 0
        LUT_w[166] = 14'b0_000000; // 0
        LUT_w[167] = 14'b0_000000; // 0
        LUT_w[168] = 14'b0_000000; // 0
        LUT_w[169] = 14'b0_000000; // 0
        LUT_w[170] = 14'b0_000000; // 0
        LUT_w[171] = 14'b0_000000; // 0
        LUT_w[172] = 14'b0_000000; // 0
        LUT_w[173] = 14'b0_000000; // 0
        LUT_w[174] = 14'b0_000000; // 0
        LUT_w[175] = 14'b0_000000; // 0
        LUT_w[176] = 14'b0_000000; // 0
        LUT_w[177] = 14'b0_000000; // 0
        LUT_w[178] = 14'b0_000000; // 0
        LUT_w[179] = 14'b0_000000; // 0
        LUT_w[180] = 14'b0_000000; // 0
        LUT_w[181] = 14'b0_000000; // 0
        LUT_w[182] = 14'b0_000000; // 0
        LUT_w[183] = 14'b0_000000; // 0
        LUT_w[184] = 14'b0_000000; // 0
        LUT_w[185] = 14'b0_000000; // 0
        LUT_w[186] = 14'b0_000000; // 0
        LUT_w[187] = 14'b0_000000; // 0
        LUT_w[188] = 14'b0_000000; // 0
        LUT_w[189] = 14'b0_000000; // 0
        LUT_w[190] = 14'b0_000000; // 0
        LUT_w[191] = 14'b0_000000; // 0
        LUT_w[192] = 14'b0_000000; // 0
        LUT_w[193] = 14'b0_000000; // 0
        LUT_w[194] = 14'b0_000000; // 0
        LUT_w[195] = 14'b0_000000; // 0
        LUT_w[196] = 14'b0_000000; // 0
        LUT_w[197] = 14'b0_000000; // 0
        LUT_w[198] = 14'b0_000000; // 0
        LUT_w[199] = 14'b0_000000; // 0
        LUT_w[200] = 14'b0_000000; // 0
        LUT_w[201] = 14'b0_000000; // 0
        LUT_w[202] = 14'b0_000000; // 0
        LUT_w[203] = 14'b0_000000; // 0
        LUT_w[204] = 14'b0_000000; // 0
        LUT_w[205] = 14'b0_000000; // 0
        LUT_w[206] = 14'b0_000000; // 0
        LUT_w[207] = 14'b0_000000; // 0
        LUT_w[208] = 14'b0_000000; // 0
        LUT_w[209] = 14'b0_000000; // 0
        LUT_w[210] = 14'b0_000000; // 0
        LUT_w[211] = 14'b0_000000; // 0
        LUT_w[212] = 14'b0_000000; // 0
        LUT_w[213] = 14'b0_000000; // 0
        LUT_w[214] = 14'b0_000000; // 0
        LUT_w[215] = 14'b0_000000; // 0
        LUT_w[216] = 14'b0_000000; // 0
        LUT_w[217] = 14'b0_000000; // 0
        LUT_w[218] = 14'b0_000000; // 0
        LUT_w[219] = 14'b0_000000; // 0
        LUT_w[220] = 14'b0_000000; // 0
        LUT_w[221] = 14'b0_000000; // 0
        LUT_w[222] = 14'b0_000000; // 0
        LUT_w[223] = 14'b0_000000; // 0
        LUT_w[224] = 14'b0_000000; // 0
        LUT_w[225] = 14'b0_000000; // 0
        LUT_w[226] = 14'b0_000000; // 0
        LUT_w[227] = 14'b0_000000; // 0
        LUT_w[228] = 14'b0_000000; // 0
        LUT_w[229] = 14'b0_000000; // 0
        LUT_w[230] = 14'b0_000000; // 0
        LUT_w[231] = 14'b0_000000; // 0
        LUT_w[232] = 14'b0_000000; // 0
        LUT_w[233] = 14'b0_000000; // 0
        LUT_w[234] = 14'b0_000000; // 0
        LUT_w[235] = 14'b0_000000; // 0
        LUT_w[236] = 14'b0_000000; // 0
        LUT_w[237] = 14'b0_000000; // 0
        LUT_w[238] = 14'b0_000000; // 0
        LUT_w[239] = 14'b0_000000; // 0
        LUT_w[240] = 14'b0_000000; // 0
        LUT_w[241] = 14'b0_000000; // 0
        LUT_w[242] = 14'b0_000000; // 0
        LUT_w[243] = 14'b0_000000; // 0
        LUT_w[244] = 14'b0_000000; // 0
        LUT_w[245] = 14'b0_000000; // 0
        LUT_w[246] = 14'b0_000000; // 0
        LUT_w[247] = 14'b0_000000; // 0
        LUT_w[248] = 14'b0_000000; // 0
        LUT_w[249] = 14'b0_000000; // 0
        LUT_w[250] = 14'b0_000000; // 0
        LUT_w[251] = 14'b0_000000; // 0
        LUT_w[252] = 14'b0_000000; // 0
        LUT_w[253] = 14'b0_000000; // 0
        LUT_w[254] = 14'b0_000000; // 0
        LUT_w[255] = 14'b0_000000; // 0
        */
    end
    1:begin
        for(i=0;i<121;i=i+1)begin
            LUT_r[i]=LUT_w[i];
        end
    end
    endcase
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state_r         <= 0;
        for(i=0;i<=255;i=i+1) begin
            LUT_r[i]    <= 0;
        end
    end
    else begin
        state_r         <= state_w;
        for(i=0;i<=255;i=i+1) begin
            LUT_r[i]    <= LUT_w[i];
        end
    end
end




always@(*) begin
    if(en && state_r) begin
        
        out000 = LUT_r[i000_n];
        out001 = LUT_r[i001_n];
        out002 = LUT_r[i002_n];
        out003 = LUT_r[i003_n];
        out004 = LUT_r[i004_n];
        out005 = LUT_r[i005_n];
        out006 = LUT_r[i006_n];
        out007 = LUT_r[i007_n];
        out008 = LUT_r[i008_n];
        out009 = LUT_r[i009_n];
        out010 = LUT_r[i010_n];
        out011 = LUT_r[i011_n];
        out012 = LUT_r[i012_n];
        out013 = LUT_r[i013_n];
        out014 = LUT_r[i014_n];
        out015 = LUT_r[i015_n];
        out016 = LUT_r[i016_n];
        out017 = LUT_r[i017_n];
        out018 = LUT_r[i018_n];
        out019 = LUT_r[i019_n];
        out020 = LUT_r[i020_n];
        out021 = LUT_r[i021_n];
        out022 = LUT_r[i022_n];
        out023 = LUT_r[i023_n];
        out024 = LUT_r[i024_n];
        out025 = LUT_r[i025_n];
        out026 = LUT_r[i026_n];
        out027 = LUT_r[i027_n];
        out028 = LUT_r[i028_n];
        out029 = LUT_r[i029_n];
        out030 = LUT_r[i030_n];
        out031 = LUT_r[i031_n];
        out032 = LUT_r[i032_n];
        out033 = LUT_r[i033_n];
        out034 = LUT_r[i034_n];
        out035 = LUT_r[i035_n];
        out036 = LUT_r[i036_n];
        out037 = LUT_r[i037_n];
        out038 = LUT_r[i038_n];
        out039 = LUT_r[i039_n];
        out040 = LUT_r[i040_n];
        out041 = LUT_r[i041_n];
        out042 = LUT_r[i042_n];
        out043 = LUT_r[i043_n];
        out044 = LUT_r[i044_n];
        out045 = LUT_r[i045_n];
        out046 = LUT_r[i046_n];
        out047 = LUT_r[i047_n];
        out048 = LUT_r[i048_n];
        out049 = LUT_r[i049_n];
        out050 = LUT_r[i050_n];
        out051 = LUT_r[i051_n];
        out052 = LUT_r[i052_n];
        out053 = LUT_r[i053_n];
        out054 = LUT_r[i054_n];
        out055 = LUT_r[i055_n];
        out056 = LUT_r[i056_n];
        out057 = LUT_r[i057_n];
        out058 = LUT_r[i058_n];
        out059 = LUT_r[i059_n];
        out060 = LUT_r[i060_n];
        out061 = LUT_r[i061_n];
        out062 = LUT_r[i062_n];
        out063 = LUT_r[i063_n];
        out064 = LUT_r[i064_n];
        out065 = LUT_r[i065_n];
        out066 = LUT_r[i066_n];
        out067 = LUT_r[i067_n];
        out068 = LUT_r[i068_n];
        out069 = LUT_r[i069_n];
        out070 = LUT_r[i070_n];
        out071 = LUT_r[i071_n];
        out072 = LUT_r[i072_n];
        out073 = LUT_r[i073_n];
        out074 = LUT_r[i074_n];
        out075 = LUT_r[i075_n];
        out076 = LUT_r[i076_n];
        out077 = LUT_r[i077_n];
        out078 = LUT_r[i078_n];
        out079 = LUT_r[i079_n];
        out080 = LUT_r[i080_n];
        out081 = LUT_r[i081_n];
        out082 = LUT_r[i082_n];
        out083 = LUT_r[i083_n];
        out084 = LUT_r[i084_n];
        out085 = LUT_r[i085_n];
        out086 = LUT_r[i086_n];
        out087 = LUT_r[i087_n];
        out088 = LUT_r[i088_n];
        out089 = LUT_r[i089_n];
        out090 = LUT_r[i090_n];
        out091 = LUT_r[i091_n];
        out092 = LUT_r[i092_n];
        out093 = LUT_r[i093_n];
        out094 = LUT_r[i094_n];
        out095 = LUT_r[i095_n];
        out096 = LUT_r[i096_n];
        out097 = LUT_r[i097_n];
        out098 = LUT_r[i098_n];
        out099 = LUT_r[i099_n];
        out100 = LUT_r[i100_n];
        out101 = LUT_r[i101_n];
        out102 = LUT_r[i102_n];
        out103 = LUT_r[i103_n];
        out104 = LUT_r[i104_n];
        out105 = LUT_r[i105_n];
        out106 = LUT_r[i106_n];
        out107 = LUT_r[i107_n];
        out108 = LUT_r[i108_n];
        out109 = LUT_r[i109_n];
        out110 = LUT_r[i110_n];
        out111 = LUT_r[i111_n];
        out112 = LUT_r[i112_n];
        out113 = LUT_r[i113_n];
        out114 = LUT_r[i114_n];
        out115 = LUT_r[i115_n];
        out116 = LUT_r[i116_n];
        out117 = LUT_r[i117_n];
        out118 = LUT_r[i118_n];
        out119 = LUT_r[i119_n];
        out120 = LUT_r[i120_n];
    end
    else begin
        out000 = reg000;
        out001 = reg001;
        out002 = reg002;
        out003 = reg003;
        out004 = reg004;
        out005 = reg005;
        out006 = reg006;
        out007 = reg007;
        out008 = reg008;
        out009 = reg009;
        out010 = reg010;
        out011 = reg011;
        out012 = reg012;
        out013 = reg013;
        out014 = reg014;
        out015 = reg015;
        out016 = reg016;
        out017 = reg017;
        out018 = reg018;
        out019 = reg019;
        out020 = reg020;
        out021 = reg021;
        out022 = reg022;
        out023 = reg023;
        out024 = reg024;
        out025 = reg025;
        out026 = reg026;
        out027 = reg027;
        out028 = reg028;
        out029 = reg029;
        out030 = reg030;
        out031 = reg031;
        out032 = reg032;
        out033 = reg033;
        out034 = reg034;
        out035 = reg035;
        out036 = reg036;
        out037 = reg037;
        out038 = reg038;
        out039 = reg039;
        out040 = reg040;
        out041 = reg041;
        out042 = reg042;
        out043 = reg043;
        out044 = reg044;
        out045 = reg045;
        out046 = reg046;
        out047 = reg047;
        out048 = reg048;
        out049 = reg049;
        out050 = reg050;
        out051 = reg051;
        out052 = reg052;
        out053 = reg053;
        out054 = reg054;
        out055 = reg055;
        out056 = reg056;
        out057 = reg057;
        out058 = reg058;
        out059 = reg059;
        out060 = reg060;
        out061 = reg061;
        out062 = reg062;
        out063 = reg063;
        out064 = reg064;
        out065 = reg065;
        out066 = reg066;
        out067 = reg067;
        out068 = reg068;
        out069 = reg069;
        out070 = reg070;
        out071 = reg071;
        out072 = reg072;
        out073 = reg073;
        out074 = reg074;
        out075 = reg075;
        out076 = reg076;
        out077 = reg077;
        out078 = reg078;
        out079 = reg079;
        out080 = reg080;
        out081 = reg081;
        out082 = reg082;
        out083 = reg083;
        out084 = reg084;
        out085 = reg085;
        out086 = reg086;
        out087 = reg087;
        out088 = reg088;
        out089 = reg089;
        out090 = reg090;
        out091 = reg091;
        out092 = reg092;
        out093 = reg093;
        out094 = reg094;
        out095 = reg095;
        out096 = reg096;
        out097 = reg097;
        out098 = reg098;
        out099 = reg099;
        out100 = reg100;
        out101 = reg101;
        out102 = reg102;
        out103 = reg103;
        out104 = reg104;
        out105 = reg105;
        out106 = reg106;
        out107 = reg107;
        out108 = reg108;
        out109 = reg109;
        out110 = reg110;
        out111 = reg111;
        out112 = reg112;
        out113 = reg113;
        out114 = reg114;
        out115 = reg115;
        out116 = reg116;
        out117 = reg117;
        out118 = reg118;
        out119 = reg119;
        out120 = reg120;
    end
end

/*
0:3     1.0000  b1_000000
4:5     0.9844  b0_111111
6:7     0.9688  b0_111110
8       0.9531  b0_111101
9       0.9375  b0_111100
10      0.9219  b0_111011
11      0.9063  b0_111010
12      0.8906  b0_111001
13      0.8750  b0_111000
14      0.8594  b0_110111
15      0.8438  b0_110110
16      0.8281  b0_110101
17      0.7969  b0_110011
18      0.7813  b0_110010
19      0.7500  b0_110000
20      0.7344  b0_101111
21      0.7188  b0_101110
22      0.6875  b0_101100
23      0.6719  b0_101011
24      0.6406  b0_101001
25      0.6250  b0_101000
26      0.5938  b0_100110
27      0.5781  b0_100101
28      0.5469  b0_100011
29      0.5313  b0_100010
30      0.5000  b0_100000
31      0.4844  b0_011111
32      0.4531  b0_011101
33      0.4375  b0_011100
34      0.4063  b0_011010
35      0.3906  b0_011001
36      0.3750  b0_011000
37      0.3438  b0_010110
38      0.3281  b0_010101
39      0.3125  b0_010100
40      0.2969  b0_010011
41      0.2813  b0_010010
42      0.2500  b0_010000
43      0.2344  b0_001111
44      0.2188  b0_001110
45:46   0.2031  b0_001101
47		0.1875  b0_001100
48		0.1719  b0_001011
49		0.1563  b0_001010
50:51	0.1406  b0_001001
52		0.1250  b0_001000
53:54	0.1094  b0_000111
55:56	0.0938  b0_000110
57:58	0.0781  b0_000101
59:61	0.0625  b0_000100
62:64	0.0469  b0_000011
65:69	0.0313  b0_000010
70:79	0.0156  b0_000001
80:255 	0.0000  b0_000000
*/


endmodule