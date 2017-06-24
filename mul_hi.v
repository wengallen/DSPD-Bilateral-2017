
module mul_hi(
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
input  [13:0] i000_h,i001_h,i002_h,i003_h,i004_h,i005_h,i006_h,i007_h,i008_h,i009_h;
input  [13:0] i010_h,i011_h,i012_h,i013_h,i014_h,i015_h,i016_h,i017_h,i018_h,i019_h;
input  [13:0] i020_h,i021_h,i022_h,i023_h,i024_h,i025_h,i026_h,i027_h,i028_h,i029_h;
input  [13:0] i030_h,i031_h,i032_h,i033_h,i034_h,i035_h,i036_h,i037_h,i038_h,i039_h;
input  [13:0] i040_h,i041_h,i042_h,i043_h,i044_h,i045_h,i046_h,i047_h,i048_h,i049_h;
input  [13:0] i050_h,i051_h,i052_h,i053_h,i054_h,i055_h,i056_h,i057_h,i058_h,i059_h;
input  [13:0] i060_h,i061_h,i062_h,i063_h,i064_h,i065_h,i066_h,i067_h,i068_h,i069_h;
input  [13:0] i070_h,i071_h,i072_h,i073_h,i074_h,i075_h,i076_h,i077_h,i078_h,i079_h;
input  [13:0] i080_h,i081_h,i082_h,i083_h,i084_h,i085_h,i086_h,i087_h,i088_h,i089_h;
input  [13:0] i090_h,i091_h,i092_h,i093_h,i094_h,i095_h,i096_h,i097_h,i098_h,i099_h;
input  [13:0] i100_h,i101_h,i102_h,i103_h,i104_h,i105_h,i106_h,i107_h,i108_h,i109_h;
input  [13:0] i110_h,i111_h,i112_h,i113_h,i114_h,i115_h,i116_h,i117_h,i118_h,i119_h,i120_h;

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

output reg [27:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009;
output reg [27:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019;
output reg [27:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029;
output reg [27:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039;
output reg [27:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049;
output reg [27:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059;
output reg [27:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069;
output reg [27:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079;
output reg [27:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089;
output reg [27:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099;
output reg [27:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109;
output reg [27:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120;

input   en;

always@(*) begin
    if(en) begin
        out000 = i000_h * {i000_i,6'b0};
        out001 = i001_h * {i001_i,6'b0};
        out002 = i002_h * {i002_i,6'b0};
        out003 = i003_h * {i003_i,6'b0};
        out004 = i004_h * {i004_i,6'b0};
        out005 = i005_h * {i005_i,6'b0};
        out006 = i006_h * {i006_i,6'b0};
        out007 = i007_h * {i007_i,6'b0};
        out008 = i008_h * {i008_i,6'b0};
        out009 = i009_h * {i009_i,6'b0};
        out010 = i010_h * {i010_i,6'b0};
        out011 = i011_h * {i011_i,6'b0};
        out012 = i012_h * {i012_i,6'b0};
        out013 = i013_h * {i013_i,6'b0};
        out014 = i014_h * {i014_i,6'b0};
        out015 = i015_h * {i015_i,6'b0};
        out016 = i016_h * {i016_i,6'b0};
        out017 = i017_h * {i017_i,6'b0};
        out018 = i018_h * {i018_i,6'b0};
        out019 = i019_h * {i019_i,6'b0};
        out020 = i020_h * {i020_i,6'b0};
        out021 = i021_h * {i021_i,6'b0};
        out022 = i022_h * {i022_i,6'b0};
        out023 = i023_h * {i023_i,6'b0};
        out024 = i024_h * {i024_i,6'b0};
        out025 = i025_h * {i025_i,6'b0};
        out026 = i026_h * {i026_i,6'b0};
        out027 = i027_h * {i027_i,6'b0};
        out028 = i028_h * {i028_i,6'b0};
        out029 = i029_h * {i029_i,6'b0};
        out030 = i030_h * {i030_i,6'b0};
        out031 = i031_h * {i031_i,6'b0};
        out032 = i032_h * {i032_i,6'b0};
        out033 = i033_h * {i033_i,6'b0};
        out034 = i034_h * {i034_i,6'b0};
        out035 = i035_h * {i035_i,6'b0};
        out036 = i036_h * {i036_i,6'b0};
        out037 = i037_h * {i037_i,6'b0};
        out038 = i038_h * {i038_i,6'b0};
        out039 = i039_h * {i039_i,6'b0};
        out040 = i040_h * {i040_i,6'b0};
        out041 = i041_h * {i041_i,6'b0};
        out042 = i042_h * {i042_i,6'b0};
        out043 = i043_h * {i043_i,6'b0};
        out044 = i044_h * {i044_i,6'b0};
        out045 = i045_h * {i045_i,6'b0};
        out046 = i046_h * {i046_i,6'b0};
        out047 = i047_h * {i047_i,6'b0};
        out048 = i048_h * {i048_i,6'b0};
        out049 = i049_h * {i049_i,6'b0};
        out050 = i050_h * {i050_i,6'b0};
        out051 = i051_h * {i051_i,6'b0};
        out052 = i052_h * {i052_i,6'b0};
        out053 = i053_h * {i053_i,6'b0};
        out054 = i054_h * {i054_i,6'b0};
        out055 = i055_h * {i055_i,6'b0};
        out056 = i056_h * {i056_i,6'b0};
        out057 = i057_h * {i057_i,6'b0};
        out058 = i058_h * {i058_i,6'b0};
        out059 = i059_h * {i059_i,6'b0};
        out060 = i060_h * {i060_i,6'b0};
        out061 = i061_h * {i061_i,6'b0};
        out062 = i062_h * {i062_i,6'b0};
        out063 = i063_h * {i063_i,6'b0};
        out064 = i064_h * {i064_i,6'b0};
        out065 = i065_h * {i065_i,6'b0};
        out066 = i066_h * {i066_i,6'b0};
        out067 = i067_h * {i067_i,6'b0};
        out068 = i068_h * {i068_i,6'b0};
        out069 = i069_h * {i069_i,6'b0};
        out070 = i070_h * {i070_i,6'b0};
        out071 = i071_h * {i071_i,6'b0};
        out072 = i072_h * {i072_i,6'b0};
        out073 = i073_h * {i073_i,6'b0};
        out074 = i074_h * {i074_i,6'b0};
        out075 = i075_h * {i075_i,6'b0};
        out076 = i076_h * {i076_i,6'b0};
        out077 = i077_h * {i077_i,6'b0};
        out078 = i078_h * {i078_i,6'b0};
        out079 = i079_h * {i079_i,6'b0};
        out080 = i080_h * {i080_i,6'b0};
        out081 = i081_h * {i081_i,6'b0};
        out082 = i082_h * {i082_i,6'b0};
        out083 = i083_h * {i083_i,6'b0};
        out084 = i084_h * {i084_i,6'b0};
        out085 = i085_h * {i085_i,6'b0};
        out086 = i086_h * {i086_i,6'b0};
        out087 = i087_h * {i087_i,6'b0};
        out088 = i088_h * {i088_i,6'b0};
        out089 = i089_h * {i089_i,6'b0};
        out090 = i090_h * {i090_i,6'b0};
        out091 = i091_h * {i091_i,6'b0};
        out092 = i092_h * {i092_i,6'b0};
        out093 = i093_h * {i093_i,6'b0};
        out094 = i094_h * {i094_i,6'b0};
        out095 = i095_h * {i095_i,6'b0};
        out096 = i096_h * {i096_i,6'b0};
        out097 = i097_h * {i097_i,6'b0};
        out098 = i098_h * {i098_i,6'b0};
        out099 = i099_h * {i099_i,6'b0};
        out100 = i100_h * {i100_i,6'b0};
        out101 = i101_h * {i101_i,6'b0};
        out102 = i102_h * {i102_i,6'b0};
        out103 = i103_h * {i103_i,6'b0};
        out104 = i104_h * {i104_i,6'b0};
        out105 = i105_h * {i105_i,6'b0};
        out106 = i106_h * {i106_i,6'b0};
        out107 = i107_h * {i107_i,6'b0};
        out108 = i108_h * {i108_i,6'b0};
        out109 = i109_h * {i109_i,6'b0};
        out110 = i110_h * {i110_i,6'b0};
        out111 = i111_h * {i111_i,6'b0};
        out112 = i112_h * {i112_i,6'b0};
        out113 = i113_h * {i113_i,6'b0};
        out114 = i114_h * {i114_i,6'b0};
        out115 = i115_h * {i115_i,6'b0};
        out116 = i116_h * {i116_i,6'b0};
        out117 = i117_h * {i117_i,6'b0};
        out118 = i118_h * {i118_i,6'b0};
        out119 = i119_h * {i119_i,6'b0};
        out120 = i120_h * {i120_i,6'b0};
    end
    else begin
        out000 = {{8'b0,reg000},6'b0};
        out001 = {{8'b0,reg001},6'b0};
        out002 = {{8'b0,reg002},6'b0};
        out003 = {{8'b0,reg003},6'b0};
        out004 = {{8'b0,reg004},6'b0};
        out005 = {{8'b0,reg005},6'b0};
        out006 = {{8'b0,reg006},6'b0};
        out007 = {{8'b0,reg007},6'b0};
        out008 = {{8'b0,reg008},6'b0};
        out009 = {{8'b0,reg009},6'b0};
        out010 = {{8'b0,reg010},6'b0};
        out011 = {{8'b0,reg011},6'b0};
        out012 = {{8'b0,reg012},6'b0};
        out013 = {{8'b0,reg013},6'b0};
        out014 = {{8'b0,reg014},6'b0};
        out015 = {{8'b0,reg015},6'b0};
        out016 = {{8'b0,reg016},6'b0};
        out017 = {{8'b0,reg017},6'b0};
        out018 = {{8'b0,reg018},6'b0};
        out019 = {{8'b0,reg019},6'b0};
        out020 = {{8'b0,reg020},6'b0};
        out021 = {{8'b0,reg021},6'b0};
        out022 = {{8'b0,reg022},6'b0};
        out023 = {{8'b0,reg023},6'b0};
        out024 = {{8'b0,reg024},6'b0};
        out025 = {{8'b0,reg025},6'b0};
        out026 = {{8'b0,reg026},6'b0};
        out027 = {{8'b0,reg027},6'b0};
        out028 = {{8'b0,reg028},6'b0};
        out029 = {{8'b0,reg029},6'b0};
        out030 = {{8'b0,reg030},6'b0};
        out031 = {{8'b0,reg031},6'b0};
        out032 = {{8'b0,reg032},6'b0};
        out033 = {{8'b0,reg033},6'b0};
        out034 = {{8'b0,reg034},6'b0};
        out035 = {{8'b0,reg035},6'b0};
        out036 = {{8'b0,reg036},6'b0};
        out037 = {{8'b0,reg037},6'b0};
        out038 = {{8'b0,reg038},6'b0};
        out039 = {{8'b0,reg039},6'b0};
        out040 = {{8'b0,reg040},6'b0};
        out041 = {{8'b0,reg041},6'b0};
        out042 = {{8'b0,reg042},6'b0};
        out043 = {{8'b0,reg043},6'b0};
        out044 = {{8'b0,reg044},6'b0};
        out045 = {{8'b0,reg045},6'b0};
        out046 = {{8'b0,reg046},6'b0};
        out047 = {{8'b0,reg047},6'b0};
        out048 = {{8'b0,reg048},6'b0};
        out049 = {{8'b0,reg049},6'b0};
        out050 = {{8'b0,reg050},6'b0};
        out051 = {{8'b0,reg051},6'b0};
        out052 = {{8'b0,reg052},6'b0};
        out053 = {{8'b0,reg053},6'b0};
        out054 = {{8'b0,reg054},6'b0};
        out055 = {{8'b0,reg055},6'b0};
        out056 = {{8'b0,reg056},6'b0};
        out057 = {{8'b0,reg057},6'b0};
        out058 = {{8'b0,reg058},6'b0};
        out059 = {{8'b0,reg059},6'b0};
        out060 = {{8'b0,reg060},6'b0};
        out061 = {{8'b0,reg061},6'b0};
        out062 = {{8'b0,reg062},6'b0};
        out063 = {{8'b0,reg063},6'b0};
        out064 = {{8'b0,reg064},6'b0};
        out065 = {{8'b0,reg065},6'b0};
        out066 = {{8'b0,reg066},6'b0};
        out067 = {{8'b0,reg067},6'b0};
        out068 = {{8'b0,reg068},6'b0};
        out069 = {{8'b0,reg069},6'b0};
        out070 = {{8'b0,reg070},6'b0};
        out071 = {{8'b0,reg071},6'b0};
        out072 = {{8'b0,reg072},6'b0};
        out073 = {{8'b0,reg073},6'b0};
        out074 = {{8'b0,reg074},6'b0};
        out075 = {{8'b0,reg075},6'b0};
        out076 = {{8'b0,reg076},6'b0};
        out077 = {{8'b0,reg077},6'b0};
        out078 = {{8'b0,reg078},6'b0};
        out079 = {{8'b0,reg079},6'b0};
        out080 = {{8'b0,reg080},6'b0};
        out081 = {{8'b0,reg081},6'b0};
        out082 = {{8'b0,reg082},6'b0};
        out083 = {{8'b0,reg083},6'b0};
        out084 = {{8'b0,reg084},6'b0};
        out085 = {{8'b0,reg085},6'b0};
        out086 = {{8'b0,reg086},6'b0};
        out087 = {{8'b0,reg087},6'b0};
        out088 = {{8'b0,reg088},6'b0};
        out089 = {{8'b0,reg089},6'b0};
        out090 = {{8'b0,reg090},6'b0};
        out091 = {{8'b0,reg091},6'b0};
        out092 = {{8'b0,reg092},6'b0};
        out093 = {{8'b0,reg093},6'b0};
        out094 = {{8'b0,reg094},6'b0};
        out095 = {{8'b0,reg095},6'b0};
        out096 = {{8'b0,reg096},6'b0};
        out097 = {{8'b0,reg097},6'b0};
        out098 = {{8'b0,reg098},6'b0};
        out099 = {{8'b0,reg099},6'b0};
        out100 = {{8'b0,reg100},6'b0};
        out101 = {{8'b0,reg101},6'b0};
        out102 = {{8'b0,reg102},6'b0};
        out103 = {{8'b0,reg103},6'b0};
        out104 = {{8'b0,reg104},6'b0};
        out105 = {{8'b0,reg105},6'b0};
        out106 = {{8'b0,reg106},6'b0};
        out107 = {{8'b0,reg107},6'b0};
        out108 = {{8'b0,reg108},6'b0};
        out109 = {{8'b0,reg109},6'b0};
        out110 = {{8'b0,reg110},6'b0};
        out111 = {{8'b0,reg111},6'b0};
        out112 = {{8'b0,reg112},6'b0};
        out113 = {{8'b0,reg113},6'b0};
        out114 = {{8'b0,reg114},6'b0};
        out115 = {{8'b0,reg115},6'b0};
        out116 = {{8'b0,reg116},6'b0};
        out117 = {{8'b0,reg117},6'b0};
        out118 = {{8'b0,reg118},6'b0};
        out119 = {{8'b0,reg119},6'b0};
        out120 = {{8'b0,reg120},6'b0};
    end
end

endmodule