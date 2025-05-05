

module bist #(
  parameter int size   = 6,  
  parameter int length = 8   
) (
  // Control & clock
  input  logic             start,    
  input  logic             rst,      
  input  logic             clk,      

  // Normal-mode interface
  input  logic             csin,    
  input  logic             rwbarin,  
  input  logic             opr,      
  input  logic [size-1:0]  address,  
  input  logic [length-1:0] datain,  

  // Outputs (normal & BIST)
  output logic [length-1:0] dataout, 
  output logic             fail      
);


  logic [9:0]               q;          // counter output
  logic                     cout;       // counter carry-out
  logic [length-1:0]        data_t;     // decoder → test pattern
  logic [size-1:0]          address_sel;// MUX_A → to SRAM.ramaddr
  logic [length-1:0]        din_sel;    // MUX_D → to SRAM.ramin
  logic                     NbarT, ld;  // controller outputs
  logic                     rwbar;      // actual SRAM R/W
  logic                     cs;         // actual SRAM CS
  logic [length-1:0]        ramout;     // SRAM output
  logic                     eq, gt, lt; // comparator flags

 
  controller u_ctrl (
    .clk   (clk),
    .rst   (rst),
    .start (start),
    .cout  (cout),
    .NbarT (NbarT),
    .ld    (ld)
  );


  counter #(.length(10)) u_ctr (
    .d_in  (10'b0),  // load zero in reset
    .clk   (clk),
    .ld    (ld),
    .u_d   (1'b1),   // always count up
    .cen   (1'b1),   // always enabled
    .q     (q),
    .cout  (cout)
  );


  decoder u_dec (
    .q      (q[9:7]),
    .data_t (data_t)
  );


  multiplexer #(.WIDTH(size)) u_muxA (
    .normal_in(address),
    .bist_in  (q[size-1:0]),
    .NbarT    (NbarT),
    .out      (address_sel)
  );


  multiplexer #(.WIDTH(length)) u_muxD (
    .normal_in(datain),
    .bist_in  (data_t),
    .NbarT    (NbarT),
    .out      (din_sel)
  );


  sram u_sram (
    .ramaddr(address_sel),
    .ramin  (din_sel),
    .rwbar  (rwbar),
    .clk    (clk),
    .cs     (cs),
    .ramout (ramout)
  );

  comparator u_cmp (
    .data_t(data_t),
    .ramout(ramout),
    .gt    (gt),
    .eq    (eq),
    .lt    (lt)
  );


 
  assign rwbar = NbarT ? q[6]      : rwbarin;
  
  assign cs    = NbarT ? 1'b1      : csin;
  
  assign dataout = ramout;


  always_ff @(posedge clk) begin
    if (rst) begin
      fail <= 1'b0;
    end else begin
      logic read_cycle = (NbarT && rwbarin) || (NbarT && q[6]);
      if (opr && read_cycle && ~eq) begin
        fail <= 1'b1;
      end

    end
  end

endmodule
