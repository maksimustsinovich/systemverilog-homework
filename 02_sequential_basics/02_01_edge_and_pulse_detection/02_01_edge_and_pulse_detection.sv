//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module posedge_detector (input clk, rst, a, output detected);

  logic a_r;

  // Note:
  // The a_r flip-flop input value d propogates to the output q
  // only on the next clock cycle.

  always_ff @ (posedge clk)
    if (rst)
      a_r <= '0;
    else
      a_r <= a;

  assign detected = ~ a_r & a;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module one_cycle_pulse_detector (input clk, rst, a, output detected);

  logic a_r1, a_r2;

  always_ff @ (posedge clk or posedge rst) begin
    if (rst) begin
      a_r1 <= '0;
      a_r2 <= '0;
    end else begin
      a_r2 <= a_r1;
      a_r1 <= a;
    end
  end

  assign detected = (a_r2 == 1'b0) && (a_r1 == 1'b1) && (a == 1'b0);

endmodule
