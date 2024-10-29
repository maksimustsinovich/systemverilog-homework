//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module serial_adder
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output sum
);

  // Note:
  // carry_d represents the combinational data input to the carry register.

  logic carry;
  wire carry_d;

  assign { carry_d, sum } = a + b + carry;

  always_ff @ (posedge clk)
    if (rst)
      carry <= '0;
    else
      carry <= carry_d;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module serial_adder_using_logic_operations_only
(
  input  clk,
  input  rst,
  input  a,
  input  b,
  output sum
);

  logic carry;
  logic sum_temp;

  assign sum_temp = a ^ b ^ carry;
  logic carry_next;
  assign carry_next = (a & b) | (carry & (a ^ b));

  always_ff @ (posedge clk) begin
    if (rst) begin
      carry <= 1'b0;
    end else begin
      carry <= carry_next;
    end
  end

  assign sum = sum_temp;

endmodule
