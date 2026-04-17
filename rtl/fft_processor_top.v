`timescale 1ns / 1ps

module fft_processor_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] data_in_re,
    input  wire        tb_io_mode,
    input  wire        tb_skip_load,
    input  wire        tb_sram_we,
    input  wire [9:0]  tb_sram_addr,
    input  wire [31:0] tb_sram_din,
    input  wire        tb_twiddle_we,
    input  wire [8:0]  tb_twiddle_addr,
    input  wire [31:0] tb_twiddle_din,

    output wire [31:0] tb_sram_dout,
    output wire [31:0] tb_twiddle_dout,
    output wire [15:0] data_out_re,
    output wire [15:0] data_out_im,
    output wire        data_out_valid,
    output wire        done,
    output wire [3:0]  dbg_stage,
    output wire        dbg_stage_done
);
    wire        sram_we_a_int, sram_we_b_int;
    wire [9:0]  sram_addr_a_int, sram_addr_b_int;
    wire [31:0] sram_din_a_int, sram_din_b_int;
    wire [31:0] sram_dout_a, sram_dout_b;

    wire        sram_we_a_mux, sram_we_b_mux;
    wire [9:0]  sram_addr_a_mux, sram_addr_b_mux;
    wire [31:0] sram_din_a_mux, sram_din_b_mux;

    wire [8:0]  twiddle_addr_int;
    wire [31:0] twiddle_data;
    wire        is_loading, is_unloading;

    wire [15:0] bf_y0_re, bf_y0_im, bf_y1_re, bf_y1_im;
    reg         unload_valid_d;

    fft_controller u_ctrl (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .tb_skip_load(tb_skip_load),
        .sram_we_a(sram_we_a_int),
        .sram_we_b(sram_we_b_int),
        .sram_addr_a(sram_addr_a_int),
        .sram_addr_b(sram_addr_b_int),
        .twiddle_addr(twiddle_addr_int),
        .is_loading(is_loading),
        .is_unloading(is_unloading),
        .done(done),
        .dbg_stage(dbg_stage),
        .dbg_stage_done(dbg_stage_done)
    );

    assign sram_din_a_int = is_loading ? {data_in_re, 16'd0} : {bf_y0_re, bf_y0_im};
    assign sram_din_b_int = {bf_y1_re, bf_y1_im};

    assign sram_we_a_mux   = tb_io_mode ? tb_sram_we   : sram_we_a_int;
    assign sram_addr_a_mux = tb_io_mode ? tb_sram_addr : sram_addr_a_int;
    assign sram_din_a_mux  = tb_io_mode ? tb_sram_din  : sram_din_a_int;
    assign sram_we_b_mux   = tb_io_mode ? 1'b0         : sram_we_b_int;
    assign sram_addr_b_mux = tb_io_mode ? 10'd0        : sram_addr_b_int;
    assign sram_din_b_mux  = tb_io_mode ? 32'd0        : sram_din_b_int;

    sram_1024x32 u_sram (
        .clk(clk),
        .we_a(sram_we_a_mux), .addr_a(sram_addr_a_mux), .din_a(sram_din_a_mux), .dout_a(sram_dout_a),
        .we_b(sram_we_b_mux), .addr_b(sram_addr_b_mux), .din_b(sram_din_b_mux), .dout_b(sram_dout_b)
    );

    twiddle_rom u_rom (
        .clk(clk),
        .addr(twiddle_addr_int),
        .ext_we(tb_io_mode && tb_twiddle_we),
        .ext_addr(tb_twiddle_addr),
        .ext_din(tb_twiddle_din),
        .dout(twiddle_data),
        .ext_dout(tb_twiddle_dout)
    );

    butterfly_unit u_bf (
        .clk(clk), .rst_n(rst_n),
        .x0_re(sram_dout_a[31:16]), .x0_im(sram_dout_a[15:0]),
        .x1_re(sram_dout_b[31:16]), .x1_im(sram_dout_b[15:0]),
        .w_re (twiddle_data[31:16]), .w_im (twiddle_data[15:0]),
        .y0_re(bf_y0_re), .y0_im(bf_y0_im),
        .y1_re(bf_y1_re), .y1_im(bf_y1_im)
    );

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            unload_valid_d <= 1'b0;
        end else begin
            unload_valid_d <= is_unloading;
        end
    end

    assign tb_sram_dout = sram_dout_a;
    assign data_out_re = sram_dout_a[31:16];
    assign data_out_im = sram_dout_a[15:0];
    assign data_out_valid = unload_valid_d;

endmodule
