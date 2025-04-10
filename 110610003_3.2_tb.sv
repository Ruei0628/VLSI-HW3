`timescale 1ns/1ns
module CSA_14_tb;

  logic [13:0] a_i, b_i;
  logic       c_i;
  logic [13:0] s_o;
  logic       c_o;

  logic [14:0] expect_full;
  logic [13:0] expect_s;
  logic        expect_c;

  CSA_14 dut (
    .a_i(a_i),
    .b_i(b_i),
    .c_i(c_i),
    .s_o(s_o),
    .c_o(c_o)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, CSA_14_tb);

    // Case 0: all 1s + carry-in = 1
    a_i = 14'b11111111111111;
    b_i = 14'b11111111111111;
    c_i = 1'b1;
    expect_s = 14'b11111111111111;
    expect_c = 1'b1;
    #50;
    if (s_o !== expect_s || c_o !== expect_c) 
    begin
      $display("                                                      ");
      $display("                                                      ");
      $display("  i:..::::::i.      :::::         ::::    .:::.");
      $display("  BBBBBBBBBBBi     iBBBBBL       .BBBB    7BBB7");
      $display("  BBBB.::::ir.     BBB:BBB.      .BBBv    iBBB:");
      $display("  BBBQ            :BBY iBB7       BBB7    :BBB:");
      $display("  BBBB            BBB. .BBB.      BBB7    :BBB:");
      $display("  BBBB:r7vvj:    :BBB   gBBs      BBB7    :BBB:");
      $display("  BBBBBBBBBB7    BBB:   .BBB.     BBB7    :BBB:");
      $display("  BBBB    ..    iBBBBBBBBBBBP     BBB7    :BBB:");
      $display("  BBBB          BBBBi7vviQBBB.    BBB7    :BBB.");
      $display("  BBBB         rBBB.      BBBQ   .BBBv    iBBB2ir777L7");
      $display("  BBBB        :BBBB       BBBB7  .BBBB    7BBBBBBBBBBB");
      $display("  . ..        ....         ...:   ....    ..   .......");
      $display("                                                      ");
      $display("                                                      ");
      $display("-------------------------------------------------------");
      $display("Pattern 0 fail !");
      $display("a_i = %b ", a_i);
      $display("b_i = %b ", b_i);
      $display("c_i = %b ", c_i);
      $display("Expect[c_o, s_o]: %b, %b", expect_c, expect_s);
      $display("Got   [c_o, s_o]: %b, %b", c_o, s_o);
      $display("-------------------------------------------------------");
      $finish;  // Command this line if you want to show all error info.
    end 
    else 
      $display("Pattern 0 pass!");

    // Random cases
    for (int i = 1; i <= 999; i++) 
    begin
      a_i = $random;
      b_i = $random;
      c_i = $random % 2;

      expect_full = a_i + b_i + c_i;
      expect_s = expect_full[13:0];
      expect_c = expect_full[14];

      #50;

      if (s_o !== expect_s || c_o !== expect_c) 
      begin
        $display("                                                      ");
        $display("                                                      ");
        $display("  i:..::::::i.      :::::         ::::    .:::.");
        $display("  BBBBBBBBBBBi     iBBBBBL       .BBBB    7BBB7");
        $display("  BBBB.::::ir.     BBB:BBB.      .BBBv    iBBB:");
        $display("  BBBQ            :BBY iBB7       BBB7    :BBB:");
        $display("  BBBB            BBB. .BBB.      BBB7    :BBB:");
        $display("  BBBB:r7vvj:    :BBB   gBBs      BBB7    :BBB:");
        $display("  BBBBBBBBBB7    BBB:   .BBB.     BBB7    :BBB:");
        $display("  BBBB    ..    iBBBBBBBBBBBP     BBB7    :BBB:");
        $display("  BBBB          BBBBi7vviQBBB.    BBB7    :BBB.");
        $display("  BBBB         rBBB.      BBBQ   .BBBv    iBBB2ir777L7");
        $display("  BBBB        :BBBB       BBBB7  .BBBB    7BBBBBBBBBBB");
        $display("  . ..        ....         ...:   ....    ..   .......");
        $display("                                                      ");
        $display("                                                      ");
        $display("-------------------------------------------------------");
        $display("Pattern %0d fail !", i);
        $display("a_i = %b ", a_i);
        $display("b_i = %b ", b_i);
        $display("c_i = %b ", c_i);
        $display("Expect[c_o, s_o]: %b, %b", expect_c, expect_s);
        $display("Got   [c_o, s_o]: %b, %b", c_o, s_o);
        $display("-------------------------------------------------------");
        $finish;  // Command this line if you want to show all error info.
      end 
      else 
        $display("Pattern %0d pass!", i);
    end

    $display("______  ___   _____ _____ _ ");
    $display("| ___ \\/ _ \\ /  ___/  ___| |");
    $display("| |_/ / /_\\ \\\\ `--.\\ `--.| |");
    $display("|  __/|  _  | `--. \\`--. \\ |");
    $display("| |   | | | |/\\__/ /\\__/ /_|");
    $display("\\_|   \\_| |_/\\____/\\____/(_)");
    $finish;
  end
endmodule


