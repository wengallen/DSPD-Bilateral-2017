
module mul_gh(
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

input  [12:0] reg000,reg001,reg002,reg003,reg004,reg005,reg006,reg007,reg008,reg009; // [19:0]
input  [12:0] reg010,reg011,reg012,reg013,reg014,reg015,reg016,reg017,reg018,reg019; // [19:0]
input  [12:0] reg020,reg021,reg022,reg023,reg024,reg025,reg026,reg027,reg028,reg029; // [19:0]
input  [12:0] reg030,reg031,reg032,reg033,reg034,reg035,reg036,reg037,reg038,reg039; // [19:0]
input  [12:0] reg040,reg041,reg042,reg043,reg044,reg045,reg046,reg047,reg048,reg049; // [19:0]
input  [12:0] reg050,reg051,reg052,reg053,reg054,reg055,reg056,reg057,reg058,reg059; // [19:0]
input  [12:0] reg060,reg061,reg062,reg063,reg064,reg065,reg066,reg067,reg068,reg069; // [19:0]
input  [12:0] reg070,reg071,reg072,reg073,reg074,reg075,reg076,reg077,reg078,reg079; // [19:0]
input  [12:0] reg080,reg081,reg082,reg083,reg084,reg085,reg086,reg087,reg088,reg089; // [19:0]
input  [12:0] reg090,reg091,reg092,reg093,reg094,reg095,reg096,reg097,reg098,reg099; // [19:0]
input  [12:0] reg100,reg101,reg102,reg103,reg104,reg105,reg106,reg107,reg108,reg109; // [19:0]
input  [12:0] reg110,reg111,reg112,reg113,reg114,reg115,reg116,reg117,reg118,reg119,reg120; // [19:0]

output reg [13:0] out000,out001,out002,out003,out004,out005,out006,out007,out008,out009; // [20:0]
output reg [13:0] out010,out011,out012,out013,out014,out015,out016,out017,out018,out019; // [20:0]
output reg [13:0] out020,out021,out022,out023,out024,out025,out026,out027,out028,out029; // [20:0]
output reg [13:0] out030,out031,out032,out033,out034,out035,out036,out037,out038,out039; // [20:0]
output reg [13:0] out040,out041,out042,out043,out044,out045,out046,out047,out048,out049; // [20:0]
output reg [13:0] out050,out051,out052,out053,out054,out055,out056,out057,out058,out059; // [20:0]
output reg [13:0] out060,out061,out062,out063,out064,out065,out066,out067,out068,out069; // [20:0]
output reg [13:0] out070,out071,out072,out073,out074,out075,out076,out077,out078,out079; // [20:0]
output reg [13:0] out080,out081,out082,out083,out084,out085,out086,out087,out088,out089; // [20:0]
output reg [13:0] out090,out091,out092,out093,out094,out095,out096,out097,out098,out099; // [20:0]
output reg [13:0] out100,out101,out102,out103,out104,out105,out106,out107,out108,out109; // [20:0]
output reg [13:0] out110,out111,out112,out113,out114,out115,out116,out117,out118,out119,out120; // [20:0]

input   en;

always@(*) begin
    if(en) begin
        out000 = i000_h * 7'b0_000100; //0.0625
        out001 = i001_h * 7'b0_000111; //0.1094
        out002 = i002_h * 7'b0_001010; //0.1563
        out003 = i003_h * 7'b0_001101; //0.2031
        out004 = i004_h * 7'b0_001111; //0.2344
        out005 = i005_h * 7'b0_010000; //0.2500
        out006 = i006_h * 7'b0_001111; //0.2344
        out007 = i007_h * 7'b0_001101; //0.2031
        out008 = i008_h * 7'b0_001010; //0.1563
        out009 = i009_h * 7'b0_000111; //0.1094
        out010 = i010_h * 7'b0_000100; //0.0625
        out011 = i011_h * 7'b0_000111; //0.1094
        out012 = i012_h * 7'b0_001011; //0.1719
        out013 = i013_h * 7'b0_010000; //0.2500
        out014 = i014_h * 7'b0_010101; //0.3281
        out015 = i015_h * 7'b0_011001; //0.3906
        out016 = i016_h * 7'b0_011010; //0.4063
        out017 = i017_h * 7'b0_011001; //0.3906
        out018 = i018_h * 7'b0_010101; //0.3281
        out019 = i019_h * 7'b0_010000; //0.2500
        out020 = i020_h * 7'b0_001011; //0.1719
        out021 = i021_h * 7'b0_000111; //0.1094
        out022 = i022_h * 7'b0_001010; //0.1563
        out023 = i023_h * 7'b0_010000; //0.2500
        out024 = i024_h * 7'b0_011000; //0.3750
        out025 = i025_h * 7'b0_011111; //0.4844
        out026 = i026_h * 7'b0_100101; //0.5781
        out027 = i027_h * 7'b0_100111; //0.6094
        out028 = i028_h * 7'b0_100101; //0.5781
        out029 = i029_h * 7'b0_011111; //0.4844
        out030 = i030_h * 7'b0_011000; //0.3750
        out031 = i031_h * 7'b0_010000; //0.2500
        out032 = i032_h * 7'b0_001010; //0.1563
        out033 = i033_h * 7'b0_001101; //0.2031
        out034 = i034_h * 7'b0_010101; //0.3281
        out035 = i035_h * 7'b0_011111; //0.4844
        out036 = i036_h * 7'b0_101001; //0.6406
        out037 = i037_h * 7'b0_110000; //0.7500
        out038 = i038_h * 7'b0_110011; //0.7969
        out039 = i039_h * 7'b0_110000; //0.7500
        out040 = i040_h * 7'b0_101001; //0.6406
        out041 = i041_h * 7'b0_011111; //0.4844
        out042 = i042_h * 7'b0_010101; //0.3281
        out043 = i043_h * 7'b0_001101; //0.2031
        out044 = i044_h * 7'b0_001111; //0.2344
        out045 = i045_h * 7'b0_011001; //0.3906
        out046 = i046_h * 7'b0_100101; //0.5781
        out047 = i047_h * 7'b0_110000; //0.7500
        out048 = i048_h * 7'b0_111001; //0.8906
        out049 = i049_h * 7'b0_111101; //0.9531
        out050 = i050_h * 7'b0_111001; //0.8906
        out051 = i051_h * 7'b0_110000; //0.7500
        out052 = i052_h * 7'b0_100101; //0.5781
        out053 = i053_h * 7'b0_011001; //0.3906
        out054 = i054_h * 7'b0_001111; //0.2344
        out055 = i055_h * 7'b0_010000; //0.2500
        out056 = i056_h * 7'b0_011010; //0.4063
        out057 = i057_h * 7'b0_100111; //0.6094
        out058 = i058_h * 7'b0_110011; //0.7969
        out059 = i059_h * 7'b0_111101; //0.9531
        out060 = i060_h * 7'b1_000000; //1.0000
        out061 = i061_h * 7'b0_111101; //0.9531
        out062 = i062_h * 7'b0_110011; //0.7969
        out063 = i063_h * 7'b0_100111; //0.6094
        out064 = i064_h * 7'b0_011010; //0.4063
        out065 = i065_h * 7'b0_010000; //0.2500
        out066 = i066_h * 7'b0_001111; //0.2344
        out067 = i067_h * 7'b0_011001; //0.3906
        out068 = i068_h * 7'b0_100101; //0.5781
        out069 = i069_h * 7'b0_110000; //0.7500
        out070 = i070_h * 7'b0_111001; //0.8906
        out071 = i071_h * 7'b0_111101; //0.9531
        out072 = i072_h * 7'b0_111001; //0.8906
        out073 = i073_h * 7'b0_110000; //0.7500
        out074 = i074_h * 7'b0_100101; //0.5781
        out075 = i075_h * 7'b0_011001; //0.3906
        out076 = i076_h * 7'b0_001111; //0.2344
        out077 = i077_h * 7'b0_001101; //0.2031
        out078 = i078_h * 7'b0_010101; //0.3281
        out079 = i079_h * 7'b0_011111; //0.4844
        out080 = i080_h * 7'b0_101001; //0.6406
        out081 = i081_h * 7'b0_110000; //0.7500
        out082 = i082_h * 7'b0_110011; //0.7969
        out083 = i083_h * 7'b0_110000; //0.7500
        out084 = i084_h * 7'b0_101001; //0.6406
        out085 = i085_h * 7'b0_011111; //0.4844
        out086 = i086_h * 7'b0_010101; //0.3281
        out087 = i087_h * 7'b0_001101; //0.2031
        out088 = i088_h * 7'b0_001010; //0.1563
        out089 = i089_h * 7'b0_010000; //0.2500
        out090 = i090_h * 7'b0_011000; //0.3750
        out091 = i091_h * 7'b0_011111; //0.4844
        out092 = i092_h * 7'b0_100101; //0.5781
        out093 = i093_h * 7'b0_100111; //0.6094
        out094 = i094_h * 7'b0_100101; //0.5781
        out095 = i095_h * 7'b0_011111; //0.4844
        out096 = i096_h * 7'b0_011000; //0.3750
        out097 = i097_h * 7'b0_010000; //0.2500
        out098 = i098_h * 7'b0_001010; //0.1563
        out099 = i099_h * 7'b0_000111; //0.1094
        out100 = i100_h * 7'b0_001011; //0.1719
        out101 = i101_h * 7'b0_010000; //0.2500
        out102 = i102_h * 7'b0_010101; //0.3281
        out103 = i103_h * 7'b0_011001; //0.3906
        out104 = i104_h * 7'b0_011010; //0.4063
        out105 = i105_h * 7'b0_011001; //0.3906
        out106 = i106_h * 7'b0_010101; //0.3281
        out107 = i107_h * 7'b0_010000; //0.2500
        out108 = i108_h * 7'b0_001011; //0.1719
        out109 = i109_h * 7'b0_000111; //0.1094
        out110 = i110_h * 7'b0_000100; //0.0625
        out111 = i111_h * 7'b0_000111; //0.1094
        out112 = i112_h * 7'b0_001010; //0.1563
        out113 = i113_h * 7'b0_001101; //0.2031
        out114 = i114_h * 7'b0_001111; //0.2344
        out115 = i115_h * 7'b0_010000; //0.2500
        out116 = i116_h * 7'b0_001111; //0.2344
        out117 = i117_h * 7'b0_001101; //0.2031
        out118 = i118_h * 7'b0_001010; //0.1563
        out119 = i119_h * 7'b0_000111; //0.1094
        out120 = i120_h * 7'b0_000100; //0.0625
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