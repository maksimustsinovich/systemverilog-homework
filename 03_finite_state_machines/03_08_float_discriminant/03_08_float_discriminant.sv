//----------------------------------------------------------------------------
// Task
//----------------------------------------------------------------------------

module float_discriminant (
    input                     clk,
    input                     rst,

    input                     arg_vld,
    input        [FLEN - 1:0] a,
    input        [FLEN - 1:0] b,
    input        [FLEN - 1:0] c,

    output logic              res_vld,
    output logic [FLEN - 1:0] res,
    output logic              res_negative,
    output logic              err,

    output logic              busy
);

    localparam [FLEN - 1:0] FOUR = 64'h4010_0000_0000_0000;

    logic [FLEN - 1:0] b_squared, a_times_c, four_times_ac;
    logic b_squared_valid, b_squared_err, b_squared_busy;
    logic a_times_c_valid, a_times_c_err, a_times_c_busy;
    logic four_times_ac_valid, four_times_ac_err, four_times_ac_busy;
    logic result_valid, result_err, result_busy;
    logic comparison_err;

    f_mult f_mult_b_squared (
        .clk(clk),
        .rst(rst),
        .a(b),
        .b(b),
        .up_valid(arg_vld),
        .res(b_squared),
        .down_valid(b_squared_valid),
        .busy(b_squared_busy),
        .error(b_squared_err)
    );
    
    f_mult f_mult_a_times_c (
        .clk(clk),
        .rst(rst),
        .a(a),
        .b(c),
        .up_valid(arg_vld),
        .res(a_times_c),
        .down_valid(a_times_c_valid),
        .busy(a_times_c_busy),
        .error(a_times_c_err)
    );

    // 4ac)
    f_mult f_mult_four_times_ac (
        .clk(clk),
        .rst(rst),
        .a(FOUR),
        .b(a_times_c),
        .up_valid(a_times_c_valid),
        .res(four_times_ac),
        .down_valid(four_times_ac_valid),
        .busy(four_times_ac_busy),
        .error(four_times_ac_err)
    );

    // b^2 - 4ac
    f_sub f_sub_result (
        .clk(clk),
        .rst(rst),
        .a(b_squared),
        .b(four_times_ac),
        .up_valid(four_times_ac_valid),
        .res(res),
        .down_valid(res_vld),
        .busy(result_busy),
        .error(result_err)
    );

    f_less_or_equal f_less_or_equal_result (
        .a(res),
        .b('0),
        .res(res_negative),
        .err(comparison_err)
    );

    assign err = b_squared_err | a_times_c_err | four_times_ac_err | result_err | comparison_err;
    assign busy = b_squared_busy | a_times_c_busy | four_times_ac_busy | result_busy;

endmodule
