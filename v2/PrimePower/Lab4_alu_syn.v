
module alu ( clk_p_i, reset_n_i, data_a_i, data_b_i, inst_i, data_o );
  input [7:0] data_a_i;
  input [7:0] data_b_i;
  input [2:0] inst_i;
  output [15:0] data_o;
  input clk_p_i, reset_n_i;
  wire   out_inst_1_15, N12, N13, N14, N15, N16, N17, N18, N19, n2, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87,
         n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122;
  wire   [15:0] ALU_d2_w;
  wire   [7:0] reg_data_a;
  wire   [7:0] reg_data_b;
  wire   [8:0] out_inst_0;
  wire   [7:0] out_inst_1;
  wire   [15:0] out_inst_2;
  wire   [2:0] reg_inst;

  AO12 U42 ( .B1(out_inst_2[9]), .B2(n83), .A1(n104), .O(ALU_d2_w[9]) );
  ND3 U43 ( .I1(n29), .I2(n30), .I3(n31), .O(ALU_d2_w[8]) );
  ND2 U44 ( .I1(out_inst_0[8]), .I2(n32), .O(n31) );
  ND2 U45 ( .I1(out_inst_2[8]), .I2(n83), .O(n29) );
  ND3 U46 ( .I1(n33), .I2(n34), .I3(n35), .O(ALU_d2_w[7]) );
  AO22 U47 ( .A1(out_inst_1_15), .A2(n40), .B1(N19), .B2(n41), .O(n37) );
  OAI12S U48 ( .B1(n39), .B2(n105), .A1(n42), .O(n36) );
  ND2 U49 ( .I1(out_inst_0[7]), .I2(n32), .O(n34) );
  ND3 U50 ( .I1(n44), .I2(n45), .I3(n46), .O(ALU_d2_w[6]) );
  AOI2222 U51 ( .A1(n47), .A2(n117), .B1(reg_data_a[6]), .B2(n48), .C1(N18), 
        .C2(n41), .D1(out_inst_1[7]), .D2(n40), .O(n46) );
  OAI12S U52 ( .B1(reg_data_b[6]), .B2(n39), .A1(n49), .O(n48) );
  OAI12S U53 ( .B1(n39), .B2(n106), .A1(n42), .O(n47) );
  ND2 U54 ( .I1(out_inst_0[6]), .I2(n32), .O(n45) );
  ND3 U55 ( .I1(n50), .I2(n51), .I3(n52), .O(ALU_d2_w[5]) );
  AOI2222 U56 ( .A1(n53), .A2(n118), .B1(reg_data_a[5]), .B2(n54), .C1(N17), 
        .C2(n41), .D1(out_inst_1[6]), .D2(n40), .O(n52) );
  OAI12S U57 ( .B1(reg_data_b[5]), .B2(n39), .A1(n49), .O(n54) );
  OAI12S U58 ( .B1(n39), .B2(n107), .A1(n42), .O(n53) );
  ND2 U59 ( .I1(out_inst_0[5]), .I2(n32), .O(n51) );
  ND3 U60 ( .I1(n55), .I2(n56), .I3(n57), .O(ALU_d2_w[4]) );
  AOI2222 U61 ( .A1(n58), .A2(n119), .B1(reg_data_a[4]), .B2(n59), .C1(N16), 
        .C2(n41), .D1(out_inst_1[5]), .D2(n40), .O(n57) );
  OAI12S U62 ( .B1(reg_data_b[4]), .B2(n39), .A1(n49), .O(n59) );
  OAI12S U63 ( .B1(n39), .B2(n108), .A1(n42), .O(n58) );
  ND2 U64 ( .I1(out_inst_0[4]), .I2(n32), .O(n56) );
  ND3 U65 ( .I1(n60), .I2(n61), .I3(n62), .O(ALU_d2_w[3]) );
  AOI2222 U66 ( .A1(n63), .A2(n120), .B1(reg_data_a[3]), .B2(n64), .C1(N15), 
        .C2(n41), .D1(out_inst_1[4]), .D2(n40), .O(n62) );
  OAI12S U67 ( .B1(reg_data_b[3]), .B2(n39), .A1(n49), .O(n64) );
  OAI12S U68 ( .B1(n39), .B2(n109), .A1(n42), .O(n63) );
  ND2 U69 ( .I1(out_inst_0[3]), .I2(n32), .O(n61) );
  AOI2222 U71 ( .A1(n68), .A2(n121), .B1(reg_data_a[2]), .B2(n69), .C1(N14), 
        .C2(n41), .D1(out_inst_1[3]), .D2(n40), .O(n67) );
  OAI12S U72 ( .B1(reg_data_b[2]), .B2(n39), .A1(n49), .O(n69) );
  OAI12S U73 ( .B1(n39), .B2(n110), .A1(n42), .O(n68) );
  ND2 U74 ( .I1(out_inst_0[2]), .I2(n32), .O(n66) );
  AOI2222 U76 ( .A1(n73), .A2(n122), .B1(reg_data_a[1]), .B2(n74), .C1(N13), 
        .C2(n41), .D1(out_inst_1[2]), .D2(n40), .O(n72) );
  OAI12S U77 ( .B1(reg_data_b[1]), .B2(n39), .A1(n49), .O(n74) );
  OAI12S U78 ( .B1(n39), .B2(n111), .A1(n42), .O(n73) );
  ND2 U79 ( .I1(out_inst_0[1]), .I2(n32), .O(n71) );
  AO12 U80 ( .B1(out_inst_2[15]), .B2(n83), .A1(n104), .O(ALU_d2_w[15]) );
  AO12 U81 ( .B1(out_inst_2[14]), .B2(n83), .A1(n104), .O(ALU_d2_w[14]) );
  AO12 U82 ( .B1(out_inst_2[13]), .B2(n83), .A1(n104), .O(ALU_d2_w[13]) );
  AO12 U83 ( .B1(out_inst_2[12]), .B2(n83), .A1(n104), .O(ALU_d2_w[12]) );
  AO12 U84 ( .B1(out_inst_2[11]), .B2(n83), .A1(n104), .O(ALU_d2_w[11]) );
  AO12 U85 ( .B1(out_inst_2[10]), .B2(n83), .A1(n104), .O(ALU_d2_w[10]) );
  OAI12S U86 ( .B1(n40), .B2(n84), .A1(out_inst_1_15), .O(n30) );
  ND3 U87 ( .I1(n75), .I2(n76), .I3(n77), .O(ALU_d2_w[0]) );
  AOI2222 U88 ( .A1(n78), .A2(n103), .B1(N12), .B2(n79), .C1(N12), .C2(n41), 
        .D1(out_inst_1[1]), .D2(n40), .O(n77) );
  OAI12S U89 ( .B1(reg_data_b[0]), .B2(n39), .A1(n49), .O(n79) );
  ND2 U90 ( .I1(n80), .I2(n116), .O(n49) );
  OAI12S U91 ( .B1(n39), .B2(n112), .A1(n42), .O(n78) );
  ND3 U92 ( .I1(reg_inst[1]), .I2(n113), .I3(reg_inst[0]), .O(n42) );
  ND2 U94 ( .I1(out_inst_0[0]), .I2(n32), .O(n76) );
  alu_DW01_add_0 add_41 ( .A({n2, reg_data_a[7:1], N12}), .B({n2, reg_data_b}), 
        .CI(n2), .SUM(out_inst_0) );
  alu_DW01_sub_1 r304 ( .A({n2, reg_data_b}), .B({n2, reg_data_a[7:1], N12}), 
        .CI(n2), .DIFF({out_inst_1_15, out_inst_1}) );
  alu_DW_mult_uns_0 mult_43 ( .a({reg_data_a[7:1], N12}), .b(reg_data_b), 
        .product(out_inst_2) );
  QDFFRBN \reg_inst_reg[0]  ( .D(inst_i[0]), .CK(clk_p_i), .RB(reset_n_i), .Q(
        reg_inst[0]) );
  QDFFRBN \reg_inst_reg[1]  ( .D(inst_i[1]), .CK(clk_p_i), .RB(reset_n_i), .Q(
        reg_inst[1]) );
  QDFFRBN \reg_data_b_reg[6]  ( .D(data_b_i[6]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[6]) );
  QDFFRBN \reg_data_b_reg[5]  ( .D(data_b_i[5]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[5]) );
  QDFFRBN \reg_data_b_reg[7]  ( .D(data_b_i[7]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[7]) );
  QDFFRBN \reg_data_a_reg[7]  ( .D(data_a_i[7]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[7]) );
  QDFFRBN \reg_data_b_reg[4]  ( .D(data_b_i[4]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[4]) );
  QDFFRBN \reg_data_b_reg[3]  ( .D(data_b_i[3]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[3]) );
  QDFFRBN \reg_data_b_reg[2]  ( .D(data_b_i[2]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[2]) );
  QDFFRBN \reg_data_b_reg[1]  ( .D(data_b_i[1]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[1]) );
  QDFFRBN \reg_data_b_reg[0]  ( .D(data_b_i[0]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_b[0]) );
  QDFFRBN \reg_data_a_reg[0]  ( .D(data_a_i[0]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(N12) );
  QDFFRBN \ALU_d2_r_reg[1]  ( .D(n96), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[1]) );
  QDFFRBN \ALU_d2_r_reg[2]  ( .D(n95), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[2]) );
  QDFFRBN \ALU_d2_r_reg[3]  ( .D(n94), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[3]) );
  QDFFRBN \ALU_d2_r_reg[4]  ( .D(n92), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[4]) );
  QDFFRBN \ALU_d2_r_reg[5]  ( .D(n90), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[5]) );
  QDFFRBN \ALU_d2_r_reg[6]  ( .D(n88), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[6]) );
  QDFFRBN \ALU_d2_r_reg[0]  ( .D(n86), .CK(clk_p_i), .RB(reset_n_i), .Q(
        data_o[0]) );
  QDFFRBN \ALU_d2_r_reg[10]  ( .D(ALU_d2_w[10]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[10]) );
  QDFFRBN \ALU_d2_r_reg[11]  ( .D(ALU_d2_w[11]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[11]) );
  QDFFRBN \ALU_d2_r_reg[12]  ( .D(ALU_d2_w[12]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[12]) );
  QDFFRBN \ALU_d2_r_reg[13]  ( .D(ALU_d2_w[13]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[13]) );
  QDFFRBN \ALU_d2_r_reg[14]  ( .D(ALU_d2_w[14]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[14]) );
  QDFFRBN \ALU_d2_r_reg[15]  ( .D(ALU_d2_w[15]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[15]) );
  QDFFRBN \ALU_d2_r_reg[9]  ( .D(ALU_d2_w[9]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[9]) );
  QDFFRBN \ALU_d2_r_reg[8]  ( .D(ALU_d2_w[8]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[8]) );
  QDFFRBN \ALU_d2_r_reg[7]  ( .D(ALU_d2_w[7]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(data_o[7]) );
  DFFRBN \reg_inst_reg[2]  ( .D(inst_i[2]), .CK(clk_p_i), .RB(reset_n_i), .Q(
        reg_inst[2]), .QB(n113) );
  QDFFRBS \reg_data_a_reg[4]  ( .D(data_a_i[4]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[4]) );
  QDFFRBS \reg_data_a_reg[5]  ( .D(data_a_i[5]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[5]) );
  QDFFRBS \reg_data_a_reg[6]  ( .D(data_a_i[6]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[6]) );
  QDFFRBS \reg_data_a_reg[1]  ( .D(data_a_i[1]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[1]) );
  QDFFRBS \reg_data_a_reg[2]  ( .D(data_a_i[2]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[2]) );
  QDFFRBS \reg_data_a_reg[3]  ( .D(data_a_i[3]), .CK(clk_p_i), .RB(reset_n_i), 
        .Q(reg_data_a[3]) );
  AN3 U95 ( .I1(n70), .I2(n71), .I3(n72), .O(n81) );
  AN3 U96 ( .I1(n65), .I2(n66), .I3(n67), .O(n82) );
  NR3P U97 ( .I1(reg_inst[0]), .I2(reg_inst[2]), .I3(n114), .O(n83) );
  NR3 U98 ( .I1(reg_inst[1]), .I2(reg_inst[2]), .I3(n115), .O(n84) );
  NR3P U99 ( .I1(n116), .I2(reg_data_b[7]), .I3(n39), .O(n38) );
  INV1S U100 ( .I(ALU_d2_w[0]), .O(n85) );
  INV1S U101 ( .I(n85), .O(n86) );
  INV1S U102 ( .I(ALU_d2_w[6]), .O(n87) );
  INV1S U103 ( .I(n87), .O(n88) );
  INV1S U104 ( .I(ALU_d2_w[5]), .O(n89) );
  INV1S U105 ( .I(n89), .O(n90) );
  INV1S U106 ( .I(ALU_d2_w[4]), .O(n91) );
  INV1S U107 ( .I(n91), .O(n92) );
  INV1S U108 ( .I(ALU_d2_w[3]), .O(n93) );
  INV1S U109 ( .I(n93), .O(n94) );
  INV1S U110 ( .I(n82), .O(n95) );
  INV1S U111 ( .I(n81), .O(n96) );
  INV1S U112 ( .I(n30), .O(n104) );
  AOI112S U113 ( .C1(n36), .C2(n116), .A1(n37), .B1(n38), .O(n35) );
  AOI22S U114 ( .A1(out_inst_2[7]), .A2(n83), .B1(out_inst_1[7]), .B2(n84), 
        .O(n33) );
  XOR2 U115 ( .I1(n117), .I2(n101), .O(N18) );
  XOR2 U116 ( .I1(n118), .I2(n100), .O(N17) );
  AN2 U117 ( .I1(n120), .I2(n99), .O(n97) );
  AN2 U118 ( .I1(n122), .I2(n103), .O(n98) );
  AN2 U119 ( .I1(n121), .I2(n98), .O(n99) );
  AN2 U120 ( .I1(n119), .I2(n97), .O(n100) );
  AN2 U121 ( .I1(n118), .I2(n100), .O(n101) );
  XOR2 U122 ( .I1(n119), .I2(n97), .O(N16) );
  XOR2 U123 ( .I1(n120), .I2(n99), .O(N15) );
  XOR2 U124 ( .I1(n121), .I2(n98), .O(N14) );
  XOR2 U125 ( .I1(n122), .I2(n103), .O(N13) );
  AOI22S U126 ( .A1(out_inst_2[5]), .A2(n83), .B1(out_inst_1[5]), .B2(n84), 
        .O(n50) );
  XOR2 U127 ( .I1(reg_data_a[7]), .I2(n102), .O(N19) );
  AOI22S U128 ( .A1(out_inst_2[6]), .A2(n83), .B1(out_inst_1[6]), .B2(n84), 
        .O(n44) );
  AOI22S U129 ( .A1(out_inst_2[4]), .A2(n83), .B1(out_inst_1[4]), .B2(n84), 
        .O(n55) );
  AOI22S U130 ( .A1(out_inst_2[3]), .A2(n83), .B1(out_inst_1[3]), .B2(n84), 
        .O(n60) );
  INV1S U131 ( .I(N12), .O(n103) );
  NR3 U132 ( .I1(n114), .I2(reg_inst[0]), .I3(n113), .O(n40) );
  INV1S U133 ( .I(reg_data_b[7]), .O(n105) );
  INV1S U134 ( .I(reg_data_b[0]), .O(n112) );
  INV1S U135 ( .I(reg_data_b[6]), .O(n106) );
  INV1S U136 ( .I(reg_data_b[5]), .O(n107) );
  INV1S U137 ( .I(reg_data_b[4]), .O(n108) );
  INV1S U138 ( .I(reg_data_b[3]), .O(n109) );
  INV1S U139 ( .I(reg_data_b[2]), .O(n110) );
  INV1S U140 ( .I(reg_data_b[1]), .O(n111) );
  NR3 U141 ( .I1(n113), .I2(reg_inst[1]), .I3(n115), .O(n80) );
  INV1S U142 ( .I(reg_inst[1]), .O(n114) );
  INV1S U143 ( .I(reg_data_a[7]), .O(n116) );
  INV1S U144 ( .I(reg_inst[0]), .O(n115) );
  AN2 U145 ( .I1(n80), .I2(reg_data_a[7]), .O(n41) );
  AOI22S U146 ( .A1(out_inst_2[0]), .A2(n83), .B1(out_inst_1[0]), .B2(n84), 
        .O(n75) );
  AOI22S U147 ( .A1(out_inst_2[2]), .A2(n83), .B1(out_inst_1[2]), .B2(n84), 
        .O(n65) );
  AOI22S U148 ( .A1(out_inst_2[1]), .A2(n83), .B1(out_inst_1[1]), .B2(n84), 
        .O(n70) );
  ND3 U149 ( .I1(n115), .I2(n114), .I3(reg_inst[2]), .O(n39) );
  NR3 U150 ( .I1(reg_inst[1]), .I2(reg_inst[2]), .I3(reg_inst[0]), .O(n32) );
  INV1S U151 ( .I(reg_data_a[6]), .O(n117) );
  INV1S U152 ( .I(reg_data_a[5]), .O(n118) );
  INV1S U153 ( .I(reg_data_a[4]), .O(n119) );
  INV1S U154 ( .I(reg_data_a[3]), .O(n120) );
  INV1S U155 ( .I(reg_data_a[2]), .O(n121) );
  INV1S U156 ( .I(reg_data_a[1]), .O(n122) );
  TIE0 U157 ( .O(n2) );
  ND2 U158 ( .I1(n117), .I2(n101), .O(n102) );
endmodule


module alu_DW_mult_uns_0 ( a, b, product );
  input [7:0] a;
  input [7:0] b;
  output [15:0] product;
  wire   n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44,
         n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58,
         n59, n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72,
         n73, n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86,
         n87, n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n214, n215, n216, n217, n218,
         n219, n220, n221, n222, n223, n224, n225, n226, n227, n228, n229;

  FA1S U2 ( .A(n15), .B(n99), .CI(n2), .CO(product[15]), .S(product[14]) );
  FA1S U3 ( .A(n17), .B(n16), .CI(n3), .CO(n2), .S(product[13]) );
  FA1S U4 ( .A(n21), .B(n18), .CI(n4), .CO(n3), .S(product[12]) );
  FA1S U5 ( .A(n22), .B(n27), .CI(n5), .CO(n4), .S(product[11]) );
  FA1S U6 ( .A(n28), .B(n35), .CI(n6), .CO(n5), .S(product[10]) );
  FA1S U7 ( .A(n36), .B(n45), .CI(n7), .CO(n6), .S(product[9]) );
  FA1S U8 ( .A(n46), .B(n57), .CI(n8), .CO(n7), .S(product[8]) );
  FA1S U9 ( .A(n58), .B(n69), .CI(n9), .CO(n8), .S(product[7]) );
  FA1S U10 ( .A(n70), .B(n79), .CI(n10), .CO(n9), .S(product[6]) );
  FA1S U11 ( .A(n80), .B(n87), .CI(n11), .CO(n10), .S(product[5]) );
  FA1S U12 ( .A(n88), .B(n93), .CI(n12), .CO(n11), .S(product[4]) );
  FA1S U13 ( .A(n13), .B(n96), .CI(n94), .CO(n12), .S(product[3]) );
  FA1S U14 ( .A(n14), .B(n146), .CI(n98), .CO(n13), .S(product[2]) );
  HA1 U15 ( .A(n154), .B(n161), .C(n14), .S(product[1]) );
  FA1S U16 ( .A(n100), .B(n107), .CI(n19), .CO(n15), .S(n16) );
  FA1S U17 ( .A(n20), .B(n25), .CI(n23), .CO(n17), .S(n18) );
  FA1S U18 ( .A(n101), .B(n115), .CI(n108), .CO(n19), .S(n20) );
  FA1S U19 ( .A(n24), .B(n31), .CI(n29), .CO(n21), .S(n22) );
  FA1S U20 ( .A(n33), .B(n116), .CI(n26), .CO(n23), .S(n24) );
  FA1S U21 ( .A(n102), .B(n123), .CI(n109), .CO(n25), .S(n26) );
  FA1S U22 ( .A(n37), .B(n32), .CI(n30), .CO(n27), .S(n28) );
  FA1S U23 ( .A(n34), .B(n41), .CI(n39), .CO(n29), .S(n30) );
  FA1S U24 ( .A(n117), .B(n124), .CI(n43), .CO(n31), .S(n32) );
  FA1S U25 ( .A(n103), .B(n131), .CI(n110), .CO(n33), .S(n34) );
  FA1S U26 ( .A(n47), .B(n40), .CI(n38), .CO(n35), .S(n36) );
  FA1S U27 ( .A(n51), .B(n44), .CI(n49), .CO(n37), .S(n38) );
  FA1S U28 ( .A(n53), .B(n55), .CI(n42), .CO(n39), .S(n40) );
  FA1S U29 ( .A(n125), .B(n118), .CI(n132), .CO(n41), .S(n42) );
  FA1S U30 ( .A(n104), .B(n139), .CI(n111), .CO(n43), .S(n44) );
  FA1S U31 ( .A(n59), .B(n50), .CI(n48), .CO(n45), .S(n46) );
  FA1S U32 ( .A(n52), .B(n54), .CI(n61), .CO(n47), .S(n48) );
  FA1S U33 ( .A(n65), .B(n56), .CI(n63), .CO(n49), .S(n50) );
  FA1S U34 ( .A(n133), .B(n140), .CI(n67), .CO(n51), .S(n52) );
  FA1S U35 ( .A(n119), .B(n126), .CI(n147), .CO(n53), .S(n54) );
  HA1 U36 ( .A(n112), .B(n105), .C(n55), .S(n56) );
  FA1S U37 ( .A(n62), .B(n71), .CI(n60), .CO(n57), .S(n58) );
  FA1S U38 ( .A(n66), .B(n64), .CI(n73), .CO(n59), .S(n60) );
  FA1S U39 ( .A(n68), .B(n77), .CI(n75), .CO(n61), .S(n62) );
  FA1S U40 ( .A(n127), .B(n141), .CI(n134), .CO(n63), .S(n64) );
  FA1S U41 ( .A(n120), .B(n155), .CI(n148), .CO(n65), .S(n66) );
  HA1 U42 ( .A(n113), .B(n106), .C(n67), .S(n68) );
  FA1S U43 ( .A(n74), .B(n81), .CI(n72), .CO(n69), .S(n70) );
  FA1S U44 ( .A(n83), .B(n78), .CI(n76), .CO(n71), .S(n72) );
  FA1S U45 ( .A(n135), .B(n142), .CI(n85), .CO(n73), .S(n74) );
  FA1S U46 ( .A(n128), .B(n156), .CI(n149), .CO(n75), .S(n76) );
  HA1 U47 ( .A(n121), .B(n114), .C(n77), .S(n78) );
  FA1S U48 ( .A(n84), .B(n89), .CI(n82), .CO(n79), .S(n80) );
  FA1S U49 ( .A(n91), .B(n150), .CI(n86), .CO(n81), .S(n82) );
  FA1S U50 ( .A(n136), .B(n157), .CI(n143), .CO(n83), .S(n84) );
  HA1 U51 ( .A(n129), .B(n122), .C(n85), .S(n86) );
  FA1S U52 ( .A(n92), .B(n95), .CI(n90), .CO(n87), .S(n88) );
  FA1S U53 ( .A(n144), .B(n158), .CI(n151), .CO(n89), .S(n90) );
  HA1 U54 ( .A(n137), .B(n130), .C(n91), .S(n92) );
  FA1S U55 ( .A(n152), .B(n159), .CI(n97), .CO(n93), .S(n94) );
  HA1 U56 ( .A(n145), .B(n138), .C(n95), .S(n96) );
  HA1 U57 ( .A(n160), .B(n153), .C(n97), .S(n98) );
  INV1S U140 ( .I(a[0]), .O(n229) );
  INV1S U141 ( .I(b[0]), .O(n221) );
  INV1S U142 ( .I(b[4]), .O(n217) );
  INV1S U143 ( .I(b[3]), .O(n218) );
  INV1S U144 ( .I(b[2]), .O(n219) );
  INV1S U145 ( .I(b[1]), .O(n220) );
  INV1S U146 ( .I(a[4]), .O(n225) );
  INV1S U147 ( .I(a[3]), .O(n226) );
  INV1S U148 ( .I(a[5]), .O(n224) );
  INV1S U149 ( .I(a[2]), .O(n227) );
  INV1S U150 ( .I(a[1]), .O(n228) );
  INV1S U151 ( .I(a[7]), .O(n222) );
  INV1S U152 ( .I(b[7]), .O(n214) );
  INV1S U153 ( .I(b[5]), .O(n216) );
  INV1S U154 ( .I(b[6]), .O(n215) );
  INV1S U155 ( .I(a[6]), .O(n223) );
  NR2 U156 ( .I1(n229), .I2(n221), .O(product[0]) );
  NR2 U157 ( .I1(n222), .I2(n214), .O(n99) );
  NR2 U158 ( .I1(n229), .I2(n220), .O(n161) );
  NR2 U159 ( .I1(n229), .I2(n219), .O(n160) );
  NR2 U160 ( .I1(n229), .I2(n218), .O(n159) );
  NR2 U161 ( .I1(n229), .I2(n217), .O(n158) );
  NR2 U162 ( .I1(n229), .I2(n216), .O(n157) );
  NR2 U163 ( .I1(n229), .I2(n215), .O(n156) );
  NR2 U164 ( .I1(n229), .I2(n214), .O(n155) );
  NR2 U165 ( .I1(n221), .I2(n228), .O(n154) );
  NR2 U166 ( .I1(n220), .I2(n228), .O(n153) );
  NR2 U167 ( .I1(n219), .I2(n228), .O(n152) );
  NR2 U168 ( .I1(n218), .I2(n228), .O(n151) );
  NR2 U169 ( .I1(n217), .I2(n228), .O(n150) );
  NR2 U170 ( .I1(n216), .I2(n228), .O(n149) );
  NR2 U171 ( .I1(n215), .I2(n228), .O(n148) );
  NR2 U172 ( .I1(n214), .I2(n228), .O(n147) );
  NR2 U173 ( .I1(n221), .I2(n227), .O(n146) );
  NR2 U174 ( .I1(n220), .I2(n227), .O(n145) );
  NR2 U175 ( .I1(n219), .I2(n227), .O(n144) );
  NR2 U176 ( .I1(n218), .I2(n227), .O(n143) );
  NR2 U177 ( .I1(n217), .I2(n227), .O(n142) );
  NR2 U178 ( .I1(n216), .I2(n227), .O(n141) );
  NR2 U179 ( .I1(n215), .I2(n227), .O(n140) );
  NR2 U180 ( .I1(n214), .I2(n227), .O(n139) );
  NR2 U181 ( .I1(n221), .I2(n226), .O(n138) );
  NR2 U182 ( .I1(n220), .I2(n226), .O(n137) );
  NR2 U183 ( .I1(n219), .I2(n226), .O(n136) );
  NR2 U184 ( .I1(n218), .I2(n226), .O(n135) );
  NR2 U185 ( .I1(n217), .I2(n226), .O(n134) );
  NR2 U186 ( .I1(n216), .I2(n226), .O(n133) );
  NR2 U187 ( .I1(n215), .I2(n226), .O(n132) );
  NR2 U188 ( .I1(n214), .I2(n226), .O(n131) );
  NR2 U189 ( .I1(n221), .I2(n225), .O(n130) );
  NR2 U190 ( .I1(n220), .I2(n225), .O(n129) );
  NR2 U191 ( .I1(n219), .I2(n225), .O(n128) );
  NR2 U192 ( .I1(n218), .I2(n225), .O(n127) );
  NR2 U193 ( .I1(n217), .I2(n225), .O(n126) );
  NR2 U194 ( .I1(n216), .I2(n225), .O(n125) );
  NR2 U195 ( .I1(n215), .I2(n225), .O(n124) );
  NR2 U196 ( .I1(n214), .I2(n225), .O(n123) );
  NR2 U197 ( .I1(n221), .I2(n224), .O(n122) );
  NR2 U198 ( .I1(n220), .I2(n224), .O(n121) );
  NR2 U199 ( .I1(n219), .I2(n224), .O(n120) );
  NR2 U200 ( .I1(n218), .I2(n224), .O(n119) );
  NR2 U201 ( .I1(n217), .I2(n224), .O(n118) );
  NR2 U202 ( .I1(n216), .I2(n224), .O(n117) );
  NR2 U203 ( .I1(n215), .I2(n224), .O(n116) );
  NR2 U204 ( .I1(n214), .I2(n224), .O(n115) );
  NR2 U205 ( .I1(n221), .I2(n223), .O(n114) );
  NR2 U206 ( .I1(n220), .I2(n223), .O(n113) );
  NR2 U207 ( .I1(n219), .I2(n223), .O(n112) );
  NR2 U208 ( .I1(n218), .I2(n223), .O(n111) );
  NR2 U209 ( .I1(n217), .I2(n223), .O(n110) );
  NR2 U210 ( .I1(n216), .I2(n223), .O(n109) );
  NR2 U211 ( .I1(n215), .I2(n223), .O(n108) );
  NR2 U212 ( .I1(n214), .I2(n223), .O(n107) );
  NR2 U213 ( .I1(n221), .I2(n222), .O(n106) );
  NR2 U214 ( .I1(n222), .I2(n220), .O(n105) );
  NR2 U215 ( .I1(n222), .I2(n219), .O(n104) );
  NR2 U216 ( .I1(n222), .I2(n218), .O(n103) );
  NR2 U217 ( .I1(n222), .I2(n217), .O(n102) );
  NR2 U218 ( .I1(n222), .I2(n216), .O(n101) );
  NR2 U219 ( .I1(n222), .I2(n215), .O(n100) );
endmodule


module alu_DW01_sub_1 ( A, B, CI, DIFF, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] DIFF;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9;
  wire   [9:0] carry;

  FA1S U2_7 ( .A(A[7]), .B(n2), .CI(carry[7]), .CO(carry[8]), .S(DIFF[7]) );
  FA1S U2_1 ( .A(A[1]), .B(n8), .CI(carry[1]), .CO(carry[2]), .S(DIFF[1]) );
  FA1S U2_2 ( .A(A[2]), .B(n7), .CI(carry[2]), .CO(carry[3]), .S(DIFF[2]) );
  FA1S U2_3 ( .A(A[3]), .B(n6), .CI(carry[3]), .CO(carry[4]), .S(DIFF[3]) );
  FA1S U2_4 ( .A(A[4]), .B(n5), .CI(carry[4]), .CO(carry[5]), .S(DIFF[4]) );
  FA1S U2_5 ( .A(A[5]), .B(n4), .CI(carry[5]), .CO(carry[6]), .S(DIFF[5]) );
  FA1S U2_6 ( .A(A[6]), .B(n3), .CI(carry[6]), .CO(carry[7]), .S(DIFF[6]) );
  INV1S U1 ( .I(B[0]), .O(n9) );
  INV1S U2 ( .I(B[6]), .O(n3) );
  INV1S U3 ( .I(B[5]), .O(n4) );
  INV1S U4 ( .I(B[4]), .O(n5) );
  INV1S U5 ( .I(B[3]), .O(n6) );
  INV1S U6 ( .I(B[2]), .O(n7) );
  INV1S U7 ( .I(B[1]), .O(n8) );
  INV1S U8 ( .I(A[0]), .O(n1) );
  INV1S U9 ( .I(B[7]), .O(n2) );
  XNR2 U10 ( .I1(n9), .I2(A[0]), .O(DIFF[0]) );
  ND2 U11 ( .I1(B[0]), .I2(n1), .O(carry[1]) );
  INV1S U12 ( .I(carry[8]), .O(DIFF[8]) );
endmodule


module alu_DW01_add_0 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1;
  wire   [8:1] carry;

  FA1S U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  FA1S U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(SUM[8]), .S(SUM[7]) );
  FA1S U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2]) );
  FA1S U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3]) );
  FA1S U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4]) );
  FA1S U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5]) );
  FA1S U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6]) );
  AN2 U1 ( .I1(B[0]), .I2(A[0]), .O(n1) );
  XOR2 U2 ( .I1(B[0]), .I2(A[0]), .O(SUM[0]) );
endmodule

