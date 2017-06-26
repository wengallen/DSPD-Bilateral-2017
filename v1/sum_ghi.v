
module sum_ghi(
    ghi000,ghi001,ghi002,ghi003,ghi004,ghi005,ghi006,ghi007,ghi008,ghi009,
    ghi010,ghi011,ghi012,ghi013,ghi014,ghi015,ghi016,ghi017,ghi018,ghi019,
    ghi020,ghi021,ghi022,ghi023,ghi024,ghi025,ghi026,ghi027,ghi028,ghi029,
    ghi030,ghi031,ghi032,ghi033,ghi034,ghi035,ghi036,ghi037,ghi038,ghi039,
    ghi040,ghi041,ghi042,ghi043,ghi044,ghi045,ghi046,ghi047,ghi048,ghi049,
    ghi050,ghi051,ghi052,ghi053,ghi054,ghi055,ghi056,ghi057,ghi058,ghi059,
    ghi060,ghi061,ghi062,ghi063,ghi064,ghi065,ghi066,ghi067,ghi068,ghi069,
    ghi070,ghi071,ghi072,ghi073,ghi074,ghi075,ghi076,ghi077,ghi078,ghi079,
    ghi080,ghi081,ghi082,ghi083,ghi084,ghi085,ghi086,ghi087,ghi088,ghi089,
    ghi090,ghi091,ghi092,ghi093,ghi094,ghi095,ghi096,ghi097,ghi098,ghi099,
    ghi100,ghi101,ghi102,ghi103,ghi104,ghi105,ghi106,ghi107,ghi108,ghi109,
    ghi110,ghi111,ghi112,ghi113,ghi114,ghi115,ghi116,ghi117,ghi118,ghi119,ghi120,
    reg_sum,out_sum,
    en
);

//==== I/O port ==========================
input  [19:0] ghi000,ghi001,ghi002,ghi003,ghi004,ghi005,ghi006,ghi007,ghi008,ghi009;
input  [19:0] ghi010,ghi011,ghi012,ghi013,ghi014,ghi015,ghi016,ghi017,ghi018,ghi019;
input  [19:0] ghi020,ghi021,ghi022,ghi023,ghi024,ghi025,ghi026,ghi027,ghi028,ghi029;
input  [19:0] ghi030,ghi031,ghi032,ghi033,ghi034,ghi035,ghi036,ghi037,ghi038,ghi039;
input  [19:0] ghi040,ghi041,ghi042,ghi043,ghi044,ghi045,ghi046,ghi047,ghi048,ghi049;
input  [19:0] ghi050,ghi051,ghi052,ghi053,ghi054,ghi055,ghi056,ghi057,ghi058,ghi059;
input  [19:0] ghi060,ghi061,ghi062,ghi063,ghi064,ghi065,ghi066,ghi067,ghi068,ghi069;
input  [19:0] ghi070,ghi071,ghi072,ghi073,ghi074,ghi075,ghi076,ghi077,ghi078,ghi079;
input  [19:0] ghi080,ghi081,ghi082,ghi083,ghi084,ghi085,ghi086,ghi087,ghi088,ghi089;
input  [19:0] ghi090,ghi091,ghi092,ghi093,ghi094,ghi095,ghi096,ghi097,ghi098,ghi099;
input  [19:0] ghi100,ghi101,ghi102,ghi103,ghi104,ghi105,ghi106,ghi107,ghi108,ghi109;
input  [19:0] ghi110,ghi111,ghi112,ghi113,ghi114,ghi115,ghi116,ghi117,ghi118,ghi119,ghi120;

output reg [26:0] out_sum;
input      [26:0] reg_sum;
input             en;

wire [20:0] temp2[0:60];
wire [21:0] temp4[0:30];
wire [22:0] temp8[0:15];
wire [23:0] temp16[0:7];
wire [24:0] temp32[0:3];
wire [25:0] temp64[0:1];

