
module mul_g(
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
    en
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


output reg [14:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009;
output reg [14:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019;
output reg [14:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029;
output reg [14:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039;
output reg [14:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049;
output reg [14:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059;
output reg [14:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069;
output reg [14:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079;
output reg [14:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089;
output reg [14:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099;
output reg [14:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109;
output reg [14:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120;

input         en;

always@(*) begin
    if(en) begin
        out000 = i000_n * 7'b0_000100; //0.0625
        out001 = i001_n * 7'b0_000111; //0.1094
        out002 = i002_n * 7'b0_001010; //0.1563
        out003 = i003_n * 7'b0_001101; //0.2031
        out004 = i004_n * 7'b0_001111; //0.2344
        out005 = i005_n * 7'b0_010000; //0.2500
        out006 = i006_n * 7'b0_001111; //0.2344
        out007 = i007_n * 7'b0_001101; //0.2031
        out008 = i008_n * 7'b0_001010; //0.1563
        out009 = i009_n * 7'b0_000111; //0.1094
        out010 = i010_n * 7'b0_000100; //0.0625
        out011 = i011_n * 7'b0_000111; //0.1094
        out012 = i012_n * 7'b0_001011; //0.1719
        out013 = i013_n * 7'b0_010000; //0.2500
        out014 = i014_n * 7'b0_010101; //0.3281
        out015 = i015_n * 7'b0_011001; //0.3906
        out016 = i016_n * 7'b0_011010; //0.4063
        out017 = i017_n * 7'b0_011001; //0.3906
        out018 = i018_n * 7'b0_010101; //0.3281
        out019 = i019_n * 7'b0_010000; //0.2500
        out020 = i020_n * 7'b0_001011; //0.1719
        out021 = i021_n * 7'b0_000111; //0.1094
        out022 = i022_n * 7'b0_001010; //0.1563
        out023 = i023_n * 7'b0_010000; //0.2500
        out024 = i024_n * 7'b0_011000; //0.3750
        out025 = i025_n * 7'b0_011111; //0.4844
        out026 = i026_n * 7'b0_100101; //0.5781
        out027 = i027_n * 7'b0_100111; //0.6094
        out028 = i028_n * 7'b0_100101; //0.5781
        out029 = i029_n * 7'b0_011111; //0.4844
        out030 = i030_n * 7'b0_011000; //0.3750
        out031 = i031_n * 7'b0_010000; //0.2500
        out032 = i032_n * 7'b0_001010; //0.1563
        out033 = i033_n * 7'b0_001101; //0.2031
        out034 = i034_n * 7'b0_010101; //0.3281
        out035 = i035_n * 7'b0_011111; //0.4844
        out036 = i036_n * 7'b0_101001; //0.6406
        out037 = i037_n * 7'b0_110000; //0.7500
        out038 = i038_n * 7'b0_110011; //0.7969
        out039 = i039_n * 7'b0_110000; //0.7500
        out040 = i040_n * 7'b0_101001; //0.6406
        out041 = i041_n * 7'b0_011111; //0.4844
        out042 = i042_n * 7'b0_010101; //0.3281
        out043 = i043_n * 7'b0_001101; //0.2031
        out044 = i044_n * 7'b0_001111; //0.2344
        out045 = i045_n * 7'b0_011001; //0.3906
        out046 = i046_n * 7'b0_100101; //0.5781
        out047 = i047_n * 7'b0_110000; //0.7500
        out048 = i048_n * 7'b0_111001; //0.8906
        out049 = i049_n * 7'b0_111101; //0.9531
        out050 = i050_n * 7'b0_111001; //0.8906
        out051 = i051_n * 7'b0_110000; //0.7500
        out052 = i052_n * 7'b0_100101; //0.5781
        out053 = i053_n * 7'b0_011001; //0.3906
        out054 = i054_n * 7'b0_001111; //0.2344
        out055 = i055_n * 7'b0_010000; //0.2500
        out056 = i056_n * 7'b0_011010; //0.4063
        out057 = i057_n * 7'b0_100111; //0.6094
        out058 = i058_n * 7'b0_110011; //0.7969
        out059 = i059_n * 7'b0_111101; //0.9531
        out060 = i060_n * 7'b1_000000; //1.0000
        out061 = i061_n * 7'b0_111101; //0.9531
        out062 = i062_n * 7'b0_110011; //0.7969
        out063 = i063_n * 7'b0_100111; //0.6094
        out064 = i064_n * 7'b0_011010; //0.4063
        out065 = i065_n * 7'b0_010000; //0.2500
        out066 = i066_n * 7'b0_001111; //0.2344
        out067 = i067_n * 7'b0_011001; //0.3906
        out068 = i068_n * 7'b0_100101; //0.5781
        out069 = i069_n * 7'b0_110000; //0.7500
        out070 = i070_n * 7'b0_111001; //0.8906
        out071 = i071_n * 7'b0_111101; //0.9531
        out072 = i072_n * 7'b0_111001; //0.8906
        out073 = i073_n * 7'b0_110000; //0.7500
        out074 = i074_n * 7'b0_100101; //0.5781
        out075 = i075_n * 7'b0_011001; //0.3906
        out076 = i076_n * 7'b0_001111; //0.2344
        out077 = i077_n * 7'b0_001101; //0.2031
        out078 = i078_n * 7'b0_010101; //0.3281
        out079 = i079_n * 7'b0_011111; //0.4844
        out080 = i080_n * 7'b0_101001; //0.6406
        out081 = i081_n * 7'b0_110000; //0.7500
        out082 = i082_n * 7'b0_110011; //0.7969
        out083 = i083_n * 7'b0_110000; //0.7500
        out084 = i084_n * 7'b0_101001; //0.6406
        out085 = i085_n * 7'b0_011111; //0.4844
        out086 = i086_n * 7'b0_010101; //0.3281
        out087 = i087_n * 7'b0_001101; //0.2031
        out088 = i088_n * 7'b0_001010; //0.1563
        out089 = i089_n * 7'b0_010000; //0.2500
        out090 = i090_n * 7'b0_011000; //0.3750
        out091 = i091_n * 7'b0_011111; //0.4844
        out092 = i092_n * 7'b0_100101; //0.5781
        out093 = i093_n * 7'b0_100111; //0.6094
        out094 = i094_n * 7'b0_100101; //0.5781
        out095 = i095_n * 7'b0_011111; //0.4844
        out096 = i096_n * 7'b0_011000; //0.3750
        out097 = i097_n * 7'b0_010000; //0.2500
        out098 = i098_n * 7'b0_001010; //0.1563
        out099 = i099_n * 7'b0_000111; //0.1094
        out100 = i100_n * 7'b0_001011; //0.1719
        out101 = i101_n * 7'b0_010000; //0.2500
        out102 = i102_n * 7'b0_010101; //0.3281
        out103 = i103_n * 7'b0_011001; //0.3906
        out104 = i104_n * 7'b0_011010; //0.4063
        out105 = i105_n * 7'b0_011001; //0.3906
        out106 = i106_n * 7'b0_010101; //0.3281
        out107 = i107_n * 7'b0_010000; //0.2500
        out108 = i108_n * 7'b0_001011; //0.1719
        out109 = i109_n * 7'b0_000111; //0.1094
        out110 = i110_n * 7'b0_000100; //0.0625
        out111 = i111_n * 7'b0_000111; //0.1094
        out112 = i112_n * 7'b0_001010; //0.1563
        out113 = i113_n * 7'b0_001101; //0.2031
        out114 = i114_n * 7'b0_001111; //0.2344
        out115 = i115_n * 7'b0_010000; //0.2500
        out116 = i116_n * 7'b0_001111; //0.2344
        out117 = i117_n * 7'b0_001101; //0.2031
        out118 = i118_n * 7'b0_001010; //0.1563
        out119 = i119_n * 7'b0_000111; //0.1094
        out120 = i120_n * 7'b0_000100; //0.0625
    end
    else begin
        out000 = {1'b0,reg000};
        out001 = {1'b0,reg001};
        out002 = {1'b0,reg002};
        out003 = {1'b0,reg003};
        out004 = {1'b0,reg004};
        out005 = {1'b0,reg005};
        out006 = {1'b0,reg006};
        out007 = {1'b0,reg007};
        out008 = {1'b0,reg008};
        out009 = {1'b0,reg009};
        out010 = {1'b0,reg010};
        out011 = {1'b0,reg011};
        out012 = {1'b0,reg012};
        out013 = {1'b0,reg013};
        out014 = {1'b0,reg014};
        out015 = {1'b0,reg015};
        out016 = {1'b0,reg016};
        out017 = {1'b0,reg017};
        out018 = {1'b0,reg018};
        out019 = {1'b0,reg019};
        out020 = {1'b0,reg020};
        out021 = {1'b0,reg021};
        out022 = {1'b0,reg022};
        out023 = {1'b0,reg023};
        out024 = {1'b0,reg024};
        out025 = {1'b0,reg025};
        out026 = {1'b0,reg026};
        out027 = {1'b0,reg027};
        out028 = {1'b0,reg028};
        out029 = {1'b0,reg029};
        out030 = {1'b0,reg030};
        out031 = {1'b0,reg031};
        out032 = {1'b0,reg032};
        out033 = {1'b0,reg033};
        out034 = {1'b0,reg034};
        out035 = {1'b0,reg035};
        out036 = {1'b0,reg036};
        out037 = {1'b0,reg037};
        out038 = {1'b0,reg038};
        out039 = {1'b0,reg039};
        out040 = {1'b0,reg040};
        out041 = {1'b0,reg041};
        out042 = {1'b0,reg042};
        out043 = {1'b0,reg043};
        out044 = {1'b0,reg044};
        out045 = {1'b0,reg045};
        out046 = {1'b0,reg046};
        out047 = {1'b0,reg047};
        out048 = {1'b0,reg048};
        out049 = {1'b0,reg049};
        out050 = {1'b0,reg050};
        out051 = {1'b0,reg051};
        out052 = {1'b0,reg052};
        out053 = {1'b0,reg053};
        out054 = {1'b0,reg054};
        out055 = {1'b0,reg055};
        out056 = {1'b0,reg056};
        out057 = {1'b0,reg057};
        out058 = {1'b0,reg058};
        out059 = {1'b0,reg059};
        out060 = {1'b0,reg060};
        out061 = {1'b0,reg061};
        out062 = {1'b0,reg062};
        out063 = {1'b0,reg063};
        out064 = {1'b0,reg064};
        out065 = {1'b0,reg065};
        out066 = {1'b0,reg066};
        out067 = {1'b0,reg067};
        out068 = {1'b0,reg068};
        out069 = {1'b0,reg069};
        out070 = {1'b0,reg070};
        out071 = {1'b0,reg071};
        out072 = {1'b0,reg072};
        out073 = {1'b0,reg073};
        out074 = {1'b0,reg074};
        out075 = {1'b0,reg075};
        out076 = {1'b0,reg076};
        out077 = {1'b0,reg077};
        out078 = {1'b0,reg078};
        out079 = {1'b0,reg079};
        out080 = {1'b0,reg080};
        out081 = {1'b0,reg081};
        out082 = {1'b0,reg082};
        out083 = {1'b0,reg083};
        out084 = {1'b0,reg084};
        out085 = {1'b0,reg085};
        out086 = {1'b0,reg086};
        out087 = {1'b0,reg087};
        out088 = {1'b0,reg088};
        out089 = {1'b0,reg089};
        out090 = {1'b0,reg090};
        out091 = {1'b0,reg091};
        out092 = {1'b0,reg092};
        out093 = {1'b0,reg093};
        out094 = {1'b0,reg094};
        out095 = {1'b0,reg095};
        out096 = {1'b0,reg096};
        out097 = {1'b0,reg097};
        out098 = {1'b0,reg098};
        out099 = {1'b0,reg099};
        out100 = {1'b0,reg100};
        out101 = {1'b0,reg101};
        out102 = {1'b0,reg102};
        out103 = {1'b0,reg103};
        out104 = {1'b0,reg104};
        out105 = {1'b0,reg105};
        out106 = {1'b0,reg106};
        out107 = {1'b0,reg107};
        out108 = {1'b0,reg108};
        out109 = {1'b0,reg109};
        out110 = {1'b0,reg110};
        out111 = {1'b0,reg111};
        out112 = {1'b0,reg112};
        out113 = {1'b0,reg113};
        out114 = {1'b0,reg114};
        out115 = {1'b0,reg115};
        out116 = {1'b0,reg116};
        out117 = {1'b0,reg117};
        out118 = {1'b0,reg118};
        out119 = {1'b0,reg119};
        out120 = {1'b0,reg120};
    end
end

/*
0.0625 14'b0_000100
0.1094 14'b0_000111
0.1563 14'b0_001010
0.1719 14'b0_001011
0.2031 14'b0_001101
0.2344 14'b0_001111
0.2500 14'b0_010000
0.3281 14'b0_010101
0.3750 14'b0_011000
0.3906 14'b0_011001
0.4063 14'b0_011010
0.4844 14'b0_011111
0.5781 14'b0_100101
0.6094 14'b0_100111
0.6406 14'b0_101001
0.7500 14'b0_110000
0.7969 14'b0_110011
0.8906 14'b0_111001
0.9531 14'b0_111101
1.0000 14'b1_000000
*/

endmodule