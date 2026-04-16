`timescale 1ns / 1ps

module butterfly_unit (
    input  wire clk,
    input  wire rst_n,
    
    input  wire signed [15:0] x0_re,
    input  wire signed [15:0] x0_im,
    input  wire signed [15:0] x1_re,
    input  wire signed [15:0] x1_im,
    
    input  wire signed [15:0] w_re,
    input  wire signed [15:0] w_im,
    
    output reg  signed [15:0] y0_re,
    output reg  signed [15:0] y0_im,
    output reg  signed [15:0] y1_re,
    output reg  signed [15:0] y1_im
);

    // ==========================================
    // Stage 1: Add / Sub (带右移防溢出)
    // ==========================================
    reg signed [15:0] add_re_scaled, add_im_scaled;
    reg signed [15:0] sub_re_scaled, sub_im_scaled;
    reg signed [15:0] w_re_q1, w_im_q1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            add_re_scaled <= 0; add_im_scaled <= 0;
            sub_re_scaled <= 0; sub_im_scaled <= 0;
            w_re_q1 <= 0; w_im_q1 <= 0;
        end else begin
            // 两个 16-bit 相加变 17-bit，直接取高 16 位相当于除以 2 (防溢出)
            add_re_scaled <= (x0_re + x1_re) >>> 1;
            add_im_scaled <= (x0_im + x1_im) >>> 1;
            sub_re_scaled <= (x0_re - x1_re) >>> 1;
            sub_im_scaled <= (x0_im - x1_im) >>> 1;
            w_re_q1 <= w_re; 
            w_im_q1 <= w_im;
        end
    end

    // ==========================================
    // Stage 2: Complex Multiply 
    // ==========================================
    wire signed [31:0] mult_rr = sub_re_scaled * w_re_q1;
    wire signed [31:0] mult_ii = sub_im_scaled * w_im_q1;
    wire signed [31:0] mult_ri = sub_re_scaled * w_im_q1;
    wire signed [31:0] mult_ir = sub_im_scaled * w_re_q1;

    reg signed [32:0] y1_re_full, y1_im_full;
    reg signed [15:0] add_re_q2, add_im_q2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y1_re_full <= 0; y1_im_full <= 0;
            add_re_q2 <= 0; add_im_q2 <= 0;
        end else begin
            y1_re_full <= mult_rr - mult_ii;
            y1_im_full <= mult_ri + mult_ir;
            add_re_q2  <= add_re_scaled;
            add_im_q2  <= add_im_scaled;
        end
    end

    // ==========================================
    // Stage 3: Truncate (Q2.30 to Q1.15)
    // ==========================================
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            y0_re <= 0; y0_im <= 0;
            y1_re <= 0; y1_im <= 0;
        end else begin
            y0_re <= add_re_q2;
            y0_im <= add_im_q2;
            // 截断回 16-bit 格式
            y1_re <= y1_re_full[30:15];
            y1_im <= y1_im_full[30:15];
        end
    end
endmodule
