/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : O-2018.06-SP5
// Date      : Mon Jan 19 11:16:19 2026
/////////////////////////////////////////////////////////////


module rgb2gray_DW01_add_2 ( A, B, CI, SUM, CO );
  input [8:0] A;
  input [8:0] B;
  output [8:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n20, n21, n22, n23, n25, n26, n27, n28, n29, n30, n31, n32,
         n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47,
         n48, n49, n50, n51, n52, n85, n86, n87, n88, n89, n90, n91, n92;

  OAI21_X4 U8 ( .B1(n14), .B2(n22), .A(n15), .ZN(n13) );
  NAND2_X4 U9 ( .A1(n46), .A2(n15), .ZN(n2) );
  NAND2_X4 U12 ( .A1(B[7]), .A2(A[7]), .ZN(n15) );
  NAND2_X4 U19 ( .A1(n47), .A2(n22), .ZN(n3) );
  NAND2_X4 U29 ( .A1(n48), .A2(n29), .ZN(n4) );
  XNOR2_X2 U39 ( .A(n38), .B(n6), .ZN(SUM[3]) );
  XOR2_X2 U47 ( .A(n41), .B(n7), .Z(SUM[2]) );
  NAND2_X1 U64 ( .A1(B[2]), .A2(A[2]), .ZN(n40) );
  NAND2_X1 U65 ( .A1(n49), .A2(n32), .ZN(n5) );
  NOR2_X1 U66 ( .A1(n21), .A2(n14), .ZN(n12) );
  OR2_X1 U67 ( .A1(n31), .A2(n28), .ZN(n85) );
  AOI21_X2 U68 ( .B1(n34), .B2(n42), .A(n35), .ZN(n86) );
  AOI21_X1 U69 ( .B1(n34), .B2(n42), .A(n35), .ZN(n1) );
  NOR2_X2 U70 ( .A1(B[3]), .A2(A[3]), .ZN(n36) );
  INV_X1 U71 ( .A(n43), .ZN(n52) );
  CLKBUF_X1 U72 ( .A(n88), .Z(n87) );
  NAND2_X1 U73 ( .A1(n52), .A2(n44), .ZN(n8) );
  NAND2_X1 U74 ( .A1(B[1]), .A2(A[1]), .ZN(n44) );
  NOR2_X1 U75 ( .A1(B[3]), .A2(A[3]), .ZN(n88) );
  OAI21_X1 U76 ( .B1(n28), .B2(n32), .A(n29), .ZN(n89) );
  NAND2_X1 U77 ( .A1(A[4]), .A2(B[4]), .ZN(n32) );
  OAI21_X1 U78 ( .B1(n28), .B2(n32), .A(n29), .ZN(n27) );
  NAND2_X1 U79 ( .A1(n50), .A2(n37), .ZN(n6) );
  INV_X1 U80 ( .A(n14), .ZN(n46) );
  NOR2_X2 U81 ( .A1(B[7]), .A2(A[7]), .ZN(n14) );
  INV_X1 U82 ( .A(n51), .ZN(n90) );
  NAND2_X1 U83 ( .A1(n51), .A2(n40), .ZN(n7) );
  CLKBUF_X1 U84 ( .A(n45), .Z(n91) );
  XOR2_X1 U85 ( .A(n8), .B(n91), .Z(SUM[1]) );
  OAI21_X1 U86 ( .B1(n43), .B2(n45), .A(n44), .ZN(n92) );
  NOR2_X2 U87 ( .A1(B[5]), .A2(A[5]), .ZN(n28) );
  NOR2_X1 U88 ( .A1(B[4]), .A2(A[4]), .ZN(n31) );
  OAI21_X1 U89 ( .B1(n1), .B2(n17), .A(n18), .ZN(n16) );
  NOR2_X2 U90 ( .A1(n39), .A2(n88), .ZN(n34) );
  INV_X1 U91 ( .A(n92), .ZN(n41) );
  NAND2_X1 U92 ( .A1(n26), .A2(n12), .ZN(n10) );
  NAND2_X1 U93 ( .A1(n26), .A2(n47), .ZN(n17) );
  NOR2_X2 U94 ( .A1(n31), .A2(n28), .ZN(n26) );
  OAI21_X2 U95 ( .B1(n36), .B2(n40), .A(n37), .ZN(n35) );
  OAI21_X2 U96 ( .B1(n43), .B2(n45), .A(n44), .ZN(n42) );
  NAND2_X1 U97 ( .A1(B[0]), .A2(A[0]), .ZN(n45) );
  XNOR2_X1 U98 ( .A(n16), .B(n2), .ZN(SUM[7]) );
  NAND2_X2 U99 ( .A1(B[6]), .A2(A[6]), .ZN(n22) );
  NOR2_X2 U100 ( .A1(B[6]), .A2(A[6]), .ZN(n21) );
  INV_X1 U101 ( .A(n87), .ZN(n50) );
  NAND2_X1 U102 ( .A1(B[5]), .A2(A[5]), .ZN(n29) );
  NOR2_X1 U103 ( .A1(A[2]), .A2(B[2]), .ZN(n39) );
  INV_X1 U104 ( .A(n28), .ZN(n48) );
  XNOR2_X1 U105 ( .A(n23), .B(n3), .ZN(SUM[6]) );
  OAI21_X1 U106 ( .B1(n41), .B2(n90), .A(n40), .ZN(n38) );
  INV_X1 U107 ( .A(n39), .ZN(n51) );
  XNOR2_X1 U108 ( .A(n30), .B(n4), .ZN(SUM[5]) );
  NOR2_X2 U109 ( .A1(B[1]), .A2(A[1]), .ZN(n43) );
  AOI21_X1 U110 ( .B1(n12), .B2(n89), .A(n13), .ZN(n11) );
  INV_X1 U111 ( .A(n89), .ZN(n25) );
  AOI21_X1 U112 ( .B1(n27), .B2(n47), .A(n20), .ZN(n18) );
  OAI21_X1 U113 ( .B1(n86), .B2(n10), .A(n11), .ZN(SUM[8]) );
  XOR2_X1 U114 ( .A(n86), .B(n5), .Z(SUM[4]) );
  OAI21_X1 U115 ( .B1(n86), .B2(n85), .A(n25), .ZN(n23) );
  OAI21_X1 U116 ( .B1(n1), .B2(n31), .A(n32), .ZN(n30) );
  NAND2_X1 U117 ( .A1(B[3]), .A2(A[3]), .ZN(n37) );
  INV_X2 U118 ( .A(n31), .ZN(n49) );
  INV_X2 U119 ( .A(n22), .ZN(n20) );
  INV_X2 U120 ( .A(n21), .ZN(n47) );
endmodule


module rgb2gray ( clk, resetn, r, b, g, gray );
  input [7:0] r;
  input [7:0] b;
  input [7:0] g;
  output [7:0] gray;
  input clk, resetn;
  wire   N4, N5, N6, N8, N9, N10, N20, N21, N22, N24, N25, N26, n20, n21, n22,
         n23, n24, n25, n26, n27, n28, n29, n30, n31, n32, n33, n34, n35, n36,
         n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48, n49, n50,
         n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62, n63, n64,
         n65, n66, n67, n68, n69, n70, n71, n72, n73, n74, n75, n76, n77, n78,
         n79, n80, n81, n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92,
         n93, n94, n95, n96, n97, n98, n99, n100, n101, n102, n103, n104, n105,
         n106, n107, n108, n109, n110, n111, n112, n113, n114, n115, n116,
         n117, n118, n119, n120, n121, n122, n123, n124, n125, n126, n127,
         n128, n129, n130, n131, n132, n133, n134, n135, n136, n137, n138,
         n139, n140, n141, n142, n143, n144, n145, n146, n147, n148, n149,
         n150, n151, n152, n153, n154, n155, n156, n157, n158, n159, n160,
         n161, n162, n163, n164, n165, n166, n167, n168, n169, n170, n171,
         n172, n173, n174, n175, n176, n177, n178, n179, n180, n181, n182,
         n183, n184, n185, n186, n187, n188, n189, n190, n191, n192, n193,
         n194, n195, n196, n197, n198, n199, n200, n201, n202, n203, n204,
         n205, n206, n207, n208, n209, n210, n211, n212, n213, n214, n215,
         n216, n217, n218, n219, n220, n221, n222, n223, n224, n225, n226,
         n227, n228, n229, n230, n231, n232, n233, n234, n235, n236, n237,
         n238, n239, n240, n241, n242, n243, n244;
  wire   [7:0] r_int;
  wire   [7:0] b_int;
  wire   [7:0] g_int;
  wire   [7:0] max;
  wire   [7:0] min;
  wire   [8:1] sum;
  wire   SYNOPSYS_UNCONNECTED__0;

  AND2_X2 C141 ( .A1(N8), .A2(N9), .ZN(N10) );
  AND2_X2 C137 ( .A1(N5), .A2(N4), .ZN(N6) );
  DFFR_X1 \r_int_reg[7]  ( .D(r[7]), .CK(clk), .RN(resetn), .Q(r_int[7]), .QN(
        n25) );
  DFFR_X1 \r_int_reg[6]  ( .D(r[6]), .CK(clk), .RN(resetn), .Q(r_int[6]), .QN(
        n28) );
  DFFR_X1 \r_int_reg[5]  ( .D(r[5]), .CK(clk), .RN(resetn), .Q(r_int[5]), .QN(
        n31) );
  DFFR_X1 \r_int_reg[4]  ( .D(r[4]), .CK(clk), .RN(resetn), .Q(r_int[4]), .QN(
        n34) );
  DFFR_X1 \r_int_reg[3]  ( .D(r[3]), .CK(clk), .RN(resetn), .Q(r_int[3]), .QN(
        n37) );
  DFFR_X1 \r_int_reg[2]  ( .D(r[2]), .CK(clk), .RN(resetn), .Q(r_int[2]), .QN(
        n40) );
  DFFR_X1 \r_int_reg[1]  ( .D(r[1]), .CK(clk), .RN(resetn), .Q(r_int[1]), .QN(
        n43) );
  DFFR_X1 \r_int_reg[0]  ( .D(r[0]), .CK(clk), .RN(resetn), .Q(r_int[0]), .QN(
        n46) );
  DFFR_X1 \b_int_reg[7]  ( .D(b[7]), .CK(clk), .RN(resetn), .Q(b_int[7]), .QN(
        n23) );
  DFFR_X1 \b_int_reg[6]  ( .D(b[6]), .CK(clk), .RN(resetn), .Q(b_int[6]), .QN(
        n27) );
  DFFR_X1 \b_int_reg[5]  ( .D(b[5]), .CK(clk), .RN(resetn), .Q(b_int[5]), .QN(
        n30) );
  DFFR_X1 \b_int_reg[4]  ( .D(b[4]), .CK(clk), .RN(resetn), .Q(b_int[4]), .QN(
        n33) );
  DFFR_X1 \b_int_reg[3]  ( .D(b[3]), .CK(clk), .RN(resetn), .Q(b_int[3]), .QN(
        n36) );
  DFFR_X1 \b_int_reg[2]  ( .D(b[2]), .CK(clk), .RN(resetn), .Q(b_int[2]), .QN(
        n39) );
  DFFR_X1 \b_int_reg[1]  ( .D(b[1]), .CK(clk), .RN(resetn), .Q(b_int[1]), .QN(
        n42) );
  DFFR_X1 \b_int_reg[0]  ( .D(b[0]), .CK(clk), .RN(resetn), .Q(b_int[0]), .QN(
        n45) );
  DFFR_X1 \g_int_reg[7]  ( .D(g[7]), .CK(clk), .RN(resetn), .Q(g_int[7]), .QN(
        n21) );
  DFFR_X1 \g_int_reg[6]  ( .D(g[6]), .CK(clk), .RN(resetn), .Q(g_int[6]), .QN(
        n26) );
  DFFR_X1 \g_int_reg[5]  ( .D(g[5]), .CK(clk), .RN(resetn), .Q(g_int[5]), .QN(
        n29) );
  DFFR_X1 \g_int_reg[4]  ( .D(g[4]), .CK(clk), .RN(resetn), .Q(g_int[4]), .QN(
        n32) );
  DFFR_X1 \g_int_reg[3]  ( .D(g[3]), .CK(clk), .RN(resetn), .Q(g_int[3]), .QN(
        n35) );
  DFFR_X1 \g_int_reg[2]  ( .D(g[2]), .CK(clk), .RN(resetn), .Q(g_int[2]), .QN(
        n38) );
  DFFR_X1 \g_int_reg[1]  ( .D(g[1]), .CK(clk), .RN(resetn), .Q(g_int[1]), .QN(
        n41) );
  DFFR_X1 \g_int_reg[0]  ( .D(g[0]), .CK(clk), .RN(resetn), .Q(g_int[0]), .QN(
        n44) );
  DFFR_X1 \gray_reg[0]  ( .D(sum[1]), .CK(clk), .RN(resetn), .Q(gray[0]) );
  DFFR_X1 \gray_reg[1]  ( .D(sum[2]), .CK(clk), .RN(resetn), .Q(gray[1]) );
  DFFR_X1 \gray_reg[2]  ( .D(sum[3]), .CK(clk), .RN(resetn), .Q(gray[2]) );
  DFFR_X1 \gray_reg[3]  ( .D(sum[4]), .CK(clk), .RN(resetn), .Q(gray[3]) );
  DFFR_X1 \gray_reg[6]  ( .D(sum[7]), .CK(clk), .RN(resetn), .Q(gray[6]) );
  DFFR_X1 \gray_reg[7]  ( .D(sum[8]), .CK(clk), .RN(resetn), .Q(gray[7]) );
  OAI222_X1 U3 ( .A1(n55), .A2(n21), .B1(n74), .B2(n23), .C1(n72), .C2(n25), 
        .ZN(min[7]) );
  OAI222_X1 U9 ( .A1(n55), .A2(n26), .B1(n74), .B2(n27), .C1(n71), .C2(n28), 
        .ZN(min[6]) );
  OAI222_X1 U11 ( .A1(n56), .A2(n32), .B1(n74), .B2(n33), .C1(n71), .C2(n34), 
        .ZN(min[4]) );
  OAI222_X1 U15 ( .A1(n56), .A2(n44), .B1(n22), .B2(n45), .C1(n72), .C2(n46), 
        .ZN(min[0]) );
  OAI222_X1 U19 ( .A1(n21), .A2(n79), .B1(n48), .B2(n23), .C1(n25), .C2(n49), 
        .ZN(max[7]) );
  OAI222_X1 U20 ( .A1(n80), .A2(n26), .B1(n48), .B2(n27), .C1(n28), .C2(n49), 
        .ZN(max[6]) );
  OAI222_X1 U21 ( .A1(n29), .A2(n79), .B1(n48), .B2(n30), .C1(n31), .C2(n49), 
        .ZN(max[5]) );
  OAI222_X1 U22 ( .A1(n32), .A2(n80), .B1(n48), .B2(n33), .C1(n34), .C2(n49), 
        .ZN(max[4]) );
  OAI222_X1 U23 ( .A1(n35), .A2(n47), .B1(n48), .B2(n36), .C1(n49), .C2(n37), 
        .ZN(max[3]) );
  OAI222_X1 U25 ( .A1(n41), .A2(n47), .B1(n48), .B2(n42), .C1(n43), .C2(n49), 
        .ZN(max[1]) );
  OAI222_X1 U26 ( .A1(n44), .A2(n79), .B1(n48), .B2(n45), .C1(n46), .C2(n49), 
        .ZN(max[0]) );
  rgb2gray_DW01_add_2 add_66 ( .A({1'b0, max}), .B({1'b0, min}), .CI(1'b0), 
        .SUM({sum, SYNOPSYS_UNCONNECTED__0}) );
  DFFR_X2 \gray_reg[5]  ( .D(sum[6]), .CK(clk), .RN(resetn), .Q(gray[5]) );
  DFFR_X1 \gray_reg[4]  ( .D(sum[5]), .CK(clk), .RN(resetn), .Q(gray[4]) );
  AND2_X2 U30 ( .A1(N20), .A2(N21), .ZN(N22) );
  NAND2_X1 U31 ( .A1(N26), .A2(n24), .ZN(n20) );
  AND2_X1 U32 ( .A1(N9), .A2(N8), .ZN(n68) );
  AND2_X1 U33 ( .A1(b_int[0]), .A2(n222), .ZN(n208) );
  INV_X1 U34 ( .A(n165), .ZN(n50) );
  CLKBUF_X1 U35 ( .A(n169), .Z(n51) );
  OR2_X2 U36 ( .A1(n77), .A2(n70), .ZN(n22) );
  OR2_X4 U37 ( .A1(N22), .A2(n70), .ZN(n74) );
  INV_X2 U38 ( .A(N6), .ZN(n49) );
  NAND2_X1 U39 ( .A1(n149), .A2(n150), .ZN(n52) );
  NAND2_X1 U40 ( .A1(n151), .A2(n53), .ZN(n154) );
  INV_X1 U41 ( .A(n52), .ZN(n53) );
  OR2_X1 U42 ( .A1(n76), .A2(n58), .ZN(n54) );
  BUF_X1 U43 ( .A(b_int[0]), .Z(n58) );
  NOR2_X2 U44 ( .A1(n181), .A2(n58), .ZN(n227) );
  NAND2_X1 U45 ( .A1(N26), .A2(n24), .ZN(n55) );
  NAND2_X1 U46 ( .A1(N26), .A2(n24), .ZN(n56) );
  INV_X1 U47 ( .A(n183), .ZN(n57) );
  OR2_X2 U48 ( .A1(n86), .A2(r_int[2]), .ZN(n90) );
  AOI21_X2 U49 ( .B1(n223), .B2(n208), .A(b_int[1]), .ZN(n205) );
  CLKBUF_X1 U50 ( .A(n90), .Z(n59) );
  INV_X1 U51 ( .A(g_int[2]), .ZN(n60) );
  INV_X1 U52 ( .A(n60), .ZN(n61) );
  NOR2_X2 U53 ( .A1(n76), .A2(n83), .ZN(n107) );
  NAND2_X2 U54 ( .A1(n155), .A2(n152), .ZN(n62) );
  NAND2_X1 U55 ( .A1(n138), .A2(n63), .ZN(n139) );
  INV_X1 U56 ( .A(n62), .ZN(n63) );
  OAI222_X2 U57 ( .A1(n20), .A2(n35), .B1(n66), .B2(n36), .C1(n72), .C2(n37), 
        .ZN(min[3]) );
  NAND2_X1 U58 ( .A1(n117), .A2(n114), .ZN(n64) );
  NAND2_X1 U59 ( .A1(n98), .A2(n65), .ZN(n99) );
  INV_X1 U60 ( .A(n64), .ZN(n65) );
  AND2_X1 U61 ( .A1(b_int[0]), .A2(n102), .ZN(n128) );
  AOI21_X2 U62 ( .B1(n103), .B2(n88), .A(g_int[1]), .ZN(n85) );
  AND2_X2 U63 ( .A1(N20), .A2(N21), .ZN(n77) );
  OAI222_X2 U64 ( .A1(n56), .A2(n41), .B1(n66), .B2(n42), .C1(n72), .C2(n43), 
        .ZN(min[1]) );
  OAI222_X2 U65 ( .A1(n20), .A2(n38), .B1(n22), .B2(n39), .C1(n71), .C2(n40), 
        .ZN(min[2]) );
  OR2_X2 U66 ( .A1(n77), .A2(N26), .ZN(n66) );
  AND2_X2 U67 ( .A1(N25), .A2(N24), .ZN(N26) );
  OR2_X2 U68 ( .A1(n165), .A2(n61), .ZN(n169) );
  INV_X1 U69 ( .A(n60), .ZN(n67) );
  INV_X1 U70 ( .A(n54), .ZN(n145) );
  NOR2_X2 U71 ( .A1(n222), .A2(n75), .ZN(n186) );
  CLKBUF_X1 U72 ( .A(n188), .Z(n69) );
  AND2_X2 U73 ( .A1(N24), .A2(N25), .ZN(n70) );
  INV_X1 U74 ( .A(N22), .ZN(n71) );
  INV_X1 U75 ( .A(N22), .ZN(n72) );
  INV_X1 U76 ( .A(n77), .ZN(n24) );
  AND2_X2 U77 ( .A1(n130), .A2(n147), .ZN(n143) );
  CLKBUF_X1 U78 ( .A(n109), .Z(n73) );
  INV_X1 U79 ( .A(n102), .ZN(n75) );
  INV_X1 U80 ( .A(r_int[0]), .ZN(n76) );
  OR2_X4 U81 ( .A1(N10), .A2(N6), .ZN(n48) );
  AND2_X2 U82 ( .A1(n169), .A2(n188), .ZN(n184) );
  OR2_X2 U83 ( .A1(n76), .A2(n58), .ZN(n78) );
  NAND2_X1 U84 ( .A1(n49), .A2(n68), .ZN(n79) );
  NAND2_X1 U85 ( .A1(n68), .A2(n49), .ZN(n80) );
  NAND2_X1 U86 ( .A1(n68), .A2(n49), .ZN(n47) );
  OAI222_X1 U87 ( .A1(n55), .A2(n29), .B1(n74), .B2(n30), .C1(n71), .C2(n31), 
        .ZN(min[5]) );
  NAND2_X1 U88 ( .A1(n231), .A2(n232), .ZN(n81) );
  NAND2_X1 U89 ( .A1(n233), .A2(n82), .ZN(n236) );
  INV_X1 U90 ( .A(n81), .ZN(n82) );
  INV_X1 U91 ( .A(n181), .ZN(n83) );
  OAI222_X1 U92 ( .A1(n80), .A2(n38), .B1(n48), .B2(n39), .C1(n49), .C2(n40), 
        .ZN(max[2]) );
  AND2_X2 U93 ( .A1(n90), .A2(n109), .ZN(n105) );
  INV_X1 U94 ( .A(g_int[7]), .ZN(n84) );
  NAND2_X1 U95 ( .A1(r_int[7]), .A2(n84), .ZN(n120) );
  OR2_X1 U96 ( .A1(n84), .A2(r_int[7]), .ZN(n124) );
  INV_X1 U97 ( .A(r_int[6]), .ZN(n97) );
  NAND2_X1 U98 ( .A1(g_int[6]), .A2(n97), .ZN(n100) );
  INV_X1 U99 ( .A(r_int[5]), .ZN(n96) );
  NAND2_X1 U100 ( .A1(g_int[5]), .A2(n96), .ZN(n118) );
  INV_X1 U101 ( .A(g_int[4]), .ZN(n92) );
  OR2_X1 U102 ( .A1(n92), .A2(r_int[4]), .ZN(n95) );
  INV_X1 U103 ( .A(r_int[3]), .ZN(n91) );
  NAND2_X1 U104 ( .A1(g_int[3]), .A2(n91), .ZN(n112) );
  INV_X1 U105 ( .A(g_int[2]), .ZN(n86) );
  INV_X1 U106 ( .A(r_int[0]), .ZN(n102) );
  AND2_X1 U107 ( .A1(n102), .A2(g_int[0]), .ZN(n88) );
  INV_X1 U108 ( .A(r_int[1]), .ZN(n103) );
  INV_X1 U109 ( .A(n85), .ZN(n87) );
  NAND2_X1 U110 ( .A1(n50), .A2(n86), .ZN(n109) );
  OAI211_X1 U111 ( .C1(n88), .C2(n103), .A(n87), .B(n105), .ZN(n89) );
  NAND3_X1 U112 ( .A1(n89), .A2(n59), .A3(n112), .ZN(n93) );
  OR2_X1 U113 ( .A1(n91), .A2(g_int[3]), .ZN(n108) );
  NAND2_X1 U114 ( .A1(r_int[4]), .A2(n92), .ZN(n115) );
  AND2_X1 U115 ( .A1(n95), .A2(n115), .ZN(n111) );
  NAND3_X1 U116 ( .A1(n93), .A2(n108), .A3(n111), .ZN(n94) );
  NAND3_X1 U117 ( .A1(n94), .A2(n95), .A3(n118), .ZN(n98) );
  OR2_X1 U118 ( .A1(n96), .A2(g_int[5]), .ZN(n114) );
  OR2_X1 U119 ( .A1(n97), .A2(g_int[6]), .ZN(n121) );
  AND2_X1 U120 ( .A1(n121), .A2(n100), .ZN(n117) );
  NAND3_X1 U121 ( .A1(n99), .A2(n100), .A3(n124), .ZN(n101) );
  NAND2_X1 U122 ( .A1(n101), .A2(n120), .ZN(N4) );
  INV_X1 U123 ( .A(n107), .ZN(n104) );
  OAI21_X1 U124 ( .B1(n104), .B2(n103), .A(g_int[1]), .ZN(n106) );
  OAI211_X1 U125 ( .C1(r_int[1]), .C2(n107), .A(n106), .B(n105), .ZN(n110) );
  NAND3_X1 U126 ( .A1(n110), .A2(n73), .A3(n108), .ZN(n113) );
  NAND3_X1 U127 ( .A1(n113), .A2(n112), .A3(n111), .ZN(n116) );
  NAND3_X1 U128 ( .A1(n116), .A2(n115), .A3(n114), .ZN(n119) );
  NAND3_X1 U129 ( .A1(n119), .A2(n118), .A3(n117), .ZN(n122) );
  NAND3_X1 U130 ( .A1(n122), .A2(n121), .A3(n120), .ZN(n123) );
  NAND2_X1 U131 ( .A1(n124), .A2(n123), .ZN(N20) );
  INV_X1 U132 ( .A(b_int[7]), .ZN(n125) );
  NAND2_X1 U133 ( .A1(r_int[7]), .A2(n125), .ZN(n158) );
  OR2_X1 U134 ( .A1(n125), .A2(r_int[7]), .ZN(n162) );
  INV_X1 U135 ( .A(r_int[6]), .ZN(n137) );
  NAND2_X1 U136 ( .A1(b_int[6]), .A2(n137), .ZN(n140) );
  INV_X1 U137 ( .A(r_int[5]), .ZN(n136) );
  NAND2_X1 U138 ( .A1(b_int[5]), .A2(n136), .ZN(n156) );
  INV_X1 U139 ( .A(b_int[4]), .ZN(n132) );
  OR2_X1 U140 ( .A1(n132), .A2(r_int[4]), .ZN(n135) );
  INV_X1 U141 ( .A(r_int[3]), .ZN(n131) );
  NAND2_X1 U142 ( .A1(b_int[3]), .A2(n131), .ZN(n150) );
  OR2_X1 U143 ( .A1(n206), .A2(r_int[2]), .ZN(n130) );
  INV_X1 U144 ( .A(r_int[1]), .ZN(n142) );
  AOI21_X1 U145 ( .B1(n128), .B2(n142), .A(b_int[1]), .ZN(n126) );
  INV_X1 U146 ( .A(n126), .ZN(n127) );
  NAND2_X1 U147 ( .A1(r_int[2]), .A2(n206), .ZN(n147) );
  OAI211_X1 U148 ( .C1(n128), .C2(n142), .A(n127), .B(n143), .ZN(n129) );
  NAND3_X1 U149 ( .A1(n130), .A2(n150), .A3(n129), .ZN(n133) );
  OR2_X1 U150 ( .A1(n131), .A2(b_int[3]), .ZN(n146) );
  NAND2_X1 U151 ( .A1(r_int[4]), .A2(n132), .ZN(n153) );
  AND2_X1 U152 ( .A1(n135), .A2(n153), .ZN(n149) );
  NAND3_X1 U153 ( .A1(n133), .A2(n146), .A3(n149), .ZN(n134) );
  NAND3_X1 U154 ( .A1(n134), .A2(n135), .A3(n156), .ZN(n138) );
  OR2_X1 U155 ( .A1(n136), .A2(b_int[5]), .ZN(n152) );
  OR2_X1 U156 ( .A1(n137), .A2(b_int[6]), .ZN(n159) );
  AND2_X1 U157 ( .A1(n159), .A2(n140), .ZN(n155) );
  NAND3_X1 U158 ( .A1(n139), .A2(n140), .A3(n162), .ZN(n141) );
  NAND2_X1 U159 ( .A1(n141), .A2(n158), .ZN(N5) );
  OAI21_X1 U160 ( .B1(n78), .B2(n142), .A(b_int[1]), .ZN(n144) );
  OAI211_X1 U161 ( .C1(r_int[1]), .C2(n145), .A(n144), .B(n143), .ZN(n148) );
  NAND3_X1 U162 ( .A1(n148), .A2(n147), .A3(n146), .ZN(n151) );
  NAND3_X1 U163 ( .A1(n154), .A2(n153), .A3(n152), .ZN(n157) );
  NAND3_X1 U164 ( .A1(n157), .A2(n156), .A3(n155), .ZN(n160) );
  NAND3_X1 U165 ( .A1(n160), .A2(n159), .A3(n158), .ZN(n161) );
  NAND2_X1 U166 ( .A1(n161), .A2(n162), .ZN(N21) );
  INV_X1 U167 ( .A(r_int[7]), .ZN(n163) );
  NAND2_X1 U168 ( .A1(g_int[7]), .A2(n163), .ZN(n199) );
  OR2_X1 U169 ( .A1(n163), .A2(g_int[7]), .ZN(n203) );
  INV_X1 U170 ( .A(g_int[6]), .ZN(n176) );
  NAND2_X1 U171 ( .A1(r_int[6]), .A2(n176), .ZN(n179) );
  INV_X1 U172 ( .A(g_int[5]), .ZN(n175) );
  NAND2_X1 U173 ( .A1(r_int[5]), .A2(n175), .ZN(n197) );
  INV_X1 U174 ( .A(r_int[4]), .ZN(n171) );
  OR2_X1 U175 ( .A1(n171), .A2(g_int[4]), .ZN(n174) );
  INV_X1 U176 ( .A(g_int[3]), .ZN(n170) );
  NAND2_X1 U177 ( .A1(r_int[3]), .A2(n170), .ZN(n191) );
  INV_X1 U178 ( .A(r_int[2]), .ZN(n165) );
  INV_X1 U179 ( .A(g_int[0]), .ZN(n181) );
  AND2_X1 U180 ( .A1(r_int[0]), .A2(n222), .ZN(n167) );
  INV_X1 U181 ( .A(g_int[1]), .ZN(n182) );
  AOI21_X1 U182 ( .B1(n182), .B2(n167), .A(r_int[1]), .ZN(n164) );
  INV_X1 U183 ( .A(n164), .ZN(n166) );
  NAND2_X1 U184 ( .A1(n165), .A2(n67), .ZN(n188) );
  OAI211_X1 U185 ( .C1(n167), .C2(n182), .A(n166), .B(n184), .ZN(n168) );
  NAND3_X1 U186 ( .A1(n168), .A2(n51), .A3(n191), .ZN(n172) );
  OR2_X1 U187 ( .A1(n170), .A2(r_int[3]), .ZN(n187) );
  NAND2_X1 U188 ( .A1(g_int[4]), .A2(n171), .ZN(n194) );
  AND2_X1 U189 ( .A1(n174), .A2(n194), .ZN(n190) );
  NAND3_X1 U190 ( .A1(n172), .A2(n187), .A3(n190), .ZN(n173) );
  NAND3_X1 U191 ( .A1(n173), .A2(n174), .A3(n197), .ZN(n177) );
  OR2_X1 U192 ( .A1(n175), .A2(r_int[5]), .ZN(n193) );
  OR2_X1 U193 ( .A1(n176), .A2(r_int[6]), .ZN(n200) );
  AND2_X1 U194 ( .A1(n200), .A2(n179), .ZN(n196) );
  NAND3_X1 U195 ( .A1(n177), .A2(n193), .A3(n196), .ZN(n178) );
  NAND3_X1 U196 ( .A1(n178), .A2(n179), .A3(n203), .ZN(n180) );
  NAND2_X1 U197 ( .A1(n180), .A2(n199), .ZN(N8) );
  INV_X1 U198 ( .A(n186), .ZN(n183) );
  OAI21_X1 U199 ( .B1(n183), .B2(n182), .A(r_int[1]), .ZN(n185) );
  OAI211_X1 U200 ( .C1(g_int[1]), .C2(n57), .A(n184), .B(n185), .ZN(n189) );
  NAND3_X1 U201 ( .A1(n189), .A2(n69), .A3(n187), .ZN(n192) );
  NAND3_X1 U202 ( .A1(n192), .A2(n191), .A3(n190), .ZN(n195) );
  NAND3_X1 U203 ( .A1(n195), .A2(n194), .A3(n193), .ZN(n198) );
  NAND3_X1 U204 ( .A1(n198), .A2(n197), .A3(n196), .ZN(n201) );
  NAND3_X1 U205 ( .A1(n201), .A2(n200), .A3(n199), .ZN(n202) );
  NAND2_X1 U206 ( .A1(n203), .A2(n202), .ZN(N24) );
  INV_X1 U207 ( .A(b_int[7]), .ZN(n204) );
  NAND2_X1 U208 ( .A1(g_int[7]), .A2(n204), .ZN(n240) );
  OR2_X1 U209 ( .A1(n204), .A2(g_int[7]), .ZN(n244) );
  INV_X1 U210 ( .A(g_int[6]), .ZN(n217) );
  NAND2_X1 U211 ( .A1(b_int[6]), .A2(n217), .ZN(n220) );
  INV_X1 U212 ( .A(g_int[5]), .ZN(n216) );
  NAND2_X1 U213 ( .A1(b_int[5]), .A2(n216), .ZN(n238) );
  INV_X1 U214 ( .A(b_int[4]), .ZN(n212) );
  OR2_X1 U215 ( .A1(n212), .A2(g_int[4]), .ZN(n215) );
  INV_X1 U216 ( .A(g_int[3]), .ZN(n211) );
  NAND2_X1 U217 ( .A1(b_int[3]), .A2(n211), .ZN(n232) );
  INV_X1 U218 ( .A(b_int[2]), .ZN(n206) );
  OR2_X1 U219 ( .A1(g_int[2]), .A2(n206), .ZN(n210) );
  INV_X1 U220 ( .A(g_int[0]), .ZN(n222) );
  INV_X1 U221 ( .A(g_int[1]), .ZN(n223) );
  INV_X1 U222 ( .A(n205), .ZN(n207) );
  NAND2_X1 U223 ( .A1(n67), .A2(n206), .ZN(n229) );
  AND2_X1 U224 ( .A1(n210), .A2(n229), .ZN(n225) );
  OAI211_X1 U225 ( .C1(n208), .C2(n223), .A(n207), .B(n225), .ZN(n209) );
  NAND3_X1 U226 ( .A1(n209), .A2(n210), .A3(n232), .ZN(n213) );
  OR2_X1 U227 ( .A1(n211), .A2(b_int[3]), .ZN(n228) );
  NAND2_X1 U228 ( .A1(g_int[4]), .A2(n212), .ZN(n235) );
  AND2_X1 U229 ( .A1(n215), .A2(n235), .ZN(n231) );
  NAND3_X1 U230 ( .A1(n213), .A2(n228), .A3(n231), .ZN(n214) );
  NAND3_X1 U231 ( .A1(n238), .A2(n215), .A3(n214), .ZN(n218) );
  OR2_X1 U232 ( .A1(n216), .A2(b_int[5]), .ZN(n234) );
  OR2_X1 U233 ( .A1(n217), .A2(b_int[6]), .ZN(n241) );
  AND2_X1 U234 ( .A1(n241), .A2(n220), .ZN(n237) );
  NAND3_X1 U235 ( .A1(n218), .A2(n234), .A3(n237), .ZN(n219) );
  NAND3_X1 U236 ( .A1(n219), .A2(n220), .A3(n244), .ZN(n221) );
  NAND2_X1 U237 ( .A1(n221), .A2(n240), .ZN(N9) );
  INV_X1 U238 ( .A(n227), .ZN(n224) );
  OAI21_X1 U239 ( .B1(n224), .B2(n223), .A(b_int[1]), .ZN(n226) );
  OAI211_X1 U240 ( .C1(g_int[1]), .C2(n227), .A(n226), .B(n225), .ZN(n230) );
  NAND3_X1 U241 ( .A1(n230), .A2(n229), .A3(n228), .ZN(n233) );
  NAND3_X1 U242 ( .A1(n236), .A2(n235), .A3(n234), .ZN(n239) );
  NAND3_X1 U243 ( .A1(n239), .A2(n238), .A3(n237), .ZN(n242) );
  NAND3_X1 U244 ( .A1(n242), .A2(n241), .A3(n240), .ZN(n243) );
  NAND2_X1 U245 ( .A1(n243), .A2(n244), .ZN(N25) );
endmodule

