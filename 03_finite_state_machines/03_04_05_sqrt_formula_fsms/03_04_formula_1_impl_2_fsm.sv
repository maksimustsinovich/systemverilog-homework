//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module formula_1_impl_2_fsm
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

    output logic        isqrt_1_x_vld,
    output logic [31:0] isqrt_1_x,

    input               isqrt_1_y_vld,
    input        [15:0] isqrt_1_y,

    output logic        isqrt_2_x_vld,
    output logic [31:0] isqrt_2_x,

    input               isqrt_2_y_vld,
    input        [15:0] isqrt_2_y
);

    // Task:
    // Implement a module that calculates the formula from the `formula_1_fn.svh` file
    // using two instances of the isqrt module in parallel.
    //
    // Design the FSM to calculate an answer and provide the correct `res` value
    //
    // You can read the discussion of this problem
    // in the article by Yuri Panchul published in
    // FPGA-Systems Magazine :: FSM :: Issue ALFA (state_0)
    // You can download this issue from https://fpga-systems.ru/fsm

    enum logic[1:0]
    {
        idle = 2'b00,
        wait_a_b = 2'b01,
        wait_c = 2'b10
    }
    state, new_state;

    always_comb
    begin
        new_state = state;

        isqrt_1_x_vld = '0;
        isqrt_1_x = 'x;
        isqrt_2_x_vld = '0;
        isqrt_2_x = 'x;

        case (state)

            idle:
                begin
                    isqrt_1_x = a;
                    isqrt_2_x = b;

                    if (arg_vld)
                    begin
                        isqrt_1_x_vld = '1;
                        isqrt_2_x_vld = '1;

                        new_state = wait_a_b;
                    end
                end

            wait_a_b:
            begin
                isqrt_1_x = c;
                if (isqrt_1_y_vld & isqrt_2_y_vld)
                begin
                    isqrt_1_x_vld = '1;
                    new_state = wait_c;
                end
            end

            wait_c:
            begin
                if (isqrt_1_y_vld)
                begin
                    new_state = idle;
                end
            end
        endcase
    end

    always_ff @ (posedge clk)
        if (rst)
            state <= idle;
        else
            state <= new_state;

    always_ff @ (posedge clk)
        if (rst)
            res_vld <= '0;
        else
            res_vld <= (state == wait_c & isqrt_1_y_vld);

    always_ff @ (posedge clk)
        if (state == idle)
            res <= '0;
        else if (isqrt_1_y_vld & isqrt_2_y_vld)
            res <= res + 32' (isqrt_1_y) + 32' (isqrt_2_y);
        else if (isqrt_1_y_vld)
            res <= res + 32' (isqrt_1_y);

endmodule
