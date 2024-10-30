//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_to_parallel
# (
    parameter width = 8
)
(
    input                      clk,
    input                      rst,

    input                      serial_valid,
    input                      serial_data,

    output logic               parallel_valid,
    output logic [width - 1:0] parallel_data
);
    // Task:
    // Implement a module that converts serial data to the parallel multibit value.
    //
    // The module should accept one-bit values with valid interface in a serial manner.
    // After accumulating 'width' bits, the module should assert the parallel_valid
    // output and set the data.
    //
    // Note:
    // Check the waveform diagram in the README for better understanding.

    logic [3:0] counter;
    logic [width - 1:0] temp_data;
    logic temp_valid;

    //always_comb begin
    //    if (temp_valid) begin
    //        temp_data = 0;
    //        temp_valid = 0;
    //    end
    //end

    always_ff @ (posedge clk) begin
        if (rst) begin
            counter <= 0;
            temp_data <= 0;
            temp_valid <= 0;
        end
        else begin
            temp_valid <= 0;
            if (serial_valid) begin
                temp_data <= (temp_data >> 1) + (serial_data << (width - 1));
                counter++;
            end
            if (counter == width) begin
                counter <= 0;
                temp_valid <= 1;
            end
        end
    end

    assign parallel_data = temp_data;
    assign parallel_valid = temp_valid;

endmodule