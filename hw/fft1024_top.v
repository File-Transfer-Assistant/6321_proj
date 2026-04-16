module fft1024_top (
    input clk,
    input rst_n,
    input start,
    output busy,
    output  done,
    input in_we,
    input      [9:0]             in_addr,
    input      signed [15:0]     in_wdata,
    output     signed [15:0]     in_rdata,
    input                        tw_we,
    input      [8:0]             tw_addr,
    input      signed [15:0]     tw_re_wdata,
    input      signed [15:0]     tw_im_wdata,
    output     signed [15:0]     tw_re_rdata,
    output     signed [15:0]     tw_im_rdata,
    input      [9:0]             out_addr,
    output     signed [15:0]     out_re_rdata,
    output     signed [15:0]     out_im_rdata
);
    localparam INT_W = 32;

    wire        br_start;
    wire        br_done;
    wire        stage_active;
    wire        store_active;
    wire [3:0]  stage_idx;
    wire [8:0]  butterfly_idx;
    wire        stage_src_sel;
    wire [9:0]  store_idx;
    wire        result_bank_sel;

    wire [9:0]  load_src_addr;
    wire signed [15:0] load_src_data;
    wire        load_busy;
    wire        load_dst_we;
    wire [9:0]  load_dst_addr;
    wire signed [INT_W-1:0] load_dst_re;
    wire signed [INT_W-1:0] load_dst_im;

    wire [9:0]  fft_a_addr;
    wire [9:0]  fft_b_addr;
    wire [8:0]  fft_tw_addr;

    wire signed [15:0] tw_re_int;
    wire signed [15:0] tw_im_int;

    reg                bank0_a_we;
    reg  [9:0]         bank0_a_addr;
    reg  signed [INT_W-1:0] bank0_a_re_din;
    reg  signed [INT_W-1:0] bank0_a_im_din;
    wire signed [INT_W-1:0] bank0_a_re_dout;
    wire signed [INT_W-1:0] bank0_a_im_dout;
    reg                bank0_b_we;
    reg  [9:0]         bank0_b_addr;
    reg  signed [INT_W-1:0] bank0_b_re_din;
    reg  signed [INT_W-1:0] bank0_b_im_din;
    wire signed [INT_W-1:0] bank0_b_re_dout;
    wire signed [INT_W-1:0] bank0_b_im_dout;

    reg                bank1_a_we;
    reg  [9:0]         bank1_a_addr;
    reg  signed [INT_W-1:0] bank1_a_re_din;
    reg  signed [INT_W-1:0] bank1_a_im_din;
    wire signed [INT_W-1:0] bank1_a_re_dout;
    wire signed [INT_W-1:0] bank1_a_im_dout;
    reg                bank1_b_we;
    reg  [9:0]         bank1_b_addr;
    reg  signed [INT_W-1:0] bank1_b_re_din;
    reg  signed [INT_W-1:0] bank1_b_im_din;
    wire signed [INT_W-1:0] bank1_b_re_dout;
    wire signed [INT_W-1:0] bank1_b_im_dout;

    wire signed [INT_W-1:0] src_a_re;
    wire signed [INT_W-1:0] src_a_im;
    wire signed [INT_W-1:0] src_b_re;
    wire signed [INT_W-1:0] src_b_im;

    wire signed [INT_W-1:0] fft_y0_re;
    wire signed [INT_W-1:0] fft_y0_im;
    wire signed [INT_W-1:0] fft_y1_re;
    wire signed [INT_W-1:0] fft_y1_im;

    wire signed [INT_W-1:0] store_src_re;
    wire signed [INT_W-1:0] store_src_im;
    wire signed [15:0]      q_out_re;
    wire signed [15:0]      q_out_im;
    wire signed [15:0]      out_ram_re_unused;
    wire signed [15:0]      out_ram_im_unused;

    fft_controller u_fft_controller (
        .clk            (clk),
        .rst_n          (rst_n),
        .start          (start),
        .br_done        (br_done),
        .br_start       (br_start),
        .busy           (busy),
        .done           (done),
        .stage_active   (stage_active),
        .store_active   (store_active),
        .stage_idx      (stage_idx),
        .butterfly_idx  (butterfly_idx),
        .stage_src_sel  (stage_src_sel),
        .store_idx      (store_idx),
        .result_bank_sel(result_bank_sel)
    );

    bit_reverse_loader #(
        .OUT_WIDTH(INT_W)
    ) u_bit_reverse_loader (
        .clk     (clk),
        .rst_n   (rst_n),
        .start   (br_start),
        .busy    (load_busy),
        .done    (br_done),
        .src_addr(load_src_addr),
        .src_data(load_src_data),
        .dst_we  (load_dst_we),
        .dst_addr(load_dst_addr),
        .dst_re  (load_dst_re),
        .dst_im  (load_dst_im)
    );

    fft_addr_gen u_fft_addr_gen (
        .stage_idx    (stage_idx),
        .butterfly_idx(butterfly_idx),
        .a_addr       (fft_a_addr),
        .b_addr       (fft_b_addr),
        .tw_addr      (fft_tw_addr)
    );

    complex_butterfly #(
        .DATA_WIDTH(INT_W)
    ) u_complex_butterfly (
        .x0_re(src_a_re),
        .x0_im(src_a_im),
        .x1_re(src_b_re),
        .x1_im(src_b_im),
        .tw_re(tw_re_int),
        .tw_im(tw_im_int),
        .y0_re(fft_y0_re),
        .y0_im(fft_y0_im),
        .y1_re(fft_y1_re),
        .y1_im(fft_y1_im)
    );

    fft_output_quantizer #(
        .IN_WIDTH(INT_W),
        .SHIFT_BITS(8)
    ) u_fft_output_quantizer (
        .in_re (store_src_re),
        .in_im (store_src_im),
        .out_re(q_out_re),
        .out_im(q_out_im)
    );

    ram_tdp #(
        .WIDTH(16),
        .DEPTH(1024),
        .ADDR_W(10)
    ) u_input_ram (
        .clk   (clk),
        .a_we  (in_we),
        .a_addr(in_addr),
        .a_din (in_wdata),
        .a_dout(in_rdata),
        .b_we  (1'b0),
        .b_addr(load_src_addr),
        .b_din (16'd0),
        .b_dout(load_src_data)
    );

    ram_tdp #(
        .WIDTH(16),
        .DEPTH(512),
        .ADDR_W(9)
    ) u_twiddle_ram_re (
        .clk   (clk),
        .a_we  (tw_we),
        .a_addr(tw_addr),
        .a_din (tw_re_wdata),
        .a_dout(tw_re_rdata),
        .b_we  (1'b0),
        .b_addr(fft_tw_addr),
        .b_din (16'd0),
        .b_dout(tw_re_int)
    );

    ram_tdp #(
        .WIDTH(16),
        .DEPTH(512),
        .ADDR_W(9)
    ) u_twiddle_ram_im (
        .clk   (clk),
        .a_we  (tw_we),
        .a_addr(tw_addr),
        .a_din (tw_im_wdata),
        .a_dout(tw_im_rdata),
        .b_we  (1'b0),
        .b_addr(fft_tw_addr),
        .b_din (16'd0),
        .b_dout(tw_im_int)
    );

    complex_ram_bank #(
        .WIDTH(INT_W),
        .DEPTH(1024),
        .ADDR_W(10)
    ) u_work_bank0 (
        .clk      (clk),
        .a_we     (bank0_a_we),
        .a_addr   (bank0_a_addr),
        .a_re_din (bank0_a_re_din),
        .a_im_din (bank0_a_im_din),
        .a_re_dout(bank0_a_re_dout),
        .a_im_dout(bank0_a_im_dout),
        .b_we     (bank0_b_we),
        .b_addr   (bank0_b_addr),
        .b_re_din (bank0_b_re_din),
        .b_im_din (bank0_b_im_din),
        .b_re_dout(bank0_b_re_dout),
        .b_im_dout(bank0_b_im_dout)
    );

    complex_ram_bank #(
        .WIDTH(INT_W),
        .DEPTH(1024),
        .ADDR_W(10)
    ) u_work_bank1 (
        .clk      (clk),
        .a_we     (bank1_a_we),
        .a_addr   (bank1_a_addr),
        .a_re_din (bank1_a_re_din),
        .a_im_din (bank1_a_im_din),
        .a_re_dout(bank1_a_re_dout),
        .a_im_dout(bank1_a_im_dout),
        .b_we     (bank1_b_we),
        .b_addr   (bank1_b_addr),
        .b_re_din (bank1_b_re_din),
        .b_im_din (bank1_b_im_din),
        .b_re_dout(bank1_b_re_dout),
        .b_im_dout(bank1_b_im_dout)
    );

    ram_tdp #(
        .WIDTH(16),
        .DEPTH(1024),
        .ADDR_W(10)
    ) u_output_ram_re (
        .clk   (clk),
        .a_we  (store_active),
        .a_addr(store_idx),
        .a_din (q_out_re),
        .a_dout(out_ram_re_unused),
        .b_we  (1'b0),
        .b_addr(out_addr),
        .b_din (16'd0),
        .b_dout(out_re_rdata)
    );

    ram_tdp #(
        .WIDTH(16),
        .DEPTH(1024),
        .ADDR_W(10)
    ) u_output_ram_im (
        .clk   (clk),
        .a_we  (store_active),
        .a_addr(store_idx),
        .a_din (q_out_im),
        .a_dout(out_ram_im_unused),
        .b_we  (1'b0),
        .b_addr(out_addr),
        .b_din (16'd0),
        .b_dout(out_im_rdata)
    );

    assign src_a_re = stage_src_sel ? bank1_a_re_dout : bank0_a_re_dout;
    assign src_a_im = stage_src_sel ? bank1_a_im_dout : bank0_a_im_dout;
    assign src_b_re = stage_src_sel ? bank1_b_re_dout : bank0_b_re_dout;
    assign src_b_im = stage_src_sel ? bank1_b_im_dout : bank0_b_im_dout;

    assign store_src_re = result_bank_sel ? bank1_a_re_dout : bank0_a_re_dout;
    assign store_src_im = result_bank_sel ? bank1_a_im_dout : bank0_a_im_dout;

    always @(*) begin
        bank0_a_we     = 1'b0;
        bank0_a_addr   = 10'd0;
        bank0_a_re_din = {INT_W{1'b0}};
        bank0_a_im_din = {INT_W{1'b0}};
        bank0_b_we     = 1'b0;
        bank0_b_addr   = 10'd0;
        bank0_b_re_din = {INT_W{1'b0}};
        bank0_b_im_din = {INT_W{1'b0}};

        bank1_a_we     = 1'b0;
        bank1_a_addr   = 10'd0;
        bank1_a_re_din = {INT_W{1'b0}};
        bank1_a_im_din = {INT_W{1'b0}};
        bank1_b_we     = 1'b0;
        bank1_b_addr   = 10'd0;
        bank1_b_re_din = {INT_W{1'b0}};
        bank1_b_im_din = {INT_W{1'b0}};

        if (load_dst_we) begin
            bank1_a_we     = 1'b1;
            bank1_a_addr   = load_dst_addr;
            bank1_a_re_din = load_dst_re;
            bank1_a_im_din = load_dst_im;
        end else if (stage_active) begin
            if (stage_src_sel == 1'b0) begin
                bank0_a_addr   = fft_a_addr;
                bank0_b_addr   = fft_b_addr;

                bank1_a_we     = 1'b1;
                bank1_a_addr   = fft_a_addr;
                bank1_a_re_din = fft_y0_re;
                bank1_a_im_din = fft_y0_im;
                bank1_b_we     = 1'b1;
                bank1_b_addr   = fft_b_addr;
                bank1_b_re_din = fft_y1_re;
                bank1_b_im_din = fft_y1_im;
            end else begin
                bank1_a_addr   = fft_a_addr;
                bank1_b_addr   = fft_b_addr;

                bank0_a_we     = 1'b1;
                bank0_a_addr   = fft_a_addr;
                bank0_a_re_din = fft_y0_re;
                bank0_a_im_din = fft_y0_im;
                bank0_b_we     = 1'b1;
                bank0_b_addr   = fft_b_addr;
                bank0_b_re_din = fft_y1_re;
                bank0_b_im_din = fft_y1_im;
            end
        end else if (store_active) begin
            if (result_bank_sel) begin
                bank1_a_addr = store_idx;
            end else begin
                bank0_a_addr = store_idx;
            end
        end
    end
endmodule
