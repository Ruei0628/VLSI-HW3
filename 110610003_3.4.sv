// Naming convention:
// HA_i_j(_k) : Half Adder in bit j, stage i. 

// FA_i_j(_k) : Full Adder in bit j, stage i. 
// If there are more than one HA in a single bit, add _k.

// There are 50 adders in this design which produce logic [49:0] carry, sum

module full_adder(input a, input b, input cin, output sum, output cout);
  assign sum = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module half_adder(input a, input b, output sum, output cout);
  assign sum = a ^ b;
  assign cout = a & b;
endmodule

module BKT_16 (
    output logic [15:0] s_o,
    output logic       c_o,
    input  logic [15:0] a_i,
    input  logic [15:0] b_i
);
    logic [15:0] G, P;
    logic [15:0] C;

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign G[i] = a_i[i] & b_i[i];
            assign P[i] = a_i[i] ^ b_i[i];
        end
    endgenerate

    logic [7:0] G1, P1;
    assign G1[0] = G[1]  | (P[1]  & G[0]);
    assign G1[1] = G[3]  | (P[3]  & G[2]);
    assign G1[2] = G[5]  | (P[5]  & G[4]);
    assign G1[3] = G[7]  | (P[7]  & G[6]);
    assign G1[4] = G[9]  | (P[9]  & G[8]);
    assign G1[5] = G[11] | (P[11] & G[10]);
    assign G1[6] = G[13] | (P[13] & G[12]);
    assign G1[7] = G[15] | (P[15] & G[14]);

    assign P1[0] = P[1]  & P[0];
    assign P1[1] = P[3]  & P[2];
    assign P1[2] = P[5]  & P[4];
    assign P1[3] = P[7]  & P[6];
    assign P1[4] = P[9]  & P[8];
    assign P1[5] = P[11] & P[10];
    assign P1[6] = P[13] & P[12];
    assign P1[7] = P[15] & P[14];

    logic [3:0] G2, P2;
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign G2[2] = G1[5] | (P1[5] & G1[4]);
    assign G2[3] = G1[7] | (P1[7] & G1[6]);

    assign P2[0] = P1[1] & P1[0];
    assign P2[1] = P1[3] & P1[2];
    assign P2[2] = P1[5] & P1[4];
    assign P2[3] = P1[7] & P1[6];

    logic [1:0] G3, P3;
    assign G3[0] = G2[1] | (P2[1] & G2[0]);
    assign G3[1] = G2[3] | (P2[3] & G2[2]);

    assign P3[0] = P2[1] & P2[0];
    assign P3[1] = P2[3] & P2[2];

    logic G4, P4;
    assign G4 = G3[1] | (P3[1] & G3[0]);
    assign P4 = P3[1] & P3[0];

    assign C[0] = 1'b0;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G1[0] | (P1[0] & C[0]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign C[4] = G2[0] | (P2[0] & C[0]);
    assign C[5] = G[4] | (P[4] & C[4]);
    assign C[6] = G1[2] | (P1[2] & C[4]);
    assign C[7] = G[6] | (P[6] & C[6]);
    assign C[8] = G3[0] | (P3[0] & C[0]);
    assign C[9] = G[8] | (P[8] & C[8]);
    assign C[10] = G1[4] | (P1[4] & C[8]);
    assign C[11] = G[10] | (P[10] & C[10]);
    assign C[12] = G2[2] | (P2[2] & C[8]);
    assign C[13] = G[12] | (P[12] & C[12]);
    assign C[14] = G1[6] | (P1[6] & C[12]);
    assign C[15] = G[14] | (P[14] & C[14]);

    genvar j;
    generate
        for (j = 0; j < 16; j++) begin
            assign s_o[j] = P[j] ^ C[j];
        end
    endgenerate

    assign c_o = G[15] | (P[15] & C[15]);

endmodule

module Wallace_Tree_9X7 (
  output  logic [15:0] out,
  input   logic [8:0]  a_i,
  input   logic [6:0]  b_i
);

  wire [6:0] pp [8:0];
  logic [15:0] final1, final2;
  logic [49:0] carry, sum;
  logic [15:0] s_o;
  logic c_o;

