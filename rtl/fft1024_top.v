module fft1024_top (
    input  wire               clk,
    input  wire               rst_n,
    input  wire               start,

    input  wire               in_we,
    input  wire [9:0]         in_addr,
    input  wire signed [15:0] in_re,
    input  wire signed [15:0] in_im,

    input  wire [9:0]         out_addr,
    output wire signed [15:0] out_re,
    output wire signed [15:0] out_im,

    output wire               busy,
    output reg                done
);
    localparam S_IDLE       = 3'd0;
    localparam S_LOAD_REQ   = 3'd1;
    localparam S_LOAD_WRITE = 3'd2;
    localparam S_RUN_READ   = 3'd3;
    localparam S_RUN_WRITE  = 3'd4;

    reg [2:0] state;
    reg [9:0] load_idx;
    reg [3:0] stage;
    reg [8:0] bfly;

    wire [9:0] br_src;
    wire [9:0] addr_a;
    wire [9:0] addr_b;
    wire [8:0] tw_idx;

    reg         in_cen;
    reg         in_gwen;
    reg  [9:0]  in_mem_addr;
    reg  [15:0] in_mem_din;
    wire [15:0] in_mem_dout;

    reg         tw_cen;
    reg         tw_gwen;
    reg  [8:0]  tw_addr;
    wire [31:0] tw_dout;

    reg         work_cena;
    reg         work_gwena;
    reg  [9:0]  work_addra;
    reg  [31:0] work_dina;
    wire [31:0] work_douta;

    reg         work_cenb;
    reg         work_gwenb;
    reg  [9:0]  work_addrb;
    reg  [31:0] work_dinb;
    wire [31:0] work_doutb;

    wire signed [15:0] a_re;
    wire signed [15:0] a_im;
    wire signed [15:0] b_re;
    wire signed [15:0] b_im;
    wire signed [15:0] w_re;
    wire signed [15:0] w_im;

    wire signed [15:0] x_re;
    wire signed [15:0] x_im;
    wire signed [15:0] y_re;
    wire signed [15:0] y_im;
    wire signed [15:0] out_re_q97;
    wire signed [15:0] out_im_q97;

    assign busy = (state != S_IDLE);

    assign a_re = work_douta[31:16];
    assign a_im = work_douta[15:0];
    assign b_re = work_doutb[31:16];
    assign b_im = work_doutb[15:0];
    assign w_re = tw_dout[31:16];
    assign w_im = tw_dout[15:0];

    assign out_re = (state == S_IDLE) ? out_re_q97 : 16'sd0;
    assign out_im = (state == S_IDLE) ? out_im_q97 : 16'sd0;

    bit_reverse10 u_br (
        .in_idx(load_idx),
        .out_idx(br_src)
    );

    fft_addr_gen u_addr (
        .stage(stage),
        .bfly(bfly),
        .addr_a(addr_a),
        .addr_b(addr_b),
        .tw_idx(tw_idx)
    );

    complex_butterfly u_bfly (
        .ar(a_re),
        .ai(a_im),
        .br(b_re),
        .bi(b_im),
        .wr(w_re),
        .wi(w_im),
        .xr(x_re),
        .xi(x_im),
        .yr(y_re),
        .yi(y_im)
    );

    fft_output_quantizer #(
        .SHIFT(8)
    ) u_out_re_quantizer (
        .din ({{16{work_douta[31]}}, work_douta[31:16]}),
        .dout(out_re_q97)
    );

    fft_output_quantizer #(
        .SHIFT(8)
    ) u_out_im_quantizer (
        .din ({{16{work_douta[15]}}, work_douta[15:0]}),
        .dout(out_im_q97)
    );

    sram_in_wrapper u_input_mem (
        .clk  (clk),
        .cen  (in_cen),
        .gwen (in_gwen),
        .addr (in_mem_addr),
        .din  (in_mem_din),
        .dout (in_mem_dout)
    );

    sram_twiddle_wrapper u_twiddle_mem (
        .clk  (clk),
        .cen  (tw_cen),
        .gwen (tw_gwen),
        .addr (tw_addr),
        .din  (32'b0),
        .dout (tw_dout)
    );

    sram_work_wrapper u_work_mem (
        .clka  (clk),
        .cena  (work_cena),
        .gwena (work_gwena),
        .addra (work_addra),
        .dina  (work_dina),
        .douta (work_douta),
        .clkb  (clk),
        .cenb  (work_cenb),
        .gwenb (work_gwenb),
        .addrb (work_addrb),
        .dinb  (work_dinb),
        .doutb (work_doutb)
    );

    always @(*) begin
        in_cen = 1'b1;
        in_gwen = 1'b1;
        in_mem_addr = 10'd0;
        in_mem_din = 16'd0;

        tw_cen = 1'b1;
        tw_gwen = 1'b1;
        tw_addr = 9'd0;

        work_cena = 1'b1;
        work_gwena = 1'b1;
        work_addra = 10'd0;
        work_dina = 32'd0;

        work_cenb = 1'b1;
        work_gwenb = 1'b1;
        work_addrb = 10'd0;
        work_dinb = 32'd0;

        case (state)
            S_IDLE: begin
                if (in_we) begin
                    in_cen = 1'b0;
                    in_gwen = 1'b0;
                    in_mem_addr = in_addr;
                    in_mem_din = in_re;
                end

                work_cena = 1'b0;
                work_gwena = 1'b1;
                work_addra = out_addr;
            end

            S_LOAD_REQ: begin
                in_cen = 1'b0;
                in_gwen = 1'b1;
                in_mem_addr = br_src;
            end

            S_LOAD_WRITE: begin
                work_cena = 1'b0;
                work_gwena = 1'b0;
                work_addra = load_idx;
                work_dina = {in_mem_dout, 16'd0};
            end

            S_RUN_READ: begin
                tw_cen = 1'b0;
                tw_gwen = 1'b1;
                tw_addr = tw_idx;

                work_cena = 1'b0;
                work_gwena = 1'b1;
                work_addra = addr_a;

                work_cenb = 1'b0;
                work_gwenb = 1'b1;
                work_addrb = addr_b;
            end

            S_RUN_WRITE: begin
                work_cena = 1'b0;
                work_gwena = 1'b0;
                work_addra = addr_a;
                work_dina = {x_re, x_im};

                work_cenb = 1'b0;
                work_gwenb = 1'b0;
                work_addrb = addr_b;
                work_dinb = {y_re, y_im};
            end

            default: begin
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;
            load_idx <= 10'd0;
            stage <= 4'd0;
            bfly <= 9'd0;
            done <= 1'b0;
        end else begin
            done <= 1'b0;

            case (state)
                S_IDLE: begin
                    load_idx <= 10'd0;
                    stage <= 4'd0;
                    bfly <= 9'd0;
                    if (start) begin
                        state <= S_LOAD_REQ;
                    end
                end

                S_LOAD_REQ: begin
                    state <= S_LOAD_WRITE;
                end

                S_LOAD_WRITE: begin
                    if (load_idx == 10'd1023) begin
                        load_idx <= 10'd0;
                        stage <= 4'd0;
                        bfly <= 9'd0;
                        state <= S_RUN_READ;
                    end else begin
                        load_idx <= load_idx + 10'd1;
                        state <= S_LOAD_REQ;
                    end
                end

                S_RUN_READ: begin
                    state <= S_RUN_WRITE;
                end

                S_RUN_WRITE: begin
                    if (bfly == 9'd511) begin
                        bfly <= 9'd0;
                        if (stage == 4'd9) begin
                            state <= S_IDLE;
                            done <= 1'b1;
                        end else begin
                            stage <= stage + 4'd1;
                            state <= S_RUN_READ;
                        end
                    end else begin
                        bfly <= bfly + 9'd1;
                        state <= S_RUN_READ;
                    end
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end
endmodule
