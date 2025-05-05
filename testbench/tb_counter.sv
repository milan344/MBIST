

module tb_counter;
  // Use the full 10-bit width
  parameter int length = 10;

  // DUT interface
  logic [length-1:0] d_in;
  logic              clk;
  logic              ld;
  logic              u_d;
  logic              cen;
  logic [length-1:0] q;
  logic              cout;

  // Instantiate the counter
  counter #(.length(length)) uut (
    .d_in(d_in),
    .clk(clk),
    .ld(ld),
    .u_d(u_d),
    .cen(cen),
    .q(q),
    .cout(cout)
  );

  // 10 ns clock
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    // --- Initialization ---
    d_in = '0;
    ld   = 0;
    u_d  = 0;
    cen  = 0;
    #10;  // let things settle

    $display("\n=== Counter Testbench (10-bit) ===\n");

    // Test 1: Load 5
    cen  = 1; 
    ld   = 1; 
    d_in = 10'd5;  
    u_d  = 0;
    @(posedge clk);  
    #1;  // wait for nonblocking update
    $display("Test 1: Load 5        => q = %0d %s", q, (q == 10'd5)   ? "PASS" : "FAIL");
    ld = 0;

    // Test 2: Count up → 6
    u_d = 1;
    @(posedge clk);
    #1;
    $display("Test 2: Count up      => q = %0d %s", q, (q == 10'd6)   ? "PASS" : "FAIL");

    // Test 3: Count down → 5
    u_d = 0;
    @(posedge clk);
    #1;
    $display("Test 3: Count down    => q = %0d %s", q, (q == 10'd5)   ? "PASS" : "FAIL");

    // Test 4: Underflow (0 → 1023)
    //  - first load 0
    cen  = 1;
    ld   = 1;
    d_in = 10'd0;
    u_d  = 0;
    @(posedge clk);
    #1;
    ld = 0;
    //  - then count down
    cen = 1; 
    u_d = 0;
    @(posedge clk);
    #1;
    $display("Test 4: Underflow      => q = %0d cout = %b %s",
             q, cout, (q == 10'd1023 && cout == 1) ? "PASS" : "FAIL");

    // Test 5: Overflow (1023 → 0)
    //  - first load 1023
    cen  = 1;
    ld   = 1;
    d_in = 10'd1023;
    u_d  = 1;
    @(posedge clk);
    #1;
    ld = 0;
    //  - then count up
    cen = 1;
    u_d = 1;
    @(posedge clk);
    #1;
    $display("Test 5: Overflow       => q = %0d cout = %b %s",
             q, cout, (q == 10'd0 && cout == 1) ? "PASS" : "FAIL");

    // Test 6: Disabled count (no change)
    //  - load 9
    cen  = 1;
    ld   = 1;
    d_in = 10'd9;
    u_d  = 0;
    @(posedge clk);
    #1;
    ld = 0;
    //  - now disable counting
    cen = 0;
    u_d = 1;
    @(posedge clk);
    #1;
    $display("Test 6: Disabled count => q = %0d %s",
             q, (q == 10'd9) ? "PASS" : "FAIL");

    $display("\n=== All tests complete ===\n");
    $finish;
  end
endmodule
