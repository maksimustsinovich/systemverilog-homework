//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_2_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res,

    // isqrt interface

    output logic        isqrt_x_vld,
    output logic [31:0] isqrt_x,

    input               isqrt_y_vld,
    input        [15:0] isqrt_y
);
    // Task:
    // Implement a module that calculates the formula from the `formula_2_fn.svh` file
    // using only one instance of the isqrt module.
    //
    // Design the FSM to calculate answer step-by-step and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

enum logic [1:0] {
  st_idle = 2'd0,
  st_wait_a_res = 2'd1,
  st_wait_b_res = 2'd2,
  st_wait_c_res = 2'd3
}
state, next_state;

always_comb begin
  next_state = state;
  isqrt_x_vld = '0;
  isqrt_x = 'x;

  case (state)
    st_idle: 
        begin
        isqrt_x = c;
            if (arg_vld) begin
                isqrt_x_vld = '1;
                next_state = st_wait_c_res;
            end
        end
    st_wait_c_res:
        begin
        if (isqrt_y_vld)
            begin
                isqrt_x = b + isqrt_y;
                isqrt_x_vld = '1;
                next_state = st_wait_b_res;
            end
        end

        st_wait_b_res:
        begin
        if (isqrt_y_vld)
            begin
                isqrt_x = a + isqrt_y;
                isqrt_x_vld = '1;
                next_state = st_wait_a_res;
            end
        end

        st_wait_a_res:
        begin
        if (isqrt_y_vld)
            next_state = st_idle;
        end
        endcase
end

always_ff @(posedge clk)
  if (rst)
    state <= st_idle;
  else
    state <= next_state;

always_ff @(posedge clk)
  if (rst)
    res_vld <= '0;
  else
    res_vld <= (state == st_wait_a_res & isqrt_y_vld);

always_ff @(posedge clk)
  if (state == st_idle)
    res <= '0;
  else if (state == st_wait_a_res & isqrt_y_vld)
    res <= res + 32'(isqrt_y);

endmodule
