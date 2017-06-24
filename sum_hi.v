
module sum_hi(
    hi000,hi001,hi002,hi003,hi004,hi005,hi006,hi007,hi008,hi009,
    hi010,hi011,hi012,hi013,hi014,hi015,hi016,hi017,hi018,hi019,
    hi020,hi021,hi022,hi023,hi024,hi025,hi026,hi027,hi028,hi029,
    hi030,hi031,hi032,hi033,hi034,hi035,hi036,hi037,hi038,hi039,
    hi040,hi041,hi042,hi043,hi044,hi045,hi046,hi047,hi048,hi049,
    hi050,hi051,hi052,hi053,hi054,hi055,hi056,hi057,hi058,hi059,
    hi060,hi061,hi062,hi063,hi064,hi065,hi066,hi067,hi068,hi069,
    hi070,hi071,hi072,hi073,hi074,hi075,hi076,hi077,hi078,hi079,
    hi080,hi081,hi082,hi083,hi084,hi085,hi086,hi087,hi088,hi089,
    hi090,hi091,hi092,hi093,hi094,hi095,hi096,hi097,hi098,hi099,
    hi100,hi101,hi102,hi103,hi104,hi105,hi106,hi107,hi108,hi109,
    hi110,hi111,hi112,hi113,hi114,hi115,hi116,hi117,hi118,hi119,hi120,
    reg_sum,out_sum,
    en
);

//==== I/O port ==========================
input  [13:0] hi000,hi001,hi002,hi003,hi004,hi005,hi006,hi007,hi008,hi009;
input  [13:0] hi010,hi011,hi012,hi013,hi014,hi015,hi016,hi017,hi018,hi019;
input  [13:0] hi020,hi021,hi022,hi023,hi024,hi025,hi026,hi027,hi028,hi029;
input  [13:0] hi030,hi031,hi032,hi033,hi034,hi035,hi036,hi037,hi038,hi039;
input  [13:0] hi040,hi041,hi042,hi043,hi044,hi045,hi046,hi047,hi048,hi049;
input  [13:0] hi050,hi051,hi052,hi053,hi054,hi055,hi056,hi057,hi058,hi059;
input  [13:0] hi060,hi061,hi062,hi063,hi064,hi065,hi066,hi067,hi068,hi069;
input  [13:0] hi070,hi071,hi072,hi073,hi074,hi075,hi076,hi077,hi078,hi079;
input  [13:0] hi080,hi081,hi082,hi083,hi084,hi085,hi086,hi087,hi088,hi089;
input  [13:0] hi090,hi091,hi092,hi093,hi094,hi095,hi096,hi097,hi098,hi099;
input  [13:0] hi100,hi101,hi102,hi103,hi104,hi105,hi106,hi107,hi108,hi109;
input  [13:0] hi110,hi111,hi112,hi113,hi114,hi115,hi116,hi117,hi118,hi119,hi120;

output reg [20:0] out_sum;
input  [20:0] reg_sum;
input   en;

wire [14:0] temp2[0:60];
wire [15:0] temp4[0:30];
wire [16:0] temp8[0:15];
wire [17:0] temp16[0:7];
wire [18:0] temp32[0:3];
wire [19:0] temp64[0:1];

assign temp2[0 ] = hi000 + hi001;
assign temp2[1 ] = hi002 + hi003;
assign temp2[2 ] = hi004 + hi005;
assign temp2[3 ] = hi006 + hi007;
assign temp2[4 ] = hi008 + hi009;
assign temp2[5 ] = hi010 + hi011;
assign temp2[6 ] = hi012 + hi013;
assign temp2[7 ] = hi014 + hi015;
assign temp2[8 ] = hi016 + hi017;
assign temp2[9 ] = hi018 + hi019;
assign temp2[10] = hi020 + hi021;
assign temp2[11] = hi022 + hi023;
assign temp2[12] = hi024 + hi025;
assign temp2[13] = hi026 + hi027;
assign temp2[14] = hi028 + hi029;
assign temp2[15] = hi030 + hi031;
assign temp2[16] = hi032 + hi033;
assign temp2[17] = hi034 + hi035;
assign temp2[18] = hi036 + hi037;
assign temp2[19] = hi038 + hi039;
assign temp2[20] = hi040 + hi041;
assign temp2[21] = hi042 + hi043;
assign temp2[22] = hi044 + hi045;
assign temp2[23] = hi046 + hi047;
assign temp2[24] = hi048 + hi049;
assign temp2[25] = hi050 + hi051;
assign temp2[26] = hi052 + hi053;
assign temp2[27] = hi054 + hi055;
assign temp2[28] = hi056 + hi057;
assign temp2[29] = hi058 + hi059;
assign temp2[30] = hi060 + hi061;
assign temp2[31] = hi062 + hi063;
assign temp2[32] = hi064 + hi065;
assign temp2[33] = hi066 + hi067;
assign temp2[34] = hi068 + hi069;
assign temp2[35] = hi070 + hi071;
assign temp2[36] = hi072 + hi073;
assign temp2[37] = hi074 + hi075;
assign temp2[38] = hi076 + hi077;
assign temp2[39] = hi078 + hi079;
assign temp2[40] = hi080 + hi081;
assign temp2[41] = hi082 + hi083;
assign temp2[42] = hi084 + hi085;
assign temp2[43] = hi086 + hi087;
assign temp2[44] = hi088 + hi089;
assign temp2[45] = hi090 + hi091;
assign temp2[46] = hi092 + hi093;
assign temp2[47] = hi094 + hi095;
assign temp2[48] = hi096 + hi097;
assign temp2[49] = hi098 + hi099;
assign temp2[50] = hi100 + hi101;
assign temp2[51] = hi102 + hi103;
assign temp2[52] = hi104 + hi105;
assign temp2[53] = hi106 + hi107;
assign temp2[54] = hi108 + hi109;
assign temp2[55] = hi110 + hi111;
assign temp2[56] = hi112 + hi113;
assign temp2[57] = hi114 + hi115;
assign temp2[58] = hi116 + hi117;
assign temp2[59] = hi118 + hi119;
assign temp2[60] = hi120;

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