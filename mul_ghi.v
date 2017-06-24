// Output SNR ≥ 40 dB (test pattern provided)
// Latency ~= 70k cycles
// Clock frequency: 100MHz
// Technology: UMC 0.18μm process

// Bilateral Filter
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
input  [27:0] i000_gi,i001_gi,i002_gi,i003_gi,i004_gi,i005_gi,i006_gi,i007_gi,i008_gi,i009_gi;
input  [27:0] i010_gi,i011_gi,i012_gi,i013_gi,i014_gi,i015_gi,i016_gi,i017_gi,i018_gi,i019_gi;
input  [27:0] i020_gi,i021_gi,i022_gi,i023_gi,i024_gi,i025_gi,i026_gi,i027_gi,i028_gi,i029_gi;
input  [27:0] i030_gi,i031_gi,i032_gi,i033_gi,i034_gi,i035_gi,i036_gi,i037_gi,i038_gi,i039_gi;
input  [27:0] i040_gi,i041_gi,i042_gi,i043_gi,i044_gi,i045_gi,i046_gi,i047_gi,i048_gi,i049_gi;
input  [27:0] i050_gi,i051_gi,i052_gi,i053_gi,i054_gi,i055_gi,i056_gi,i057_gi,i058_gi,i059_gi;
input  [27:0] i060_gi,i061_gi,i062_gi,i063_gi,i064_gi,i065_gi,i066_gi,i067_gi,i068_gi,i069_gi;
input  [27:0] i070_gi,i071_gi,i072_gi,i073_gi,i074_gi,i075_gi,i076_gi,i077_gi,i078_gi,i079_gi;
input  [27:0] i080_gi,i081_gi,i082_gi,i083_gi,i084_gi,i085_gi,i086_gi,i087_gi,i088_gi,i089_gi;
input  [27:0] i090_gi,i091_gi,i092_gi,i093_gi,i094_gi,i095_gi,i096_gi,i097_gi,i098_gi,i099_gi;
input  [27:0] i100_gi,i101_gi,i102_gi,i103_gi,i104_gi,i105_gi,i106_gi,i107_gi,i108_gi,i109_gi;
input  [27:0] i110_gi,i111_gi,i112_gi,i113_gi,i114_gi,i115_gi,i116_gi,i117_gi,i118_gi,i119_gi,i120_gi;

input  [13:0]  i000_h,i001_h,i002_h,i003_h,i004_h,i005_h,i006_h,i007_h,i008_h,i009_h;
input  [13:0]  i010_h,i011_h,i012_h,i013_h,i014_h,i015_h,i016_h,i017_h,i018_h,i019_h;
input  [13:0]  i020_h,i021_h,i022_h,i023_h,i024_h,i025_h,i026_h,i027_h,i028_h,i029_h;
input  [13:0]  i030_h,i031_h,i032_h,i033_h,i034_h,i035_h,i036_h,i037_h,i038_h,i039_h;
input  [13:0]  i040_h,i041_h,i042_h,i043_h,i044_h,i045_h,i046_h,i047_h,i048_h,i049_h;
input  [13:0]  i050_h,i051_h,i052_h,i053_h,i054_h,i055_h,i056_h,i057_h,i058_h,i059_h;
input  [13:0]  i060_h,i061_h,i062_h,i063_h,i064_h,i065_h,i066_h,i067_h,i068_h,i069_h;
input  [13:0]  i070_h,i071_h,i072_h,i073_h,i074_h,i075_h,i076_h,i077_h,i078_h,i079_h;
input  [13:0]  i080_h,i081_h,i082_h,i083_h,i084_h,i085_h,i086_h,i087_h,i088_h,i089_h;
input  [13:0]  i090_h,i091_h,i092_h,i093_h,i094_h,i095_h,i096_h,i097_h,i098_h,i099_h;
input  [13:0]  i100_h,i101_h,i102_h,i103_h,i104_h,i105_h,i106_h,i107_h,i108_h,i109_h;
input  [13:0]  i110_h,i111_h,i112_h,i113_h,i114_h,i115_h,i116_h,i117_h,i118_h,i119_h,i120_h;

