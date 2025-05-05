

module tb_bist;


  localparam int SIZE   = 6;   // SRAM address width
  localparam int LENGTH = 8;   // SRAM data width


  logic                 clk;
  logic                 rst;
  logic                 start;
  logic                 csin;
  logic                 rwbarin;
  logic                 opr;
  logic [SIZE-1:0]      address;
  logic [LENGTH-1:0]    datain;
  logic [LENGTH-1:0]    dataout;
  logic                 fail;


  bist #(
    .size   (SIZE),
    .length (LENGTH)
  ) uut (
    .clk      (clk),
    .rst      (rst),
    .start    (start),
    .csin     (csin),
    .rwbarin  (rwbarin),
    .opr      (opr),
    .address  (address),
    .datain   (datain),
    .dataout  (dataout),
    .fail     (fail)
  );


  initial clk = 0;
  always #5 clk = ~clk;


  integer i;
  integer fail_cycle;
  integer first_fail_cycle;
  initial begin
    // 1) Reset and initialize
    rst      = 1;
    start    = 0;
    csin     = 0;
    rwbarin  = 1;      // read by default
    opr      = 0;      
    address  = '0;
    datain   = '0;
    #10;
    @(posedge clk);
      rst = 0;
    @(posedge clk);

    $display("\n=== BIST_TOP Testbench ===\n");

    // 2) Normal‐mode write/read
    csin    = 1;
    rwbarin = 0;       // write
    address = 6'd10;
    datain  = 8'h3C;
    @(posedge clk);    // perform write
    @(posedge clk);    // propagate
    rwbarin = 1;       // read
    @(posedge clk);
    #1;
    $display("Normal W/R  => dataout=0x%0h %s",
             dataout, (dataout == 8'h3C) ? "PASS" : "FAIL");

    // 3) De‐select chip
    csin = 0;
    @(posedge clk); #1;
    $display("Test 2 (CS inactive): dataout=0x%0h => %s",
             dataout, (dataout == '0) ? "PASS" : "FAIL");

    // 4) BIST handshake w/ opr=0 (no error checking)
    rst   = 1; @(posedge clk); rst = 0; @(posedge clk); #1;
    $display("\n-- BIST run (opr=0), expect fail=0 --");
    opr   = 0;
    start = 1; @(posedge clk); #1; start = 0;
    repeat (50) begin @(posedge clk); #1; end
    $display(" Test 3: after  50 cycles, fail=%b => %s",
             fail, (fail == 1'b0) ? "PASS" : "FAIL");

    // 5) Full‐range BIST w/ opr=1: expect fail=1 on first mismatch
    $display("\n-- Full BIST run (opr=1), expect fail=1 --");
    // clear sticky flag via reset
    rst   = 1; @(posedge clk); rst = 0; @(posedge clk); #1;
    opr   = 1;
    start = 1; @(posedge clk); #1; start = 0;
    fail_cycle   = -1;
    for (i = 0; i < 1024; i++) begin
      @(posedge clk);
      if (fail && fail_cycle == -1) begin
        fail_cycle = i;
      end
    end
    if (fail)
      $display("First mismatch at cycle %0d: FAIL (bug detected)", first_fail_cycle);
    else
      $display("No mismatch in 1024 cycles: PASS");

    // 6) Check reset clears fail and FSM
    $display(" Reset clears fail ");
    rst = 1; @(posedge clk); rst = 0; @(posedge clk);
    $display(" After reset, fail = %0b  %s\n",
             fail, (fail == 0) ? "PASS" : "FAIL");

    // 7) Second BIST run to verify re-start
   $display("\n-- Second BIST run (opr=1) --");
   // clear sticky flag via reset, not by driving it
   rst        = 1; @(posedge clk); rst = 0; @(posedge clk); #1;
   opr        = 1;
   start      = 1; @(posedge clk); #1; start = 0;
   first_fail_cycle = -1;
   for (i = 0; i < 1024; i++) begin
     @(posedge clk); #1;
     if (fail && first_fail_cycle == -1)
       first_fail_cycle = i;
   end
    if (fail)
      $display("Second mismatch at cycle %0d: FAIL (bug detected)", first_fail_cycle);
    else
      $display("No mismatch on second run: PASS");

    $finish;
  end

endmodule
