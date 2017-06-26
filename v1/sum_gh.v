
module sum_gh(
    gh000,gh001,gh002,gh003,gh004,gh005,gh006,gh007,gh008,gh009,
    gh010,gh011,gh012,gh013,gh014,gh015,gh016,gh017,gh018,gh019,
    gh020,gh021,gh022,gh023,gh024,gh025,gh026,gh027,gh028,gh029,
    gh030,gh031,gh032,gh033,gh034,gh035,gh036,gh037,gh038,gh039,
    gh040,gh041,gh042,gh043,gh044,gh045,gh046,gh047,gh048,gh049,
    gh050,gh051,gh052,gh053,gh054,gh055,gh056,gh057,gh058,gh059,
    gh060,gh061,gh062,gh063,gh064,gh065,gh066,gh067,gh068,gh069,
    gh070,gh071,gh072,gh073,gh074,gh075,gh076,gh077,gh078,gh079,
    gh080,gh081,gh082,gh083,gh084,gh085,gh086,gh087,gh088,gh089,
    gh090,gh091,gh092,gh093,gh094,gh095,gh096,gh097,gh098,gh099,
    gh100,gh101,gh102,gh103,gh104,gh105,gh106,gh107,gh108,gh109,
    gh110,gh111,gh112,gh113,gh114,gh115,gh116,gh117,gh118,gh119,gh120,
    reg_sum,out_sum,
    en
);

//==== I/O port ==========================
input  [12:0] gh000,gh001,gh002,gh003,gh004,gh005,gh006,gh007,gh008,gh009; // [19:0]
input  [12:0] gh010,gh011,gh012,gh013,gh014,gh015,gh016,gh017,gh018,gh019; // [19:0]
input  [12:0] gh020,gh021,gh022,gh023,gh024,gh025,gh026,gh027,gh028,gh029; // [19:0]
input  [12:0] gh030,gh031,gh032,gh033,gh034,gh035,gh036,gh037,gh038,gh039; // [19:0]
input  [12:0] gh040,gh041,gh042,gh043,gh044,gh045,gh046,gh047,gh048,gh049; // [19:0]
input  [12:0] gh050,gh051,gh052,gh053,gh054,gh055,gh056,gh057,gh058,gh059; // [19:0]
input  [12:0] gh060,gh061,gh062,gh063,gh064,gh065,gh066,gh067,gh068,gh069; // [19:0]
input  [12:0] gh070,gh071,gh072,gh073,gh074,gh075,gh076,gh077,gh078,gh079; // [19:0]
input  [12:0] gh080,gh081,gh082,gh083,gh084,gh085,gh086,gh087,gh088,gh089; // [19:0]
input  [12:0] gh090,gh091,gh092,gh093,gh094,gh095,gh096,gh097,gh098,gh099; // [19:0]
input  [12:0] gh100,gh101,gh102,gh103,gh104,gh105,gh106,gh107,gh108,gh109; // [19:0]
input  [12:0] gh110,gh111,gh112,gh113,gh114,gh115,gh116,gh117,gh118,gh119,gh120; // [19:0]

output reg [19:0] out_sum;
input      [19:0] reg_sum;
input   en;

wire [13:0] temp2[0:60];
wire [14:0] temp4[0:30];
wire [15:0] temp8[0:15];
wire [16:0] temp16[0:7];
wire [17:0] temp32[0:3];
wire [18:0] temp64[0:1];

assign temp2[0 ] = gh000 + gh001;
assign temp2[1 ] = gh002 + gh003;
assign temp2[2 ] = gh004 + gh005;
assign temp2[3 ] = gh006 + gh007;
assign temp2[4 ] = gh008 + gh009;
assign temp2[5 ] = gh010 + gh011;
assign temp2[6 ] = gh012 + gh013;
assign temp2[7 ] = gh014 + gh015;
assign temp2[8 ] = gh016 + gh017;
assign temp2[9 ] = gh018 + gh019;
assign temp2[10] = gh020 + gh021;
assign temp2[11] = gh022 + gh023;
assign temp2[12] = gh024 + gh025;
assign temp2[13] = gh026 + gh027;
assign temp2[14] = gh028 + gh029;
assign temp2[15] = gh030 + gh031;
assign temp2[16] = gh032 + gh033;
assign temp2[17] = gh034 + gh035;
assign temp2[18] = gh036 + gh037;
assign temp2[19] = gh038 + gh039;
assign temp2[20] = gh040 + gh041;
assign temp2[21] = gh042 + gh043;
assign temp2[22] = gh044 + gh045;
assign temp2[23] = gh046 + gh047;
assign temp2[24] = gh048 + gh049;
assign temp2[25] = gh050 + gh051;
assign temp2[26] = gh052 + gh053;
assign temp2[27] = gh054 + gh055;
assign temp2[28] = gh056 + gh057;
assign temp2[29] = gh058 + gh059;
assign temp2[30] = gh060 + gh061;
assign temp2[31] = gh062 + gh063;
assign temp2[32] = gh064 + gh065;
assign temp2[33] = gh066 + gh067;
assign temp2[34] = gh068 + gh069;
assign temp2[35] = gh070 + gh071;
assign temp2[36] = gh072 + gh073;
assign temp2[37] = gh074 + gh075;
assign temp2[38] = gh076 + gh077;
assign temp2[39] = gh078 + gh079;
assign temp2[40] = gh080 + gh081;
assign temp2[41] = gh082 + gh083;
assign temp2[42] = gh084 + gh085;
assign temp2[43] = gh086 + gh087;
assign temp2[44] = gh088 + gh089;
assign temp2[45] = gh090 + gh091;
assign temp2[46] = gh092 + gh093;
assign temp2[47] = gh094 + gh095;
assign temp2[48] = gh096 + gh097;
assign temp2[49] = gh098 + gh099;
assign temp2[50] = gh100 + gh101;
assign temp2[51] = gh102 + gh103;
assign temp2[52] = gh104 + gh105;
assign temp2[53] = gh106 + gh107;
assign temp2[54] = gh108 + gh109;
assign temp2[55] = gh110 + gh111;
assign temp2[56] = gh112 + gh113;
assign temp2[57] = gh114 + gh115;
assign temp2[58] = gh116 + gh117;
assign temp2[59] = gh118 + gh119;
assign temp2[60] = gh120;

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