`timescale 1ns/1ps

module tb_fft1024_top;
    localparam integer FFT_N = 1024;
    localparam integer TW_N = 512;
    localparam integer BLOCK_ID = 0;
    localparam integer CLK_PERIOD = 10;

    reg                     clk;
    reg                     rst_n;
    reg                     start;
    reg                     in_we;
    reg      [9:0]          in_addr;
    reg      signed [15:0]  in_wdata;
    wire     signed [15:0]  in_rdata;
    reg                     tw_we;
    reg      [8:0]          tw_addr;
    reg      signed [15:0]  tw_re_wdata;
    reg      signed [15:0]  tw_im_wdata;
    wire     signed [15:0]  tw_re_rdata;
    wire     signed [15:0]  tw_im_rdata;
    reg      [9:0]          out_addr;
    wire     signed [15:0]  out_re_rdata;
    wire     signed [15:0]  out_im_rdata;
    wire                    busy;
    wire                    done;

    integer                 fh_in;
    integer                 fh_tw;
    integer                 fh_out;
    integer                 code;
    integer                 idx;
    integer                 skip_idx;
    reg      [15:0]         input_hex_word;
    reg      [31:0]         twiddle_hex_word;

    fft1024_top u_fft1024_top (
        .clk        (clk),
        .rst_n      (rst_n),
        .start      (start),
        .busy       (busy),
        .done       (done),
        .in_we      (in_we),
        .in_addr    (in_addr),
        .in_wdata   (in_wdata),
        .in_rdata   (in_rdata),
        .tw_we      (tw_we),
        .tw_addr    (tw_addr),
        .tw_re_wdata(tw_re_wdata),
        .tw_im_wdata(tw_im_wdata),
        .tw_re_rdata(tw_re_rdata),
        .tw_im_rdata(tw_im_rdata),
        .out_addr   (out_addr),
        .out_re_rdata(out_re_rdata),
        .out_im_rdata(out_im_rdata)
    );

    always #(CLK_PERIOD/2) clk = ~clk;

    task load_input_block;
        begin
            fh_in = $fopen("input/input_q1_15_v3.hex", "r");
            if (fh_in == 0) begin
                $display("ERROR: cannot open input/input_q1_15_v3.hex");
                $finish;
            end

            for (skip_idx = 0; skip_idx < BLOCK_ID * FFT_N; skip_idx = skip_idx + 1) begin
                code = $fscanf(fh_in, "%h\n", input_hex_word);
                if (code != 1) begin
                    $display("ERROR: not enough samples when skipping to BLOCK_ID=%0d", BLOCK_ID);
                    $finish;
                end
            end

            for (idx = 0; idx < FFT_N; idx = idx + 1) begin
                code = $fscanf(fh_in, "%h\n", input_hex_word);
                if (code != 1) begin
                    $display("ERROR: not enough samples for input block %0d", BLOCK_ID);
                    $finish;
                end

                @(posedge clk);
                in_we    <= 1'b1;
                in_addr  <= idx[9:0];
                in_wdata <= input_hex_word;
            end

            @(posedge clk);
            in_we    <= 1'b0;
            in_addr  <= 10'd0;
            in_wdata <= 16'sd0;
            $fclose(fh_in);
        end
    endtask

    task load_twiddles;
        begin
            fh_tw = $fopen("input/twiddle_q15.hex", "r");
            if (fh_tw == 0) begin
                $display("ERROR: cannot open input/twiddle_q15.hex");
                $finish;
            end

            for (idx = 0; idx < TW_N; idx = idx + 1) begin
                code = $fscanf(fh_tw, "%h\n", twiddle_hex_word);
                if (code != 1) begin
                    $display("ERROR: twiddle_q15.hex should contain 512 lines of 8 hex digits");
                    $finish;
                end

                @(posedge clk);
                tw_we       <= 1'b1;
                tw_addr     <= idx[8:0];
                tw_re_wdata <= twiddle_hex_word[31:16];
                tw_im_wdata <= twiddle_hex_word[15:0];
            end

            @(posedge clk);
            tw_we       <= 1'b0;
            tw_addr     <= 9'd0;
            tw_re_wdata <= 16'sd0;
            tw_im_wdata <= 16'sd0;
            $fclose(fh_tw);
        end
    endtask

    task start_fft;
        begin
            @(posedge clk);
            start <= 1'b1;
            @(posedge clk);
            start <= 1'b0;
        end
    endtask

    task dump_outputs;
        begin
            fh_out = $fopen("hw_fft_block_q97.txt", "w");
            if (fh_out == 0) begin
                $display("ERROR: cannot create hw_fft_block_q97.txt");
                $finish;
            end

            for (idx = 0; idx < FFT_N; idx = idx + 1) begin
                @(posedge clk);
                out_addr <= idx[9:0];
                @(negedge clk);
                $fwrite(fh_out, "%0d %0d\n", $signed(out_re_rdata), $signed(out_im_rdata));
            end

            $fclose(fh_out);
        end
    endtask

    initial begin
        clk         = 1'b0;
        rst_n       = 1'b0;
        start       = 1'b0;
        in_we       = 1'b0;
        in_addr     = 10'd0;
        in_wdata    = 16'sd0;
        tw_we       = 1'b0;
        tw_addr     = 9'd0;
        tw_re_wdata = 16'sd0;
        tw_im_wdata = 16'sd0;
        out_addr    = 10'd0;

        repeat (5) @(posedge clk);
        rst_n = 1'b1;

        load_twiddles;
        load_input_block;
        start_fft;

        wait (done == 1'b1);
        dump_outputs;

        $display("FFT simulation finished for block %0d", BLOCK_ID);
        $finish;
    end
endmodule
