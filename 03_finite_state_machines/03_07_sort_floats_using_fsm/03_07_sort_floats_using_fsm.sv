//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module sort_floats_using_fsm (
    input                          clk,
    input                          rst,

    input                          valid_in,
    input        [0:2][FLEN - 1:0] unsorted,

    output logic                   valid_out,
    output logic [0:2][FLEN - 1:0] sorted,
    output logic                   err,
    output                         busy,

    // f_less_or_equal interface
    output logic      [FLEN - 1:0] f_le_a,
    output logic      [FLEN - 1:0] f_le_b,
    input                          f_le_res,
    input                          f_le_err
);

    // Task:
    // Implement a module that accepts three Floating-Point numbers and outputs them in the increasing order using FSM.
    //
    // Requirements:
    // The solution must have latency equal to the three clock cycles.
    // The solution should use the inputs and outputs to the single "f_less_or_equal" module.
    // The solution should NOT create instances of any modules.
    //
    // Notes:
    // res0 must be less or equal to the res1
    // res1 must be less or equal to the res1
    //
    // The FLEN parameter is defined in the "import/preprocessed/cvw/config-shared.vh" file
    // and usually equal to the bit width of the double-precision floating-point number, FP64, 64 bits.

    enum logic [2:0] {
        st_check_0_1 = 3'd0,
        st_check_1_2 = 3'd1,
        st_check_0_2 = 3'd2,
        st_result    = 3'd3
    } state, new_state;

    logic [2:0] swaps;

    always_comb begin
        new_state = state;
        f_le_a = '0; 
        f_le_b = '0;

        case (state)
            st_check_0_1: begin
                if (valid_in) begin
                    f_le_a = unsorted[0];
                    f_le_b = unsorted[1];
                    if (!f_le_err) begin
                        new_state = st_check_1_2;
                    end
                end
            end

            st_check_1_2: begin
                f_le_a = unsorted[1];
                f_le_b = unsorted[2];
                if (!f_le_err) begin
                    new_state = st_check_0_2;
                end else begin
                    new_state = st_check_0_1;
                end
            end

            st_check_0_2: begin
                f_le_a = unsorted[0];
                f_le_b = unsorted[2];
                if (!f_le_err) begin
                    new_state = st_result;
                end else begin
                    new_state = st_check_0_1;
                end
            end

            st_result: begin
                new_state = st_check_0_1;
            end
        endcase
    end

    always_comb begin
        if (swaps[2] & swaps[1] & swaps[0]) begin
            sorted = unsorted;
        end else if (swaps[2] & ~swaps[1] & swaps[0]) begin
            {sorted[0], sorted[1], sorted[2]} = {unsorted[0], unsorted[2], unsorted[1]};
        end else if (~swaps[2] & swaps[1] & swaps[0]) begin
            {sorted[0], sorted[1], sorted[2]} = {unsorted[1], unsorted[0], unsorted[2]};
        end else if (~swaps[2] & ~swaps[1] & ~swaps[0]) begin
            {sorted[0], sorted[1], sorted[2]} = {unsorted[2], unsorted[1], unsorted[0]};
        end else if (swaps[2] & ~swaps[1] & ~swaps[0]) begin
            {sorted[0], sorted[1], sorted[2]} = {unsorted[2], unsorted[0], unsorted[1]};
        end else begin
            {sorted[0], sorted[1], sorted[2]} = {unsorted[1], unsorted[2], unsorted[0]};
        end
    end

    always_ff @ (posedge clk) begin
        if (rst) begin
            state <= st_check_0_1;
            swaps <= '0;
        end else begin
            state <= new_state;
            if (state == st_check_0_1 && !f_le_err) begin
                swaps[2] = f_le_res;
            end else if (state == st_check_1_2 && !f_le_err) begin
                swaps[1] = f_le_res;
            end else if (state == st_check_0_2 && !f_le_err) begin
                swaps[0] = f_le_res;
            end
        end
    end

    assign err = f_le_err;
    assign valid_out = (state == st_result) || f_le_err;

endmodule