input  [27:0] reg000,reg001,reg002,reg003,reg004,reg005,reg006,reg007,reg008,reg009;
input  [27:0] reg010,reg011,reg012,reg013,reg014,reg015,reg016,reg017,reg018,reg019;
input  [27:0] reg020,reg021,reg022,reg023,reg024,reg025,reg026,reg027,reg028,reg029;
input  [27:0] reg030,reg031,reg032,reg033,reg034,reg035,reg036,reg037,reg038,reg039;
input  [27:0] reg040,reg041,reg042,reg043,reg044,reg045,reg046,reg047,reg048,reg049;
input  [27:0] reg050,reg051,reg052,reg053,reg054,reg055,reg056,reg057,reg058,reg059;
input  [27:0] reg060,reg061,reg062,reg063,reg064,reg065,reg066,reg067,reg068,reg069;
input  [27:0] reg070,reg071,reg072,reg073,reg074,reg075,reg076,reg077,reg078,reg079;
input  [27:0] reg080,reg081,reg082,reg083,reg084,reg085,reg086,reg087,reg088,reg089;
input  [27:0] reg090,reg091,reg092,reg093,reg094,reg095,reg096,reg097,reg098,reg099;
input  [27:0] reg100,reg101,reg102,reg103,reg104,reg105,reg106,reg107,reg108,reg109;
input  [27:0] reg110,reg111,reg112,reg113,reg114,reg115,reg116,reg117,reg118,reg119,reg120;

