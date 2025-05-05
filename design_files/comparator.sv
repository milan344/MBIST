module comparator (
    input  logic [7:0] data_t,   
    input  logic [7:0] ramout,   
    output logic       gt,       
    output logic       eq,       
    output logic       lt        
);

    assign gt = (data_t > ramout);
    assign eq = (data_t == ramout);
    assign lt = (data_t < ramout);

endmodule
