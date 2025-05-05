

module tb_sram;
  
  logic [5:0] ramaddr;
  logic [7:0] ramin;
  logic       rwbar;
  logic       cs;
  logic       clk;
  logic [7:0] ramout;

  
  sram uut (
    .ramaddr (ramaddr),
    .ramin   (ramin),
    .rwbar   (rwbar),
    .clk     (clk),
    .cs      (cs),
    .ramout  (ramout)
  );

 
  initial clk = 0;
  always #5 clk = ~clk;

 

  initial begin
    #10;  

    // Write 0xA5 at address 10
    ramaddr = 6'd10; ramin = 8'hA5; rwbar = 1'b0; cs = 1'b1;
    @(posedge clk);   // perform write on rising edge
    #1;
    // switch to read mode, change ramaddr to prove addr_reg usage
    rwbar   = 1'b1;
    ramaddr = 6'd5;
    #1;
    $display("write/Read @10 => ramout = 0x%0h %s", ramout, (ramout === 8'hA5) ? "PASS" : "FAIL");

    // During a write cycle - ramout must be 0
    ramaddr = 6'd20; ramin = 8'h3C; rwbar = 1'b0; cs = 1'b1;
    @(posedge clk);   // write to addr 20
    #1;
    $display(" write phase      => ramout = 0x%0h %s", ramout, (ramout === 8'h00) ? "PASS" : "FAIL");

    // Read back the value written at addr 20
    rwbar = 1'b1; // read mode
    #1;
    $display(" read back at add 20    => ramout = 0x%0h %s", ramout, (ramout === 8'h3C) ? "PASS" : "FAIL");

    // With cs=0 (chip deselected), ramout = 0
    rwbar   = 1'b1;
    cs      = 1'b0;
    ramaddr = 6'd20;
    #1;
    $display("cs=0 (no select) => ramout = 0x%0h %s", ramout, (ramout === 8'h00) ? "PASS" : "FAIL");

 
    $finish;
  end

endmodule