assign temp2[0 ] = ghi000 + ghi001;
assign temp2[1 ] = ghi002 + ghi003;
assign temp2[2 ] = ghi004 + ghi005;
assign temp2[3 ] = ghi006 + ghi007;
assign temp2[4 ] = ghi008 + ghi009;
assign temp2[5 ] = ghi010 + ghi011;
assign temp2[6 ] = ghi012 + ghi013;
assign temp2[7 ] = ghi014 + ghi015;
assign temp2[8 ] = ghi016 + ghi017;
assign temp2[9 ] = ghi018 + ghi019;
assign temp2[10] = ghi020 + ghi021;
assign temp2[11] = ghi022 + ghi023;
assign temp2[12] = ghi024 + ghi025;
assign temp2[13] = ghi026 + ghi027;
assign temp2[14] = ghi028 + ghi029;
assign temp2[15] = ghi030 + ghi031;
assign temp2[16] = ghi032 + ghi033;
assign temp2[17] = ghi034 + ghi035;
assign temp2[18] = ghi036 + ghi037;
assign temp2[19] = ghi038 + ghi039;
assign temp2[20] = ghi040 + ghi041;
assign temp2[21] = ghi042 + ghi043;
assign temp2[22] = ghi044 + ghi045;
assign temp2[23] = ghi046 + ghi047;
assign temp2[24] = ghi048 + ghi049;
assign temp2[25] = ghi050 + ghi051;
assign temp2[26] = ghi052 + ghi053;
assign temp2[27] = ghi054 + ghi055;
assign temp2[28] = ghi056 + ghi057;
assign temp2[29] = ghi058 + ghi059;
assign temp2[30] = ghi060 + ghi061;
assign temp2[31] = ghi062 + ghi063;
assign temp2[32] = ghi064 + ghi065;
assign temp2[33] = ghi066 + ghi067;
assign temp2[34] = ghi068 + ghi069;
assign temp2[35] = ghi070 + ghi071;
assign temp2[36] = ghi072 + ghi073;
assign temp2[37] = ghi074 + ghi075;
assign temp2[38] = ghi076 + ghi077;
assign temp2[39] = ghi078 + ghi079;
assign temp2[40] = ghi080 + ghi081;
assign temp2[41] = ghi082 + ghi083;
assign temp2[42] = ghi084 + ghi085;
assign temp2[43] = ghi086 + ghi087;
assign temp2[44] = ghi088 + ghi089;
assign temp2[45] = ghi090 + ghi091;
assign temp2[46] = ghi092 + ghi093;
assign temp2[47] = ghi094 + ghi095;
assign temp2[48] = ghi096 + ghi097;
assign temp2[49] = ghi098 + ghi099;
assign temp2[50] = ghi100 + ghi101;
assign temp2[51] = ghi102 + ghi103;
assign temp2[52] = ghi104 + ghi105;
assign temp2[53] = ghi106 + ghi107;
assign temp2[54] = ghi108 + ghi109;
assign temp2[55] = ghi110 + ghi111;
assign temp2[56] = ghi112 + ghi113;
assign temp2[57] = ghi114 + ghi115;
assign temp2[58] = ghi116 + ghi117;
assign temp2[59] = ghi118 + ghi119;
assign temp2[60] = ghi120;

assign temp4[0 ] = temp2[00] + temp2[01];
assign temp4[1 ] = temp2[02] + temp2[03];
assign temp4[2 ] = temp2[04] + temp2[05];
assign temp4[3 ] = temp2[06] + temp2[07];
assign temp4[4 ] = temp2[08] + temp2[09];
assign temp4[5 ] = temp2[10] + temp2[11];
assign temp4[6 ] = temp2[12] + temp2[13];
assign temp4[7 ] = temp2[14] + temp2[15];
assign temp4[8 ] = temp2[16] + temp2[17];
assign temp4[9 ] = temp2[18] + temp2[19];
assign temp4[10] = temp2[20] + temp2[21];
assign temp4[11] = temp2[22] + temp2[23];
assign temp4[12] = temp2[24] + temp2[25];
assign temp4[13] = temp2[26] + temp2[27];
assign temp4[14] = temp2[28] + temp2[29];
assign temp4[15] = temp2[30] + temp2[31];
assign temp4[16] = temp2[32] + temp2[33];
assign temp4[17] = temp2[34] + temp2[35];
assign temp4[18] = temp2[36] + temp2[37];
assign temp4[19] = temp2[38] + temp2[39];
assign temp4[20] = temp2[40] + temp2[41];
assign temp4[21] = temp2[42] + temp2[43];
assign temp4[22] = temp2[44] + temp2[45];
assign temp4[23] = temp2[46] + temp2[47];
assign temp4[24] = temp2[48] + temp2[49];
assign temp4[25] = temp2[50] + temp2[51];
assign temp4[26] = temp2[52] + temp2[53];
assign temp4[27] = temp2[54] + temp2[55];
assign temp4[28] = temp2[56] + temp2[57];
assign temp4[29] = temp2[58] + temp2[59];
assign temp4[30] = temp2[60];

assign temp8[0 ] = temp4[00] + temp4[01];
assign temp8[1 ] = temp4[02] + temp4[03];
assign temp8[2 ] = temp4[04] + temp4[05];
assign temp8[3 ] = temp4[06] + temp4[07];
assign temp8[4 ] = temp4[08] + temp4[09];
assign temp8[5 ] = temp4[10] + temp4[11];
assign temp8[6 ] = temp4[12] + temp4[13];
assign temp8[7 ] = temp4[14] + temp4[15];
assign temp8[8 ] = temp4[16] + temp4[17];
assign temp8[9 ] = temp4[18] + temp4[19];
assign temp8[10] = temp4[20] + temp4[21];
assign temp8[11] = temp4[22] + temp4[23];
assign temp8[12] = temp4[24] + temp4[25];
assign temp8[13] = temp4[26] + temp4[27];
assign temp8[14] = temp4[28] + temp4[29];
assign temp8[15] = temp4[30];

assign temp16[0] = temp8[00] + temp8[01];
assign temp16[1] = temp8[02] + temp8[03];
assign temp16[2] = temp8[04] + temp8[05];
assign temp16[3] = temp8[06] + temp8[07];
assign temp16[4] = temp8[08] + temp8[09];
assign temp16[5] = temp8[10] + temp8[11];
assign temp16[6] = temp8[12] + temp8[13];
assign temp16[7] = temp8[14] + temp8[15];

assign temp32[0] = temp16[0] + temp16[1];
assign temp32[1] = temp16[2] + temp16[3];
assign temp32[2] = temp16[4] + temp16[5];
assign temp32[3] = temp16[6] + temp16[7];

assign temp64[0] = temp32[0] + temp32[1];
assign temp64[1] = temp32[2] + temp32[3];

always @(*) begin
    if (en) begin
        out_sum = temp64[0] + temp64[1];
    end
    else begin
        out_sum = reg_sum;
    end
end

endmodule