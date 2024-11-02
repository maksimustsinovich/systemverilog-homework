//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module double_tokens
(
    input        clk,
    input        rst,
    input        a,
    output       b,
    output logic overflow
);
    // Task:
    // Implement a serial module that doubles each incoming token '1' two times.
    // The module should handle doubling for at least 200 tokens '1' arriving in a row.
    //
    // In case module detects more than 200 sequential tokens '1', it should assert
    // an overflow error. The overflow error should be sticky. Once the error is on,
    // the only way to clear it is by using the "rst" reset signal.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.
    //
    // Example:
    // a -> 10010011000110100001100100
    // b -> 11011011110111111001111110

    logic [7:0] counter;
    logic overflow_error;
    logic b_temp;

    always_ff @ (posedge clk) begin
        if (rst) begin
            overflow_error <= 0;
            counter <= 0;
            b_temp <= 0;
        end else begin
            b_temp <= 0;
            if (a) begin
                counter <= counter + 1;
                b_temp <= 1;
            end else begin
                if (counter > 0) begin
                    b_temp <= 1;
                    counter <= counter - 1;
                end
            end
            if (counter > 200) begin
                overflow_error <= 1;
            end
        end
    end

    assign b = b_temp;
    assign overflow = overflow_error;

endmodule
