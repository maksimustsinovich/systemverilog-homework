//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module fibonacci
(
  input               clk,
  input               rst,
  output logic [15:0] num
);

  logic [15:0] num2;

  always_ff @ (posedge clk)
    if (rst)
      { num, num2 } <= { 16'd1, 16'd1 };
    else
      { num, num2 } <= { num2, num + num2 };

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module fibonacci_2
(
  input               clk,
  input               rst,
  output logic [15:0] num,
  output logic [15:0] num2
);

  // Task:
  // Implement a module that generates two fibonacci numbers per cycle

  logic [15:0] a, b;

  always_ff @ (posedge clk)
    if (rst)
    begin
        { a, b } <= { 16'd1, 16'd1 };
        { num, num2 } <= { a, b };
    end
    else
    begin
        { a, b } = { b, a + b };
        { a, b } = { b, a + b };
        { num, num2 } <= { a, b };
    end

endmodule
