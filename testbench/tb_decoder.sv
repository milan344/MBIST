

module tb_decoder;

 
  logic [2:0] q;
  logic [7:0] data_t;

  
  decoder uut (
    .q(q),
    .data_t(data_t)
  );


  initial begin
 

    // Test 1: q = 3'b000 → 8'b10101010 (0xAA)
    q = 3'b000; #1;
    $display("Test 1: q=%b → data_t=0x%0h %s",
             q, data_t,
             (data_t === 8'hAA) ? "PASS" : "FAIL");

    // Test 2: q = 3'b001 → 8'b01010101 (0x55)
    q = 3'b001; #1;
    $display("Test 2: q=%b → data_t=0x%0h %s",
             q, data_t,
             (data_t === 8'h55) ? "PASS" : "FAIL");

    // Test 3: q = 3'b010 → 8'b11110000 (0xF0)
    q = 3'b010; #1;
    $display("Test 3: q=%b → data_t=0x%0h %s",
             q, data_t,
             (data_t === 8'hF0) ? "PASS" : "FAIL");

    // Test 4: q = 3'b011 → 8'b00001111 (0x0F)
    q = 3'b011; #1;
    $display("Test 4: q=%b → data_t=0x%0h %s",
             q, data_t,
             (data_t === 8'h0F) ? "PASS" : "FAIL");

    // Test 5: q = 3'b100 → 8'b00000000 (0x00)
    q = 3'b100; #1;
    $display("Test 5: q=%b → data_t=0x%0h %s",
             q, data_t,
             (data_t === 8'h00) ? "PASS" : "FAIL");

    // Test 6: q = 3'b101 → 8'b11111111 (0xFF)
    q = 3'b101; #1;
    $display("Test 6: q=%b → data_t=0x%0h %s",
             q, data_t,
             (data_t === 8'hFF) ? "PASS" : "FAIL");

    // Test 7: q = 3'b110 → invalid → data_t = X
    q = 3'b110; #1;
    $display("Test 7: q=%b → data_t=%b %s",
             q, data_t,
             (data_t === {8{1'bx}}) ? "PASS" : "FAIL");

    // Test 8: q = 3'b111 → invalid → data_t = X
    q = 3'b111; #1;
    $display("Test 8: q=%b → data_t=%b %s",
             q, data_t,
             (data_t === {8{1'bx}}) ? "PASS" : "FAIL");


    $finish;
  end

endmodule