genvar i, j;
generate
for (i = 0; i < 9; i = i + 1) begin: row_loop
    for (j = 0; j < 7; j = j + 1) begin: col_loop
    assign pp[i][j] = a_i[i] & b_i[j];
    end
end
endgenerate

/*
// debug
initial begin
integer i, j;

# 75;  // To see n-th data -> # (25 + 50 * n)

for(i = 0; i < 9; i = i+1) begin
  for(j = 0; j < 7; j = j+1) begin
    $display("a%0db%0d = %0d", i, j, pp[i][j]);
  end
end

for (i = 0; i < 50; i = i + 1) begin
  $display("sum[%0d] = %b", i + 1, sum[i]);
end
for (i = 0; i < 50; i = i + 1) begin
  $display("carry[%0d] = %b", i + 1, carry[i]);
end
$display("Final: %b %b", final1, final2);

end
*/

  // Stage 1
  half_adder HA1_3 (pp[2][0], pp[1][1], sum[0], carry[0]);  //bit 3
  full_adder FA1_4 (pp[3][0], pp[2][1], pp[1][2], sum[1], carry[1]);  //bit 4
  full_adder FA1_5 (pp[4][0], pp[3][1], pp[2][2], sum[2], carry[2]);  //bit 5
  half_adder HA1_5 (pp[1][3], pp[0][4], sum[3], carry[3]);
  full_adder FA1_6_1 (pp[5][0], pp[4][1], pp[3][2], sum[4], carry[4]);  //bit 6
  full_adder FA1_6_2 (pp[2][3], pp[1][4], pp[0][5], sum[5], carry[5]);
  full_adder FA1_7_1 (pp[6][0], pp[5][1], pp[4][2], sum[6], carry[6]);  //bit 7
  full_adder FA1_7_2 (pp[3][3], pp[2][4], pp[1][5], sum[7], carry[7]);
  full_adder FA1_8_1 (pp[7][0], pp[6][1], pp[5][2], sum[8], carry[8]);  //bit 8
  full_adder FA1_8_2 (pp[4][3], pp[3][4], pp[2][5], sum[9], carry[9]);
  full_adder FA1_9_1 (pp[8][0], pp[7][1], pp[6][2], sum[10], carry[10]);  //bit 9
  full_adder FA1_9_2 (pp[5][3], pp[4][4], pp[3][5], sum[11], carry[11]);
  full_adder FA1_10_1 (pp[8][1], pp[7][2], pp[6][3], sum[12], carry[12]);  //bit 10
  full_adder FA1_10_2 (pp[5][4], pp[4][5], pp[3][6], sum[13], carry[13]);
  full_adder FA1_11 (pp[8][2], pp[7][3], pp[6][4], sum[14], carry[14]);  //bit 11
  half_adder HA1_11 (pp[5][5], pp[4][6], sum[15], carry[15]);
  full_adder FA1_12 (pp[8][3], pp[7][4], pp[6][5], sum[16], carry[16]);  //bit 12
  full_adder FA1_13 (pp[8][4], pp[7][5], pp[6][6], sum[17], carry[17]);  //bit 13 

  // Stage 2
  half_adder HA2_4 (sum[1], pp[0][3], sum[18], carry[18]);  //bit 4
  full_adder FA2_5 (sum[2], sum[3], carry[1], sum[19], carry[19]);  //bit 5
  full_adder FA2_6 (sum[4], sum[5], carry[2], sum[20], carry[20]);  //bit 6
  full_adder FA2_7 (sum[6], sum[7], pp[0][6], sum[21], carry[21]);  //bit 7
  half_adder HA2_7 (carry[4], carry[5], sum[22], carry[22]);
  full_adder FA2_8 (sum[8], sum[9], pp[1][6], sum[23], carry[23]);  //bit 8
  half_adder HA2_8 (carry[6], carry[7], sum[24], carry[24]);
  full_adder FA2_9 (sum[10], sum[11], pp[2][6], sum[25], carry[25]);  //bit 9
  half_adder HA2_9 (carry[8], carry[9], sum[26], carry[26]);
  full_adder FA2_10 (sum[12], sum[13], carry[10], sum[27], carry[27]);  //bit 10
  full_adder FA2_11 (sum[14], sum[15], carry[12], sum[28], carry[28]);  //bit 11
  full_adder FA2_12 (sum[16], pp[5][6], carry[14], sum[29], carry[29]);  //bit 12
  half_adder HA2_13 (sum[17], carry[16], sum[30], carry[30]);  // bit 13
  full_adder FA2_14 (pp[8][5], pp[7][6], carry[17], sum[31], carry[31]);  //bit 14
  
  // Stage 3
  half_adder HA3_6 (carry[19], sum[20], sum[32], carry[32]);  //bit 6
  full_adder FA3_7 (carry[20], sum[21], sum[22], sum[33], carry[33]);  // bit 7
  full_adder FA3_8 (carry[21], carry[22], sum[23], sum[34], carry[34]);  // bit 8
  full_adder FA3_9 (carry[23], carry[24], sum[25], sum[35], carry[35]);  // bit 9
  full_adder FA3_10 (carry[25], carry[26], sum[27], sum[36], carry[36]);  // bit 10
  full_adder FA3_11 (carry[27], sum[28], carry[13], sum[37], carry[37]);  // bit 11
  full_adder FA3_12 (carry[28], sum[29], carry[15], sum[38], carry[38]);  // bit 12
  half_adder HA3_13 (carry[29], sum[30], sum[39], carry[39]);  // bit 13
  half_adder HA3_14 (carry[30], sum[31], sum[40], carry[40]);  // bit 14
  half_adder HA3_15 (carry[31], pp[8][6], sum[41], carry[41]);  // bit 15

  // Stage 4
  half_adder HA4_8 (carry[33], sum[34], sum[42], carry[42]);  // bit 8
  full_adder FA4_9 (carry[34], sum[35], sum[26], sum[43], carry[43]);  // bit 9
  full_adder FA4_10 (carry[35], sum[36], carry[11], sum[44], carry[44]);  // bit 10
  half_adder HA4_11 (carry[36], sum[37], sum[45], carry[45]);  // bit 11
  half_adder HA4_12 (carry[37], sum[38], sum[46], carry[46]);  // bit 12
  half_adder HA4_13 (carry[38], sum[39], sum[47], carry[47]);  // bit 13
  half_adder HA4_14 (carry[39], sum[40], sum[48], carry[48]);  // bit 14
  half_adder HA4_15 (carry[40], sum[41], sum[49], carry[49]);  // bit 15

  // Assign Value to final1, final2
  assign final1[0] = pp[0][0];
  assign final1[1] = pp[1][0];
  assign final1[2] = sum[0];
  assign final1[3] = sum[18];
  assign final1[4] = carry[18];
  assign final1[5] = sum[32];
  assign final1[6] = carry[32];
  assign final1[7] = sum[42];
  assign final1[8] = carry[42];
  assign final1[9] = carry[43];
  assign final1[10] = carry[44];
  assign final1[11] = carry[45];
  assign final1[12] = carry[46];
  assign final1[13] = carry[47];
  assign final1[14] = carry[48];
  assign final1[15] = carry[49];

  assign final2[0] = 1'b0;
  assign final2[1] = pp[0][1];
  assign final2[2] = pp[0][2];
  assign final2[3] = carry[0];
  assign final2[4] = sum[19];
  assign final2[5] = carry[3];
  assign final2[6] = sum[33];
  assign final2[7] = sum[24];
  assign final2[8] = sum[43];
  assign final2[9] = sum[44];
  assign final2[10] = sum[45];
  assign final2[11] = sum[46];
  assign final2[12] = sum[47];
  assign final2[13] = sum[48];
  assign final2[14] = sum[49];
  assign final2[15] = carry[41];

  BKT_16 cla_inst (
    .s_o(s_o),
    .c_o(c_o),
    .a_i(final1),
    .b_i(final2)
  );

  assign out = s_o;

endmodule