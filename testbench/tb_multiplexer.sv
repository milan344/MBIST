

module tb_multiplexer;

  // Testbench parameter — you can override to 6 for address-width tests
  parameter int WIDTH = 8;

  // DUT inputs/outputs
  logic [WIDTH-1:0] normal_in;
  logic [WIDTH-1:0] bist_in;
  logic             NbarT;
  logic [WIDTH-1:0] out;




  // Instantiate the parameterized mux
  multiplexer #(.WIDTH(WIDTH)) uut (
    .normal_in(normal_in),
    .bist_in  (bist_in),
    .NbarT    (NbarT),
    .out      (out)
  );

  initial begin
    $display("\n=== Mux_BIST Testbench ===\n");
    #10;  // allow any initialization

    // Test 1: NbarT = 0 → should pass through normal_in
    normal_in = {WIDTH{1'b1}}; // all 1’s
    bist_in   = {WIDTH{1'b0}}; // all 0’s
    NbarT     = 0;
    #1;
    $display("Test 1: NbarT=0 → out = 0x%0h %s",
             out, (out === normal_in) ? "PASS" : "FAIL");

    // Test 2: NbarT = 1 → should pass through bist_in
    NbarT = 1;
    #1;
    $display("Test 2: NbarT=1 → out = 0x%0h %s",
             out, (out === bist_in) ? "PASS" : "FAIL");

    // Test 3: another pattern, NbarT=0
    normal_in = 'hA5;
    bist_in   = 'h5A;
    NbarT     = 0;
    #1;
    $display("Test 3: NbarT=0 → out = 0x%0h %s",
             out, (out === normal_in) ? "PASS" : "FAIL");

    // Test 4: same pattern, NbarT=1
    NbarT = 1;
    #1;
    $display("Test 4: NbarT=1 → out = 0x%0h %s",
             out, (out === bist_in) ? "PASS" : "FAIL");

    // Test 5: zero vs max
    normal_in = '0;
    bist_in   = {WIDTH{1'b1}};
    NbarT     = 0;
    #1;
    $display("Test 5: NbarT=0 → out = 0x%0h %s",
             out, (out === normal_in) ? "PASS" : "FAIL");

    // Test 6: zero vs max, select BIST
    NbarT = 1;
    #1;
    $display("Test 6: NbarT=1 → out = 0x%0h %s",
             out, (out === bist_in) ? "PASS" : "FAIL");

    $display("\n=== All Mux_BIST tests completed ===\n");
    $finish;
  end

endmodule
