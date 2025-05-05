module decoder (
    input  logic [2:0] q,      
    output logic [7:0] data_t  
);

    always_comb begin
        case (q)
            3'b000: data_t = 8'b1010_1010;  // 0xAA
            3'b001: data_t = 8'b0101_0101;  // 0x55
            3'b010: data_t = 8'b1111_0000;  // 0xF0
            3'b011: data_t = 8'b0000_1111;  // 0x0F
            3'b100: data_t = 8'b0000_0000;  // 0x00
            3'b101: data_t = 8'b1111_1111;  // 0xFF
            default: data_t = 'bx;          // invalid selector → unknown
        endcase
    end

endmodule
