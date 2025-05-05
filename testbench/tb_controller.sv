

module tb_controller;


  logic clk;
  logic rst;
  logic start;
  logic cout;
  logic NbarT;
  logic ld;

 
  controller uut (
    .clk   (clk),
    .rst   (rst),
    .start (start),
    .cout  (cout),
    .NbarT (NbarT),
    .ld    (ld)
  );



  // 10 ns clock
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin


    // Test 1: Assert reset → should be in RESET state
    rst   = 1;
    start = 0;
    cout  = 0;
    @(posedge clk); #1;
    $display("Test 1: rst=1      => ld=%b NbarT=%b %s",
             ld, NbarT, (ld==1 && NbarT==0) ? "PASS" : "FAIL");

    // Test 2: Deassert reset, no start → still RESET
    rst   = 0;
    start = 0;
    cout  = 0;
    @(posedge clk); #1;
    $display("Test 2: rst=0,s=0  => ld=%b NbarT=%b %s",
             ld, NbarT, (ld==1 && NbarT==0) ? "PASS" : "FAIL");

    // Test 3: Assert start → transition to TEST
    start = 1;
    cout  = 0;
    @(posedge clk); #1;
    $display("Test 3: start=1   => ld=%b NbarT=%b %s",
             ld, NbarT, (ld==0 && NbarT==1) ? "PASS" : "FAIL");

    // Test 4: Remain in TEST while cout=0
    start = 0;
    cout  = 0;
    @(posedge clk); #1;
    $display("Test 4: hold TEST => ld=%b NbarT=%b %s",
             ld, NbarT, (ld==0 && NbarT==1) ? "PASS" : "FAIL");

    // Test 5: Assert cout → transition back to RESET
    cout = 1;
    @(posedge clk); #1;
    $display("Test 5: cout=1    => ld=%b NbarT=%b %s",
             ld, NbarT, (ld==1 && NbarT==0) ? "PASS" : "FAIL");

    // Test 6: Can start again after completion
    start = 1;
    cout  = 0;
    @(posedge clk); #1;
    $display("Test 6: restart   => ld=%b NbarT=%b %s",
             ld, NbarT, (ld==0 && NbarT==1) ? "PASS" : "FAIL");

 
    $finish;
  end

endmodule
