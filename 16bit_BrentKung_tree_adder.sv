module BKT_16 (
    output logic [15:0] s_o,
    output logic       c_o,
    input  logic [15:0] a_i,
    input  logic [15:0] b_i
);

    // Step 1: Generate and Propagate
    logic [15:0] G, P;
    logic [15:0] C;

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin
            assign G[i] = a_i[i] & b_i[i];
            assign P[i] = a_i[i] ^ b_i[i];
        end
    endgenerate

    // Step 2: Brent-Kung Tree Carry computation
    // Level 1: G1/P1 from pairs of G/P
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

    // Level 2
    logic [3:0] G2, P2;
    assign G2[0] = G1[1] | (P1[1] & G1[0]);
    assign G2[1] = G1[3] | (P1[3] & G1[2]);
    assign G2[2] = G1[5] | (P1[5] & G1[4]);
    assign G2[3] = G1[7] | (P1[7] & G1[6]);

    assign P2[0] = P1[1] & P1[0];
    assign P2[1] = P1[3] & P1[2];
    assign P2[2] = P1[5] & P1[4];
    assign P2[3] = P1[7] & P1[6];

    // Level 3
    logic [1:0] G3, P3;
    assign G3[0] = G2[1] | (P2[1] & G2[0]);
    assign G3[1] = G2[3] | (P2[3] & G2[2]);

    assign P3[0] = P2[1] & P2[0];
    assign P3[1] = P2[3] & P2[2];

    // Level 4
    logic G4, P4;
    assign G4 = G3[1] | (P3[1] & G3[0]);
    assign P4 = P3[1] & P3[0];

    // Step 3: Carry computation using the tree
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

    // Step 4: Sum computation
    genvar j;
    generate
        for (j = 0; j < 16; j++) begin
            assign s_o[j] = P[j] ^ C[j];
        end
    endgenerate

    assign c_o = G[15] | (P[15] & C[15]);

endmodule
