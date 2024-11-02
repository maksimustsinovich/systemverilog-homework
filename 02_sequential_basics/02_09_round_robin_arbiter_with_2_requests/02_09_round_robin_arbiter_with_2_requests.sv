//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module round_robin_arbiter_with_2_requests
(
    input        clk,
    input        rst,
    input  [1:0] requests,
    output [1:0] grants
);

    reg [1:0] prev;
    reg [1:0] curr;

    always_comb begin
        case (requests)
            2'b00: begin
                curr = requests;
            end
            2'b01: begin
                curr = requests;
                prev = curr;
            end
            2'b10: begin
                curr = requests;
                prev = curr;
            end
            2'b11: begin
                curr = ~prev;
                prev = ~prev;
            end
        endcase
    end

    always_ff @ (posedge clk) begin
        if (rst) begin
            prev <= 2'b00;
            curr <= 2'b00;
        end
    end

    assign grants = curr;

endmodule
