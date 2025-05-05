module sram (
    input  logic [5:0]  ramaddr,  
    input  logic [7:0]  ramin,    
    input  logic        rwbar,    
    input  logic        clk,      
    input  logic        cs,       
    output logic [7:0]  ramout    
);
    // 64 × 8-bit memory array
    logic [7:0] ram [63:0];


    logic [5:0] addr_reg;

    always_ff @(posedge clk) begin
        addr_reg <= ramaddr;
        if (cs) begin

            if (!rwbar) begin
                ram[ramaddr] <= ramin;
            end
        end
    end

    assign ramout = (cs && rwbar) ? ram[addr_reg] : 8'd0;
endmodule
