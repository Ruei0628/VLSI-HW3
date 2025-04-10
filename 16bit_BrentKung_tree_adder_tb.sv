`timescale 1ns/1ns
module BKT_16_tb;

  logic [15:0] a_i, b_i;
  logic [15:0] s_o;
  logic        c_o;

  logic [16:0] expect_full;
  logic [15:0] expect_s;
  logic        expect_c;

  BKT_16 dut (
    .a_i(a_i),
    .b_i(b_i),
    .s_o(s_o),
    .c_o(c_o)
  );

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, BKT_16_tb);

    // Case 0: all 1s + carry-in = 1
    a_i = 16'hFFFF;
    b_i = 16'hFFFF;
    expect_s = 16'hFFFE;
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
      $display("a_i = %b", a_i);
      $display("b_i = %b", b_i);
      $display("Expect[c_o, s_o]: %b, %b", expect_c, expect_s);
      $display("Got   [c_o, s_o]: %b, %b", c_o, s_o);
      $display("-------------------------------------------------------");
      $finish;  // Command this line if you want to show all error info.
    end 
    else 
      $display("Pattern 0 pass!");

    // Random patterns
    for (int i = 1; i <= 999; i++) 
    begin
      a_i = $random;
      b_i = $random;

      expect_full = a_i + b_i;
      expect_c = expect_full[16];
      expect_s = expect_full[15:0];

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
        $display("a_i = %b", a_i);
        $display("b_i = %b", b_i);
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
