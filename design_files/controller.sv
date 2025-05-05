module controller (
    input  logic clk,
    input  logic rst,
    input  logic start,
    input  logic cout,
    output logic NbarT,
    output logic ld
);

  // State encoding
  typedef enum logic { 
    S_RESET, 
    S_TEST 
  } state_t;

  state_t state, next_state;

  // Next‐state & output logic all in one comb block
  always_comb begin
    // default assignments
    next_state = state;
    NbarT      = 1'b0;
    ld         = 1'b0;

    case (state)
      S_RESET: begin
        ld = 1'b1;                 // load in RESET phase
        if (start)
          next_state = S_TEST;
      end

      S_TEST: begin
        NbarT = 1'b1;              // BIST enabled in TEST phase
        if (cout)
          next_state = S_RESET;
      end
    endcase
  end

  // State register
  always_ff @(posedge clk) begin
    if (rst)
      state <= S_RESET;
    else
      state <= next_state;
  end

endmodule
