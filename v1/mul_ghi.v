
module mul_ghi(
    i000_gi,i001_gi,i002_gi,i003_gi,i004_gi,i005_gi,i006_gi,i007_gi,i008_gi,i009_gi,
    i010_gi,i011_gi,i012_gi,i013_gi,i014_gi,i015_gi,i016_gi,i017_gi,i018_gi,i019_gi,
    i020_gi,i021_gi,i022_gi,i023_gi,i024_gi,i025_gi,i026_gi,i027_gi,i028_gi,i029_gi,
    i030_gi,i031_gi,i032_gi,i033_gi,i034_gi,i035_gi,i036_gi,i037_gi,i038_gi,i039_gi,
    i040_gi,i041_gi,i042_gi,i043_gi,i044_gi,i045_gi,i046_gi,i047_gi,i048_gi,i049_gi,
    i050_gi,i051_gi,i052_gi,i053_gi,i054_gi,i055_gi,i056_gi,i057_gi,i058_gi,i059_gi,
    i060_gi,i061_gi,i062_gi,i063_gi,i064_gi,i065_gi,i066_gi,i067_gi,i068_gi,i069_gi,
    i070_gi,i071_gi,i072_gi,i073_gi,i074_gi,i075_gi,i076_gi,i077_gi,i078_gi,i079_gi,
    i080_gi,i081_gi,i082_gi,i083_gi,i084_gi,i085_gi,i086_gi,i087_gi,i088_gi,i089_gi,
    i090_gi,i091_gi,i092_gi,i093_gi,i094_gi,i095_gi,i096_gi,i097_gi,i098_gi,i099_gi,
    i100_gi,i101_gi,i102_gi,i103_gi,i104_gi,i105_gi,i106_gi,i107_gi,i108_gi,i109_gi,
    i110_gi,i111_gi,i112_gi,i113_gi,i114_gi,i115_gi,i116_gi,i117_gi,i118_gi,i119_gi,i120_gi,
    i000_h,i001_h,i002_h,i003_h,i004_h,i005_h,i006_h,i007_h,i008_h,i009_h,
    i010_h,i011_h,i012_h,i013_h,i014_h,i015_h,i016_h,i017_h,i018_h,i019_h,
    i020_h,i021_h,i022_h,i023_h,i024_h,i025_h,i026_h,i027_h,i028_h,i029_h,
    i030_h,i031_h,i032_h,i033_h,i034_h,i035_h,i036_h,i037_h,i038_h,i039_h,
    i040_h,i041_h,i042_h,i043_h,i044_h,i045_h,i046_h,i047_h,i048_h,i049_h,
    i050_h,i051_h,i052_h,i053_h,i054_h,i055_h,i056_h,i057_h,i058_h,i059_h,
    i060_h,i061_h,i062_h,i063_h,i064_h,i065_h,i066_h,i067_h,i068_h,i069_h,
    i070_h,i071_h,i072_h,i073_h,i074_h,i075_h,i076_h,i077_h,i078_h,i079_h,
    i080_h,i081_h,i082_h,i083_h,i084_h,i085_h,i086_h,i087_h,i088_h,i089_h,
    i090_h,i091_h,i092_h,i093_h,i094_h,i095_h,i096_h,i097_h,i098_h,i099_h,
    i100_h,i101_h,i102_h,i103_h,i104_h,i105_h,i106_h,i107_h,i108_h,i109_h,
    i110_h,i111_h,i112_h,i113_h,i114_h,i115_h,i116_h,i117_h,i118_h,i119_h,i120_h,
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
input  [13:0] i000_gi,i001_gi,i002_gi,i003_gi,i004_gi,i005_gi,i006_gi,i007_gi,i008_gi,i009_gi;
input  [13:0] i010_gi,i011_gi,i012_gi,i013_gi,i014_gi,i015_gi,i016_gi,i017_gi,i018_gi,i019_gi;
input  [13:0] i020_gi,i021_gi,i022_gi,i023_gi,i024_gi,i025_gi,i026_gi,i027_gi,i028_gi,i029_gi;
input  [13:0] i030_gi,i031_gi,i032_gi,i033_gi,i034_gi,i035_gi,i036_gi,i037_gi,i038_gi,i039_gi;
input  [13:0] i040_gi,i041_gi,i042_gi,i043_gi,i044_gi,i045_gi,i046_gi,i047_gi,i048_gi,i049_gi;
input  [13:0] i050_gi,i051_gi,i052_gi,i053_gi,i054_gi,i055_gi,i056_gi,i057_gi,i058_gi,i059_gi;
input  [13:0] i060_gi,i061_gi,i062_gi,i063_gi,i064_gi,i065_gi,i066_gi,i067_gi,i068_gi,i069_gi;
input  [13:0] i070_gi,i071_gi,i072_gi,i073_gi,i074_gi,i075_gi,i076_gi,i077_gi,i078_gi,i079_gi;
input  [13:0] i080_gi,i081_gi,i082_gi,i083_gi,i084_gi,i085_gi,i086_gi,i087_gi,i088_gi,i089_gi;
input  [13:0] i090_gi,i091_gi,i092_gi,i093_gi,i094_gi,i095_gi,i096_gi,i097_gi,i098_gi,i099_gi;
input  [13:0] i100_gi,i101_gi,i102_gi,i103_gi,i104_gi,i105_gi,i106_gi,i107_gi,i108_gi,i109_gi;
input  [13:0] i110_gi,i111_gi,i112_gi,i113_gi,i114_gi,i115_gi,i116_gi,i117_gi,i118_gi,i119_gi,i120_gi;

input  [6:0]  i000_h,i001_h,i002_h,i003_h,i004_h,i005_h,i006_h,i007_h,i008_h,i009_h;
input  [6:0]  i010_h,i011_h,i012_h,i013_h,i014_h,i015_h,i016_h,i017_h,i018_h,i019_h;
input  [6:0]  i020_h,i021_h,i022_h,i023_h,i024_h,i025_h,i026_h,i027_h,i028_h,i029_h;
input  [6:0]  i030_h,i031_h,i032_h,i033_h,i034_h,i035_h,i036_h,i037_h,i038_h,i039_h;
input  [6:0]  i040_h,i041_h,i042_h,i043_h,i044_h,i045_h,i046_h,i047_h,i048_h,i049_h;
input  [6:0]  i050_h,i051_h,i052_h,i053_h,i054_h,i055_h,i056_h,i057_h,i058_h,i059_h;
input  [6:0]  i060_h,i061_h,i062_h,i063_h,i064_h,i065_h,i066_h,i067_h,i068_h,i069_h;
input  [6:0]  i070_h,i071_h,i072_h,i073_h,i074_h,i075_h,i076_h,i077_h,i078_h,i079_h;
input  [6:0]  i080_h,i081_h,i082_h,i083_h,i084_h,i085_h,i086_h,i087_h,i088_h,i089_h;
input  [6:0]  i090_h,i091_h,i092_h,i093_h,i094_h,i095_h,i096_h,i097_h,i098_h,i099_h;
input  [6:0]  i100_h,i101_h,i102_h,i103_h,i104_h,i105_h,i106_h,i107_h,i108_h,i109_h;
input  [6:0]  i110_h,i111_h,i112_h,i113_h,i114_h,i115_h,i116_h,i117_h,i118_h,i119_h,i120_h;

input  [19:0] reg000,reg001,reg002,reg003,reg004,reg005,reg006,reg007,reg008,reg009;
input  [19:0] reg010,reg011,reg012,reg013,reg014,reg015,reg016,reg017,reg018,reg019;
input  [19:0] reg020,reg021,reg022,reg023,reg024,reg025,reg026,reg027,reg028,reg029;
input  [19:0] reg030,reg031,reg032,reg033,reg034,reg035,reg036,reg037,reg038,reg039;
input  [19:0] reg040,reg041,reg042,reg043,reg044,reg045,reg046,reg047,reg048,reg049;
input  [19:0] reg050,reg051,reg052,reg053,reg054,reg055,reg056,reg057,reg058,reg059;
input  [19:0] reg060,reg061,reg062,reg063,reg064,reg065,reg066,reg067,reg068,reg069;
input  [19:0] reg070,reg071,reg072,reg073,reg074,reg075,reg076,reg077,reg078,reg079;
input  [19:0] reg080,reg081,reg082,reg083,reg084,reg085,reg086,reg087,reg088,reg089;
input  [19:0] reg090,reg091,reg092,reg093,reg094,reg095,reg096,reg097,reg098,reg099;
input  [19:0] reg100,reg101,reg102,reg103,reg104,reg105,reg106,reg107,reg108,reg109;
input  [19:0] reg110,reg111,reg112,reg113,reg114,reg115,reg116,reg117,reg118,reg119,reg120;

output reg [20:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009;
output reg [20:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019;
output reg [20:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029;
output reg [20:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039;
output reg [20:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049;
output reg [20:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059;
output reg [20:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069;
output reg [20:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079;
output reg [20:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089;
output reg [20:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099;
output reg [20:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109;
output reg [20:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120;

input   en;

always@(*) begin
    if(en) begin
        out000 = i000_gi * i000_h;
        out001 = i001_gi * i001_h;
        out002 = i002_gi * i002_h;
        out003 = i003_gi * i003_h;
        out004 = i004_gi * i004_h;
        out005 = i005_gi * i005_h;
        out006 = i006_gi * i006_h;
        out007 = i007_gi * i007_h;
        out008 = i008_gi * i008_h;
        out009 = i009_gi * i009_h;
        out010 = i010_gi * i010_h;
        out011 = i011_gi * i011_h;
        out012 = i012_gi * i012_h;
        out013 = i013_gi * i013_h;
        out014 = i014_gi * i014_h;
        out015 = i015_gi * i015_h;
        out016 = i016_gi * i016_h;
        out017 = i017_gi * i017_h;
        out018 = i018_gi * i018_h;
        out019 = i019_gi * i019_h;
        out020 = i020_gi * i020_h;
        out021 = i021_gi * i021_h;
        out022 = i022_gi * i022_h;
        out023 = i023_gi * i023_h;
        out024 = i024_gi * i024_h;
        out025 = i025_gi * i025_h;
        out026 = i026_gi * i026_h;
        out027 = i027_gi * i027_h;
        out028 = i028_gi * i028_h;
        out029 = i029_gi * i029_h;
        out030 = i030_gi * i030_h;
        out031 = i031_gi * i031_h;
        out032 = i032_gi * i032_h;
        out033 = i033_gi * i033_h;
        out034 = i034_gi * i034_h;
        out035 = i035_gi * i035_h;
        out036 = i036_gi * i036_h;
        out037 = i037_gi * i037_h;
        out038 = i038_gi * i038_h;
        out039 = i039_gi * i039_h;
        out040 = i040_gi * i040_h;
        out041 = i041_gi * i041_h;
        out042 = i042_gi * i042_h;
        out043 = i043_gi * i043_h;
        out044 = i044_gi * i044_h;
        out045 = i045_gi * i045_h;
        out046 = i046_gi * i046_h;
        out047 = i047_gi * i047_h;
        out048 = i048_gi * i048_h;
        out049 = i049_gi * i049_h;
        out050 = i050_gi * i050_h;
        out051 = i051_gi * i051_h;
        out052 = i052_gi * i052_h;
        out053 = i053_gi * i053_h;
        out054 = i054_gi * i054_h;
        out055 = i055_gi * i055_h;
        out056 = i056_gi * i056_h;
        out057 = i057_gi * i057_h;
        out058 = i058_gi * i058_h;
        out059 = i059_gi * i059_h;
        out060 = i060_gi * i060_h;
        out061 = i061_gi * i061_h;
        out062 = i062_gi * i062_h;
        out063 = i063_gi * i063_h;
        out064 = i064_gi * i064_h;
        out065 = i065_gi * i065_h;
        out066 = i066_gi * i066_h;
        out067 = i067_gi * i067_h;
        out068 = i068_gi * i068_h;
        out069 = i069_gi * i069_h;
        out070 = i070_gi * i070_h;
        out071 = i071_gi * i071_h;
        out072 = i072_gi * i072_h;
        out073 = i073_gi * i073_h;
        out074 = i074_gi * i074_h;
        out075 = i075_gi * i075_h;
        out076 = i076_gi * i076_h;
        out077 = i077_gi * i077_h;
        out078 = i078_gi * i078_h;
        out079 = i079_gi * i079_h;
        out080 = i080_gi * i080_h;
        out081 = i081_gi * i081_h;
        out082 = i082_gi * i082_h;
        out083 = i083_gi * i083_h;
        out084 = i084_gi * i084_h;
        out085 = i085_gi * i085_h;
        out086 = i086_gi * i086_h;
        out087 = i087_gi * i087_h;
        out088 = i088_gi * i088_h;
        out089 = i089_gi * i089_h;
        out090 = i090_gi * i090_h;
        out091 = i091_gi * i091_h;
        out092 = i092_gi * i092_h;
        out093 = i093_gi * i093_h;
        out094 = i094_gi * i094_h;
        out095 = i095_gi * i095_h;
        out096 = i096_gi * i096_h;
        out097 = i097_gi * i097_h;
        out098 = i098_gi * i098_h;
        out099 = i099_gi * i099_h;
        out100 = i100_gi * i100_h;
        out101 = i101_gi * i101_h;
        out102 = i102_gi * i102_h;
        out103 = i103_gi * i103_h;
        out104 = i104_gi * i104_h;
        out105 = i105_gi * i105_h;
        out106 = i106_gi * i106_h;
        out107 = i107_gi * i107_h;
        out108 = i108_gi * i108_h;
        out109 = i109_gi * i109_h;
        out110 = i110_gi * i110_h;
        out111 = i111_gi * i111_h;
        out112 = i112_gi * i112_h;
        out113 = i113_gi * i113_h;
        out114 = i114_gi * i114_h;
        out115 = i115_gi * i115_h;
        out116 = i116_gi * i116_h;
        out117 = i117_gi * i117_h;
        out118 = i118_gi * i118_h;
        out119 = i119_gi * i119_h;
        out120 = i120_gi * i120_h;
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

endmodule