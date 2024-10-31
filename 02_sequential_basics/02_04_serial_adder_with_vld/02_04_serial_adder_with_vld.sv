//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_with_vld
(
  input  clk,
  input  rst,
  input  vld,
  input  a,
  input  b,
  input  last,
  output sum
);

  logic carry;
  logic sum_temp;

  assign sum_temp = (vld) ? (a ^ b ^ carry) : 1'b0;
  logic carry_next;
  assign carry_next = (vld) ? ((a & b) | (carry & (a ^ b))) : carry;

  always_ff @ (posedge clk) begin
    if (rst) begin
      carry <= 1'b0;
    end else if (vld) begin
      carry <= carry_next;
    end
    if (last && vld) begin
      carry <= 1'b0;
    end
  end

  assign sum = sum_temp;

endmodule
