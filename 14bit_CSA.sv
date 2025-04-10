// Naming convention:
// cXY_Z = carry-out of Stage X, bit Y, when carry-in is Z (0 or 1)
// sXY_Z = sum bit of Stage X, bit Y, when carry-in is Z (0 or 1)

// assign sXY_Z = a ^ b ^ cin;    // XOR determines sum parity (even=0, odd=1)
// assign cXY_Z = (a & b) | (a & cin) | (b & cin);  // majority function to determine carry-out

module CSA_14 (
    output logic [13:0] s_o,
    output logic c_o,
    input  logic [13:0] a_i,
    input  logic [13:0] b_i,
    input  logic c_i
);

    // ---------- Stage 1: 2-bit ripple carry adder ----------
    logic [2:0] temp1; // {carry, sum[1:0]}

    // bit 0
    logic s11, c11;
    assign s11 = a_i[0] ^ b_i[0] ^ c_i;  
    assign c11 = (a_i[0] & b_i[0]) | (a_i[0] & c_i) | (b_i[0] & c_i);

    // bit 1
    logic s12, c12;
    assign s12 = a_i[1] ^ b_i[1] ^ c11;
    assign c12 = (a_i[1] & b_i[1]) | (a_i[1] & c11) | (b_i[1] & c11);

    assign temp1 = {c12, s12, s11};
    assign s_o[1:0] = temp1[1:0];

    // ---------- Stage 2: 3-bit carry select ----------
    logic [3:0] temp2_0, temp2_1;

    // Carry = 0
    logic s21_0, s22_0, s23_0;
    logic c21_0, c22_0, c23_0;

    assign s21_0 = a_i[2] ^ b_i[2];
    assign c21_0 = a_i[2] & b_i[2];

    assign s22_0 = a_i[3] ^ b_i[3] ^ c21_0;
    assign c22_0 = (a_i[3] & b_i[3]) | (a_i[3] & c21_0) | (b_i[3] & c21_0);

    assign s23_0 = a_i[4] ^ b_i[4] ^ c22_0;
    assign c23_0 = (a_i[4] & b_i[4]) | (a_i[4] & c22_0) | (b_i[4] & c22_0);

    assign temp2_0 = {c23_0, s23_0, s22_0, s21_0};

    // Carry = 1
    logic s21_1, s22_1, s23_1;
    logic c21_1, c22_1, c23_1;

    assign s21_1 = a_i[2] ^ b_i[2] ^ 1'b1;
    assign c21_1 = (a_i[2] & b_i[2]) | (a_i[2] & 1'b1) | (b_i[2] & 1'b1);

    assign s22_1 = a_i[3] ^ b_i[3] ^ c21_1;
    assign c22_1 = (a_i[3] & b_i[3]) | (a_i[3] & c21_1) | (b_i[3] & c21_1);

    assign s23_1 = a_i[4] ^ b_i[4] ^ c22_1;
    assign c23_1 = (a_i[4] & b_i[4]) | (a_i[4] & c22_1) | (b_i[4] & c22_1);

    assign temp2_1 = {c23_1, s23_1, s22_1, s21_1};

    // MUX
    assign s_o[4:2] = (temp1[2]) ? temp2_1[2:0] : temp2_0[2:0];
    assign c2_mux   = (temp1[2]) ? temp2_1[3]   : temp2_0[3];

    // ---------- Stage 3: 4-bit carry select ----------
    logic [4:0] temp3_0, temp3_1;

    // Carry = 0
    logic s31_0, s32_0, s33_0, s34_0;
    logic c31_0, c32_0, c33_0, c34_0;

    assign s31_0 = a_i[5] ^ b_i[5];
    assign c31_0 = a_i[5] & b_i[5];

    assign s32_0 = a_i[6] ^ b_i[6] ^ c31_0;
    assign c32_0 = (a_i[6] & b_i[6]) | (a_i[6] & c31_0) | (b_i[6] & c31_0);

    assign s33_0 = a_i[7] ^ b_i[7] ^ c32_0;
    assign c33_0 = (a_i[7] & b_i[7]) | (a_i[7] & c32_0) | (b_i[7] & c32_0);

    assign s34_0 = a_i[8] ^ b_i[8] ^ c33_0;
    assign c34_0 = (a_i[8] & b_i[8]) | (a_i[8] & c33_0) | (b_i[8] & c33_0);

    assign temp3_0 = {c34_0, s34_0, s33_0, s32_0, s31_0};

    // Carry = 1
    logic s31_1, s32_1, s33_1, s34_1;
    logic c31_1, c32_1, c33_1, c34_1;

    assign s31_1 = a_i[5] ^ b_i[5] ^ 1'b1;
    assign c31_1 = (a_i[5] & b_i[5]) | (a_i[5] & 1'b1) | (b_i[5] & 1'b1);

    assign s32_1 = a_i[6] ^ b_i[6] ^ c31_1;
    assign c32_1 = (a_i[6] & b_i[6]) | (a_i[6] & c31_1) | (b_i[6] & c31_1);

    assign s33_1 = a_i[7] ^ b_i[7] ^ c32_1;
    assign c33_1 = (a_i[7] & b_i[7]) | (a_i[7] & c32_1) | (b_i[7] & c32_1);

    assign s34_1 = a_i[8] ^ b_i[8] ^ c33_1;
    assign c34_1 = (a_i[8] & b_i[8]) | (a_i[8] & c33_1) | (b_i[8] & c33_1);

    assign temp3_1 = {c34_1, s34_1, s33_1, s32_1, s31_1};

    // MUX
    assign s_o[8:5] = c2_mux ? temp3_1[3:0] : temp3_0[3:0];
    assign c3_mux   = c2_mux ? temp3_1[4]   : temp3_0[4];

    // ---------- Stage 4: 5-bit carry select ----------
    logic [5:0] temp4_0, temp4_1;

    // Carry = 0
    logic s41_0, s42_0, s43_0, s44_0, s45_0;
    logic c41_0, c42_0, c43_0, c44_0, c45_0;

    assign s41_0 = a_i[9] ^ b_i[9];
    assign c41_0 = a_i[9] & b_i[9];

    assign s42_0 = a_i[10] ^ b_i[10] ^ c41_0;
    assign c42_0 = (a_i[10] & b_i[10]) | (a_i[10] & c41_0) | (b_i[10] & c41_0);

    assign s43_0 = a_i[11] ^ b_i[11] ^ c42_0;
    assign c43_0 = (a_i[11] & b_i[11]) | (a_i[11] & c42_0) | (b_i[11] & c42_0);

    assign s44_0 = a_i[12] ^ b_i[12] ^ c43_0;
    assign c44_0 = (a_i[12] & b_i[12]) | (a_i[12] & c43_0) | (b_i[12] & c43_0);

    assign s45_0 = a_i[13] ^ b_i[13] ^ c44_0;
    assign c45_0 = (a_i[13] & b_i[13]) | (a_i[13] & c44_0) | (b_i[13] & c44_0);

    assign temp4_0 = {c45_0, s45_0, s44_0, s43_0, s42_0, s41_0};

    // Carry = 1
    logic s41_1, s42_1, s43_1, s44_1, s45_1;
    logic c41_1, c42_1, c43_1, c44_1, c45_1;

    assign s41_1 = a_i[9] ^ b_i[9] ^ 1'b1;
    assign c41_1 = (a_i[9] & b_i[9]) | (a_i[9] & 1'b1) | (b_i[9] & 1'b1);

    assign s42_1 = a_i[10] ^ b_i[10] ^ c41_1;
    assign c42_1 = (a_i[10] & b_i[10]) | (a_i[10] & c41_1) | (b_i[10] & c41_1);

    assign s43_1 = a_i[11] ^ b_i[11] ^ c42_1;
    assign c43_1 = (a_i[11] & b_i[11]) | (a_i[11] & c42_1) | (b_i[11] & c42_1);

    assign s44_1 = a_i[12] ^ b_i[12] ^ c43_1;
    assign c44_1 = (a_i[12] & b_i[12]) | (a_i[12] & c43_1) | (b_i[12] & c43_1);

    assign s45_1 = a_i[13] ^ b_i[13] ^ c44_1;
    assign c45_1 = (a_i[13] & b_i[13]) | (a_i[13] & c44_1) | (b_i[13] & c44_1);

    assign temp4_1 = {c45_1, s45_1, s44_1, s43_1, s42_1, s41_1};

    // MUX
    assign s_o[13:9] = c3_mux ? temp4_1[4:0] : temp4_0[4:0];
    assign c_o = c3_mux ? temp4_1[5] : temp4_0[5];

endmodule
