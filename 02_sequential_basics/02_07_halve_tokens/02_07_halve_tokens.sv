//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module halve_tokens
(
    input  clk,
    input  rst,
    input  a,
    output b
);
    // Task:
    // Implement a serial module that reduces amount of incoming '1' tokens by half.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 110_011_101_000_1111
    // b -> 010_001_001_000_0101

    reg [1:0] count;
    reg b_temp;

    always_ff @ (posedge clk) begin
        if (rst) begin
            b_temp = 0;
            count = 0;
        end else begin
            b_temp <= 0;
            if (a) begin
                count++;
            end
            if (count == 2) begin
                b_temp <= 1;
                count <= 0;
            end else begin
                b_temp <= 0;
            end
        end
    end

    assign b = b_temp;

endmodule
