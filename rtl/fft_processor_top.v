`timescale 1ns / 1ps

module fft_processor_top (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] data_in_re, 
    
    output wire [15:0] data_out_re,
    output wire [15:0] data_out_im,
    output wire        data_out_valid,
    output wire        done
);
    wire        sram_we_a, sram_we_b;
    wire [9:0]  sram_addr_a, sram_addr_b;
    wire [31:0] sram_din_a, sram_din_b;
    wire [31:0] sram_dout_a, sram_dout_b;
    
    wire [8:0]  twiddle_addr;
    wire [31:0] twiddle_data;
    wire        is_loading, is_unloading;
    
    wire [15:0] bf_y0_re, bf_y0_im, bf_y1_re, bf_y1_im;

    fft_controller u_ctrl (
        .clk(clk), .rst_n(rst_n), .start(start),
        .sram_we_a(sram_we_a), .sram_we_b(sram_we_b),
        .sram_addr_a(sram_addr_a), .sram_addr_b(sram_addr_b),
        .twiddle_addr(twiddle_addr),
        .is_loading(is_loading), .is_unloading(is_unloading), .done(done)
    );

    // 复用 SRAM 输入：Load 状态接收外部实数，Compute 状态接收蝶形运算结果
    assign sram_din_a = is_loading ? {data_in_re, 16'd0} : {bf_y0_re, bf_y0_im};
    assign sram_din_b = {bf_y1_re, bf_y1_im}; 

    sram_1024x32 u_sram (
        .clk(clk),
        .we_a(sram_we_a), .addr_a(sram_addr_a), .din_a(sram_din_a), .dout_a(sram_dout_a),
        .we_b(sram_we_b), .addr_b(sram_addr_b), .din_b(sram_din_b), .dout_b(sram_dout_b)
    );

    twiddle_rom u_rom (
        .clk(clk), .addr(twiddle_addr), .dout(twiddle_data)
    );

    butterfly_unit u_bf (
        .clk(clk), .rst_n(rst_n),
        .x0_re(sram_dout_a[31:16]), .x0_im(sram_dout_a[15:0]),
        .x1_re(sram_dout_b[31:16]), .x1_im(sram_dout_b[15:0]),
        .w_re (twiddle_data[31:16]), .w_im (twiddle_data[15:0]),
        .y0_re(bf_y0_re), .y0_im(bf_y0_im),
        .y1_re(bf_y1_re), .y1_im(bf_y1_im)
    );

    // 输出赋值（在 unload 期间 SRAM 的 dout_a 是按 bit-reversed 顺序弹出的正确结果）
    assign data_out_re = sram_dout_a[31:16];
    assign data_out_im = sram_dout_a[15:0];
    assign data_out_valid = is_unloading;

endmodule
