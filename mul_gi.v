
module mul_gi(
    i000_g,i001_g,i002_g,i003_g,i004_g,i005_g,i006_g,i007_g,i008_g,i009_g,
    i010_g,i011_g,i012_g,i013_g,i014_g,i015_g,i016_g,i017_g,i018_g,i019_g,
    i020_g,i021_g,i022_g,i023_g,i024_g,i025_g,i026_g,i027_g,i028_g,i029_g,
    i030_g,i031_g,i032_g,i033_g,i034_g,i035_g,i036_g,i037_g,i038_g,i039_g,
    i040_g,i041_g,i042_g,i043_g,i044_g,i045_g,i046_g,i047_g,i048_g,i049_g,
    i050_g,i051_g,i052_g,i053_g,i054_g,i055_g,i056_g,i057_g,i058_g,i059_g,
    i060_g,i061_g,i062_g,i063_g,i064_g,i065_g,i066_g,i067_g,i068_g,i069_g,
    i070_g,i071_g,i072_g,i073_g,i074_g,i075_g,i076_g,i077_g,i078_g,i079_g,
    i080_g,i081_g,i082_g,i083_g,i084_g,i085_g,i086_g,i087_g,i088_g,i089_g,
    i090_g,i091_g,i092_g,i093_g,i094_g,i095_g,i096_g,i097_g,i098_g,i099_g,
    i100_g,i101_g,i102_g,i103_g,i104_g,i105_g,i106_g,i107_g,i108_g,i109_g,
    i110_g,i111_g,i112_g,i113_g,i114_g,i115_g,i116_g,i117_g,i118_g,i119_g,i120_g,
    i000_i,i001_i,i002_i,i003_i,i004_i,i005_i,i006_i,i007_i,i008_i,i009_i,
    i010_i,i011_i,i012_i,i013_i,i014_i,i015_i,i016_i,i017_i,i018_i,i019_i,
    i020_i,i021_i,i022_i,i023_i,i024_i,i025_i,i026_i,i027_i,i028_i,i029_i,
    i030_i,i031_i,i032_i,i033_i,i034_i,i035_i,i036_i,i037_i,i038_i,i039_i,
    i040_i,i041_i,i042_i,i043_i,i044_i,i045_i,i046_i,i047_i,i048_i,i049_i,
    i050_i,i051_i,i052_i,i053_i,i054_i,i055_i,i056_i,i057_i,i058_i,i059_i,
    i060_i,i061_i,i062_i,i063_i,i064_i,i065_i,i066_i,i067_i,i068_i,i069_i,
    i070_i,i071_i,i072_i,i073_i,i074_i,i075_i,i076_i,i077_i,i078_i,i079_i,
    i080_i,i081_i,i082_i,i083_i,i084_i,i085_i,i086_i,i087_i,i088_i,i089_i,
    i090_i,i091_i,i092_i,i093_i,i094_i,i095_i,i096_i,i097_i,i098_i,i099_i,
    i100_i,i101_i,i102_i,i103_i,i104_i,i105_i,i106_i,i107_i,i108_i,i109_i,
    i110_i,i111_i,i112_i,i113_i,i114_i,i115_i,i116_i,i117_i,i118_i,i119_i,i120_i,
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
input  [13:0] i000_g,i001_g,i002_g,i003_g,i004_g,i005_g,i006_g,i007_g,i008_g,i009_g;
input  [13:0] i010_g,i011_g,i012_g,i013_g,i014_g,i015_g,i016_g,i017_g,i018_g,i019_g;
input  [13:0] i020_g,i021_g,i022_g,i023_g,i024_g,i025_g,i026_g,i027_g,i028_g,i029_g;
input  [13:0] i030_g,i031_g,i032_g,i033_g,i034_g,i035_g,i036_g,i037_g,i038_g,i039_g;
input  [13:0] i040_g,i041_g,i042_g,i043_g,i044_g,i045_g,i046_g,i047_g,i048_g,i049_g;
input  [13:0] i050_g,i051_g,i052_g,i053_g,i054_g,i055_g,i056_g,i057_g,i058_g,i059_g;
input  [13:0] i060_g,i061_g,i062_g,i063_g,i064_g,i065_g,i066_g,i067_g,i068_g,i069_g;
input  [13:0] i070_g,i071_g,i072_g,i073_g,i074_g,i075_g,i076_g,i077_g,i078_g,i079_g;
input  [13:0] i080_g,i081_g,i082_g,i083_g,i084_g,i085_g,i086_g,i087_g,i088_g,i089_g;
input  [13:0] i090_g,i091_g,i092_g,i093_g,i094_g,i095_g,i096_g,i097_g,i098_g,i099_g;
input  [13:0] i100_g,i101_g,i102_g,i103_g,i104_g,i105_g,i106_g,i107_g,i108_g,i109_g;
input  [13:0] i110_g,i111_g,i112_g,i113_g,i114_g,i115_g,i116_g,i117_g,i118_g,i119_g,i120_g;

input  [7:0]  i000_i,i001_i,i002_i,i003_i,i004_i,i005_i,i006_i,i007_i,i008_i,i009_i;
input  [7:0]  i010_i,i011_i,i012_i,i013_i,i014_i,i015_i,i016_i,i017_i,i018_i,i019_i;
input  [7:0]  i020_i,i021_i,i022_i,i023_i,i024_i,i025_i,i026_i,i027_i,i028_i,i029_i;
input  [7:0]  i030_i,i031_i,i032_i,i033_i,i034_i,i035_i,i036_i,i037_i,i038_i,i039_i;
input  [7:0]  i040_i,i041_i,i042_i,i043_i,i044_i,i045_i,i046_i,i047_i,i048_i,i049_i;
input  [7:0]  i050_i,i051_i,i052_i,i053_i,i054_i,i055_i,i056_i,i057_i,i058_i,i059_i;
input  [7:0]  i060_i,i061_i,i062_i,i063_i,i064_i,i065_i,i066_i,i067_i,i068_i,i069_i;
input  [7:0]  i070_i,i071_i,i072_i,i073_i,i074_i,i075_i,i076_i,i077_i,i078_i,i079_i;
input  [7:0]  i080_i,i081_i,i082_i,i083_i,i084_i,i085_i,i086_i,i087_i,i088_i,i089_i;
input  [7:0]  i090_i,i091_i,i092_i,i093_i,i094_i,i095_i,i096_i,i097_i,i098_i,i099_i;
input  [7:0]  i100_i,i101_i,i102_i,i103_i,i104_i,i105_i,i106_i,i107_i,i108_i,i109_i;
input  [7:0]  i110_i,i111_i,i112_i,i113_i,i114_i,i115_i,i116_i,i117_i,i118_i,i119_i,i120_i;

input  [21:0] reg000,reg001,reg002,reg003,reg004,reg005,reg006,reg007,reg008,reg009;
input  [21:0] reg010,reg011,reg012,reg013,reg014,reg015,reg016,reg017,reg018,reg019;
input  [21:0] reg020,reg021,reg022,reg023,reg024,reg025,reg026,reg027,reg028,reg029;
input  [21:0] reg030,reg031,reg032,reg033,reg034,reg035,reg036,reg037,reg038,reg039;
input  [21:0] reg040,reg041,reg042,reg043,reg044,reg045,reg046,reg047,reg048,reg049;
input  [21:0] reg050,reg051,reg052,reg053,reg054,reg055,reg056,reg057,reg058,reg059;
input  [21:0] reg060,reg061,reg062,reg063,reg064,reg065,reg066,reg067,reg068,reg069;
input  [21:0] reg070,reg071,reg072,reg073,reg074,reg075,reg076,reg077,reg078,reg079;
input  [21:0] reg080,reg081,reg082,reg083,reg084,reg085,reg086,reg087,reg088,reg089;
input  [21:0] reg090,reg091,reg092,reg093,reg094,reg095,reg096,reg097,reg098,reg099;
input  [21:0] reg100,reg101,reg102,reg103,reg104,reg105,reg106,reg107,reg108,reg109;
input  [21:0] reg110,reg111,reg112,reg113,reg114,reg115,reg116,reg117,reg118,reg119,reg120;

output reg [21:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009;
output reg [21:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019;
output reg [21:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029;
output reg [21:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039;
output reg [21:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049;
output reg [21:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059;
output reg [21:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069;
output reg [21:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079;
output reg [21:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089;
output reg [21:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099;
output reg [21:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109;
output reg [21:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120;

input   en;

always@(*) begin
    if(en) begin
        out000 = i000_g * i000_i;
        out001 = i001_g * i001_i;
        out002 = i002_g * i002_i;
        out003 = i003_g * i003_i;
        out004 = i004_g * i004_i;
        out005 = i005_g * i005_i;
        out006 = i006_g * i006_i;
        out007 = i007_g * i007_i;
        out008 = i008_g * i008_i;
        out009 = i009_g * i009_i;
        out010 = i010_g * i010_i;
        out011 = i011_g * i011_i;
        out012 = i012_g * i012_i;
        out013 = i013_g * i013_i;
        out014 = i014_g * i014_i;
        out015 = i015_g * i015_i;
        out016 = i016_g * i016_i;
        out017 = i017_g * i017_i;
        out018 = i018_g * i018_i;
        out019 = i019_g * i019_i;
        out020 = i020_g * i020_i;
        out021 = i021_g * i021_i;
        out022 = i022_g * i022_i;
        out023 = i023_g * i023_i;
        out024 = i024_g * i024_i;
        out025 = i025_g * i025_i;
        out026 = i026_g * i026_i;
        out027 = i027_g * i027_i;
        out028 = i028_g * i028_i;
        out029 = i029_g * i029_i;
        out030 = i030_g * i030_i;
        out031 = i031_g * i031_i;
        out032 = i032_g * i032_i;
        out033 = i033_g * i033_i;
        out034 = i034_g * i034_i;
        out035 = i035_g * i035_i;
        out036 = i036_g * i036_i;
        out037 = i037_g * i037_i;
        out038 = i038_g * i038_i;
        out039 = i039_g * i039_i;
        out040 = i040_g * i040_i;
        out041 = i041_g * i041_i;
        out042 = i042_g * i042_i;
        out043 = i043_g * i043_i;
        out044 = i044_g * i044_i;
        out045 = i045_g * i045_i;
        out046 = i046_g * i046_i;
        out047 = i047_g * i047_i;
        out048 = i048_g * i048_i;
        out049 = i049_g * i049_i;
        out050 = i050_g * i050_i;
        out051 = i051_g * i051_i;
        out052 = i052_g * i052_i;
        out053 = i053_g * i053_i;
        out054 = i054_g * i054_i;
        out055 = i055_g * i055_i;
        out056 = i056_g * i056_i;
        out057 = i057_g * i057_i;
        out058 = i058_g * i058_i;
        out059 = i059_g * i059_i;
        out060 = i060_g * i060_i;
        out061 = i061_g * i061_i;
        out062 = i062_g * i062_i;
        out063 = i063_g * i063_i;
        out064 = i064_g * i064_i;
        out065 = i065_g * i065_i;
        out066 = i066_g * i066_i;
        out067 = i067_g * i067_i;
        out068 = i068_g * i068_i;
        out069 = i069_g * i069_i;
        out070 = i070_g * i070_i;
        out071 = i071_g * i071_i;
        out072 = i072_g * i072_i;
        out073 = i073_g * i073_i;
        out074 = i074_g * i074_i;
        out075 = i075_g * i075_i;
        out076 = i076_g * i076_i;
        out077 = i077_g * i077_i;
        out078 = i078_g * i078_i;
        out079 = i079_g * i079_i;
        out080 = i080_g * i080_i;
        out081 = i081_g * i081_i;
        out082 = i082_g * i082_i;
        out083 = i083_g * i083_i;
        out084 = i084_g * i084_i;
        out085 = i085_g * i085_i;
        out086 = i086_g * i086_i;
        out087 = i087_g * i087_i;
        out088 = i088_g * i088_i;
        out089 = i089_g * i089_i;
        out090 = i090_g * i090_i;
        out091 = i091_g * i091_i;
        out092 = i092_g * i092_i;
        out093 = i093_g * i093_i;
        out094 = i094_g * i094_i;
        out095 = i095_g * i095_i;
        out096 = i096_g * i096_i;
        out097 = i097_g * i097_i;
        out098 = i098_g * i098_i;
        out099 = i099_g * i099_i;
        out100 = i100_g * i100_i;
        out101 = i101_g * i101_i;
        out102 = i102_g * i102_i;
        out103 = i103_g * i103_i;
        out104 = i104_g * i104_i;
        out105 = i105_g * i105_i;
        out106 = i106_g * i106_i;
        out107 = i107_g * i107_i;
        out108 = i108_g * i108_i;
        out109 = i109_g * i109_i;
        out110 = i110_g * i110_i;
        out111 = i111_g * i111_i;
        out112 = i112_g * i112_i;
        out113 = i113_g * i113_i;
        out114 = i114_g * i114_i;
        out115 = i115_g * i115_i;
        out116 = i116_g * i116_i;
        out117 = i117_g * i117_i;
        out118 = i118_g * i118_i;
        out119 = i119_g * i119_i;
        out120 = i120_g * i120_i;
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

endmodule