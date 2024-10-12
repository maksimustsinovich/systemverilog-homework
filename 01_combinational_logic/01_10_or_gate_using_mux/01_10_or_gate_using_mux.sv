//----------------------------------------------------------------------------
// Example
//----------------------------------------------------------------------------

module mux
(
  input  d0, d1,
  input  sel,
  output y
);

  assign y = sel ? d1 : d0;

endmodule

//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module or_gate_using_mux
(
    input  a,
    input  b,
    output o
);

  // Task:

  // Implement or gate using instance(s) of mux,
  // constants 0 and 1, and wire connections

  wire mux0_o;

  mux mux0(.d0(1'b0), .d1(1'b1), .sel(a), .y(mux0_o));
  mux mux1(.d0(mux0_o), .d1(1'b1), .sel(b), .y(o));

endmodule
