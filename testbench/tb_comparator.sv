module tb_comparator;

    // DUT signals
    logic [7:0] data_t;
    logic [7:0] ramout;
    logic       gt, eq, lt;

    // Instantiate the comparator
    comparator uut (
        .data_t(data_t),
        .ramout(ramout),
        .gt(gt),
        .eq(eq),
        .lt(lt)
    );

    initial begin
        $display("Starting Comparator Testbench...\n");

        // Case 1: data_t > ramout
        data_t = 8'd20; ramout = 8'd10; #1;
        $display("Test 1: %0d > %0d => gt=%b eq=%b lt=%b %s", data_t, ramout, gt, eq, lt,
                 (gt && !eq && !lt) ? "PASS" : "FAIL");

        // Case 2: data_t < ramout
        data_t = 8'd5; ramout = 8'd25; #1;
        $display("Test 2: %0d < %0d => gt=%b eq=%b lt=%b %s", data_t, ramout, gt, eq, lt,
                 (!gt && !eq && lt) ? "PASS" : "FAIL");

        // Case 3: data_t == ramout
        data_t = 8'd100; ramout = 8'd100; #1;
        $display("Test 3: %0d == %0d => gt=%b eq=%b lt=%b %s", data_t, ramout, gt, eq, lt,
                 (!gt && eq && !lt) ? "PASS" : "FAIL");

        // Edge case: data_t = 0, ramout = 255
        data_t = 8'd0; ramout = 8'd255; #1;
        $display("Test 4: %0d < %0d => gt=%b eq=%b lt=%b %s", data_t, ramout, gt, eq, lt,
                 (!gt && !eq && lt) ? "PASS" : "FAIL");

        // Edge case: data_t = 255, ramout = 0
        data_t = 8'd255; ramout = 8'd0; #1;
        $display("Test 5: %0d > %0d => gt=%b eq=%b lt=%b %s", data_t, ramout, gt, eq, lt,
                 (gt && !eq && !lt) ? "PASS" : "FAIL");

        // All zero case
        data_t = 8'd0; ramout = 8'd0; #1;
        $display("Test 6: %0d == %0d => gt=%b eq=%b lt=%b %s", data_t, ramout, gt, eq, lt,
                 (!gt && eq && !lt) ? "PASS" : "FAIL");

        $display("\nAll test cases completed.");
        $finish;
    end

endmodule