output reg [41:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009;
output reg [41:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019;
output reg [41:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029;
output reg [41:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039;
output reg [41:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049;
output reg [41:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059;
output reg [41:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069;
output reg [41:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079;
output reg [41:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089;
output reg [41:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099;
output reg [41:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109;
output reg [41:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120;

input   en;

always@(*) begin
    if(en) begin
        out000 = i000_gi * {i000_h,6'b0};
        out001 = i001_gi * {i001_h,6'b0};
        out002 = i002_gi * {i002_h,6'b0};
        out003 = i003_gi * {i003_h,6'b0};
        out004 = i004_gi * {i004_h,6'b0};
        out005 = i005_gi * {i005_h,6'b0};
        out006 = i006_gi * {i006_h,6'b0};
        out007 = i007_gi * {i007_h,6'b0};
        out008 = i008_gi * {i008_h,6'b0};
        out009 = i009_gi * {i009_h,6'b0};
        out010 = i010_gi * {i010_h,6'b0};
        out011 = i011_gi * {i011_h,6'b0};
        out012 = i012_gi * {i012_h,6'b0};
        out013 = i013_gi * {i013_h,6'b0};
        out014 = i014_gi * {i014_h,6'b0};
        out015 = i015_gi * {i015_h,6'b0};
        out016 = i016_gi * {i016_h,6'b0};
        out017 = i017_gi * {i017_h,6'b0};
        out018 = i018_gi * {i018_h,6'b0};
        out019 = i019_gi * {i019_h,6'b0};
        out020 = i020_gi * {i020_h,6'b0};
        out021 = i021_gi * {i021_h,6'b0};
        out022 = i022_gi * {i022_h,6'b0};
        out023 = i023_gi * {i023_h,6'b0};
        out024 = i024_gi * {i024_h,6'b0};
        out025 = i025_gi * {i025_h,6'b0};
        out026 = i026_gi * {i026_h,6'b0};
        out027 = i027_gi * {i027_h,6'b0};
        out028 = i028_gi * {i028_h,6'b0};
        out029 = i029_gi * {i029_h,6'b0};
        out030 = i030_gi * {i030_h,6'b0};
        out031 = i031_gi * {i031_h,6'b0};
        out032 = i032_gi * {i032_h,6'b0};
        out033 = i033_gi * {i033_h,6'b0};
        out034 = i034_gi * {i034_h,6'b0};
        out035 = i035_gi * {i035_h,6'b0};
        out036 = i036_gi * {i036_h,6'b0};
        out037 = i037_gi * {i037_h,6'b0};
        out038 = i038_gi * {i038_h,6'b0};
        out039 = i039_gi * {i039_h,6'b0};
        out040 = i040_gi * {i040_h,6'b0};
        out041 = i041_gi * {i041_h,6'b0};
        out042 = i042_gi * {i042_h,6'b0};
        out043 = i043_gi * {i043_h,6'b0};
        out044 = i044_gi * {i044_h,6'b0};
        out045 = i045_gi * {i045_h,6'b0};
        out046 = i046_gi * {i046_h,6'b0};
        out047 = i047_gi * {i047_h,6'b0};
        out048 = i048_gi * {i048_h,6'b0};
        out049 = i049_gi * {i049_h,6'b0};
        out050 = i050_gi * {i050_h,6'b0};
        out051 = i051_gi * {i051_h,6'b0};
        out052 = i052_gi * {i052_h,6'b0};
        out053 = i053_gi * {i053_h,6'b0};
        out054 = i054_gi * {i054_h,6'b0};
        out055 = i055_gi * {i055_h,6'b0};
        out056 = i056_gi * {i056_h,6'b0};
        out057 = i057_gi * {i057_h,6'b0};
        out058 = i058_gi * {i058_h,6'b0};
        out059 = i059_gi * {i059_h,6'b0};
        out060 = i060_gi * {i060_h,6'b0};
        out061 = i061_gi * {i061_h,6'b0};
        out062 = i062_gi * {i062_h,6'b0};
        out063 = i063_gi * {i063_h,6'b0};
        out064 = i064_gi * {i064_h,6'b0};
        out065 = i065_gi * {i065_h,6'b0};
        out066 = i066_gi * {i066_h,6'b0};
        out067 = i067_gi * {i067_h,6'b0};
        out068 = i068_gi * {i068_h,6'b0};
        out069 = i069_gi * {i069_h,6'b0};
        out070 = i070_gi * {i070_h,6'b0};
        out071 = i071_gi * {i071_h,6'b0};
        out072 = i072_gi * {i072_h,6'b0};
        out073 = i073_gi * {i073_h,6'b0};
        out074 = i074_gi * {i074_h,6'b0};
        out075 = i075_gi * {i075_h,6'b0};
        out076 = i076_gi * {i076_h,6'b0};
        out077 = i077_gi * {i077_h,6'b0};
        out078 = i078_gi * {i078_h,6'b0};
        out079 = i079_gi * {i079_h,6'b0};
        out080 = i080_gi * {i080_h,6'b0};
        out081 = i081_gi * {i081_h,6'b0};
        out082 = i082_gi * {i082_h,6'b0};
        out083 = i083_gi * {i083_h,6'b0};
        out084 = i084_gi * {i084_h,6'b0};
        out085 = i085_gi * {i085_h,6'b0};
        out086 = i086_gi * {i086_h,6'b0};
        out087 = i087_gi * {i087_h,6'b0};
        out088 = i088_gi * {i088_h,6'b0};
        out089 = i089_gi * {i089_h,6'b0};
        out090 = i090_gi * {i090_h,6'b0};
        out091 = i091_gi * {i091_h,6'b0};
        out092 = i092_gi * {i092_h,6'b0};
        out093 = i093_gi * {i093_h,6'b0};
        out094 = i094_gi * {i094_h,6'b0};
        out095 = i095_gi * {i095_h,6'b0};
        out096 = i096_gi * {i096_h,6'b0};
        out097 = i097_gi * {i097_h,6'b0};
        out098 = i098_gi * {i098_h,6'b0};
        out099 = i099_gi * {i099_h,6'b0};
        out100 = i100_gi * {i100_h,6'b0};
        out101 = i101_gi * {i101_h,6'b0};
        out102 = i102_gi * {i102_h,6'b0};
        out103 = i103_gi * {i103_h,6'b0};
        out104 = i104_gi * {i104_h,6'b0};
        out105 = i105_gi * {i105_h,6'b0};
        out106 = i106_gi * {i106_h,6'b0};
        out107 = i107_gi * {i107_h,6'b0};
        out108 = i108_gi * {i108_h,6'b0};
        out109 = i109_gi * {i109_h,6'b0};
        out110 = i110_gi * {i110_h,6'b0};
        out111 = i111_gi * {i111_h,6'b0};
        out112 = i112_gi * {i112_h,6'b0};
        out113 = i113_gi * {i113_h,6'b0};
        out114 = i114_gi * {i114_h,6'b0};
        out115 = i115_gi * {i115_h,6'b0};
        out116 = i116_gi * {i116_h,6'b0};
        out117 = i117_gi * {i117_h,6'b0};
        out118 = i118_gi * {i118_h,6'b0};
        out119 = i119_gi * {i119_h,6'b0};
        out120 = i120_gi * {i120_h,6'b0};
    end
    else begin
        out000 = {{8'80,reg000},6'b0};
        out001 = {{8'80,reg001},6'b0};
        out002 = {{8'80,reg002},6'b0};
        out003 = {{8'80,reg003},6'b0};
        out004 = {{8'80,reg004},6'b0};
        out005 = {{8'80,reg005},6'b0};
        out006 = {{8'80,reg006},6'b0};
        out007 = {{8'80,reg007},6'b0};
        out008 = {{8'80,reg008},6'b0};
        out009 = {{8'80,reg009},6'b0};
        out010 = {{8'80,reg010},6'b0};
        out011 = {{8'80,reg011},6'b0};
        out012 = {{8'80,reg012},6'b0};
        out013 = {{8'80,reg013},6'b0};
        out014 = {{8'80,reg014},6'b0};
        out015 = {{8'80,reg015},6'b0};
        out016 = {{8'80,reg016},6'b0};
        out017 = {{8'80,reg017},6'b0};
        out018 = {{8'80,reg018},6'b0};
        out019 = {{8'80,reg019},6'b0};
        out020 = {{8'80,reg020},6'b0};
        out021 = {{8'80,reg021},6'b0};
        out022 = {{8'80,reg022},6'b0};
        out023 = {{8'80,reg023},6'b0};
        out024 = {{8'80,reg024},6'b0};
        out025 = {{8'80,reg025},6'b0};
        out026 = {{8'80,reg026},6'b0};
        out027 = {{8'80,reg027},6'b0};
        out028 = {{8'80,reg028},6'b0};
        out029 = {{8'80,reg029},6'b0};
        out030 = {{8'80,reg030},6'b0};
        out031 = {{8'80,reg031},6'b0};
        out032 = {{8'80,reg032},6'b0};
        out033 = {{8'80,reg033},6'b0};
        out034 = {{8'80,reg034},6'b0};
        out035 = {{8'80,reg035},6'b0};
        out036 = {{8'80,reg036},6'b0};
        out037 = {{8'80,reg037},6'b0};
        out038 = {{8'80,reg038},6'b0};
        out039 = {{8'80,reg039},6'b0};
        out040 = {{8'80,reg040},6'b0};
        out041 = {{8'80,reg041},6'b0};
        out042 = {{8'80,reg042},6'b0};
        out043 = {{8'80,reg043},6'b0};
        out044 = {{8'80,reg044},6'b0};
        out045 = {{8'80,reg045},6'b0};
        out046 = {{8'80,reg046},6'b0};
        out047 = {{8'80,reg047},6'b0};
        out048 = {{8'80,reg048},6'b0};
        out049 = {{8'80,reg049},6'b0};
        out050 = {{8'80,reg050},6'b0};
        out051 = {{8'80,reg051},6'b0};
        out052 = {{8'80,reg052},6'b0};
        out053 = {{8'80,reg053},6'b0};
        out054 = {{8'80,reg054},6'b0};
        out055 = {{8'80,reg055},6'b0};
        out056 = {{8'80,reg056},6'b0};
        out057 = {{8'80,reg057},6'b0};
        out058 = {{8'80,reg058},6'b0};
        out059 = {{8'80,reg059},6'b0};
        out060 = {{8'80,reg060},6'b0};
        out061 = {{8'80,reg061},6'b0};
        out062 = {{8'80,reg062},6'b0};
        out063 = {{8'80,reg063},6'b0};
        out064 = {{8'80,reg064},6'b0};
        out065 = {{8'80,reg065},6'b0};
        out066 = {{8'80,reg066},6'b0};
        out067 = {{8'80,reg067},6'b0};
        out068 = {{8'80,reg068},6'b0};
        out069 = {{8'80,reg069},6'b0};
        out070 = {{8'80,reg070},6'b0};
        out071 = {{8'80,reg071},6'b0};
        out072 = {{8'80,reg072},6'b0};
        out073 = {{8'80,reg073},6'b0};
        out074 = {{8'80,reg074},6'b0};
        out075 = {{8'80,reg075},6'b0};
        out076 = {{8'80,reg076},6'b0};
        out077 = {{8'80,reg077},6'b0};
        out078 = {{8'80,reg078},6'b0};
        out079 = {{8'80,reg079},6'b0};
        out080 = {{8'80,reg080},6'b0};
        out081 = {{8'80,reg081},6'b0};
        out082 = {{8'80,reg082},6'b0};
        out083 = {{8'80,reg083},6'b0};
        out084 = {{8'80,reg084},6'b0};
        out085 = {{8'80,reg085},6'b0};
        out086 = {{8'80,reg086},6'b0};
        out087 = {{8'80,reg087},6'b0};
        out088 = {{8'80,reg088},6'b0};
        out089 = {{8'80,reg089},6'b0};
        out090 = {{8'80,reg090},6'b0};
        out091 = {{8'80,reg091},6'b0};
        out092 = {{8'80,reg092},6'b0};
        out093 = {{8'80,reg093},6'b0};
        out094 = {{8'80,reg094},6'b0};
        out095 = {{8'80,reg095},6'b0};
        out096 = {{8'80,reg096},6'b0};
        out097 = {{8'80,reg097},6'b0};
        out098 = {{8'80,reg098},6'b0};
        out099 = {{8'80,reg099},6'b0};
        out100 = {{8'80,reg100},6'b0};
        out101 = {{8'80,reg101},6'b0};
        out102 = {{8'80,reg102},6'b0};
        out103 = {{8'80,reg103},6'b0};
        out104 = {{8'80,reg104},6'b0};
        out105 = {{8'80,reg105},6'b0};
        out106 = {{8'80,reg106},6'b0};
        out107 = {{8'80,reg107},6'b0};
        out108 = {{8'80,reg108},6'b0};
        out109 = {{8'80,reg109},6'b0};
        out110 = {{8'80,reg110},6'b0};
        out111 = {{8'80,reg111},6'b0};
        out112 = {{8'80,reg112},6'b0};
        out113 = {{8'80,reg113},6'b0};
        out114 = {{8'80,reg114},6'b0};
        out115 = {{8'80,reg115},6'b0};
        out116 = {{8'80,reg116},6'b0};
        out117 = {{8'80,reg117},6'b0};
        out118 = {{8'80,reg118},6'b0};
        out119 = {{8'80,reg119},6'b0};
        out120 = {{8'80,reg120},6'b0};
    end
end

endmodule