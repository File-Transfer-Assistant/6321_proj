`timescale 1ns / 1ps

module tb_fft();

    localparam integer FFT_LEN = 1024;
    localparam integer NUM_FRAMES = 10;
    localparam integer TWIDDLE_LEN = 512;

    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] data_in_re;

    reg        tb_io_mode;
    reg        tb_skip_load;
    reg        tb_sram_we;
    reg [9:0]  tb_sram_addr;
    reg [31:0] tb_sram_din;
    reg        tb_twiddle_we;
    reg [8:0]  tb_twiddle_addr;
    reg [31:0] tb_twiddle_din;

    wire [31:0] tb_sram_dout;
    wire [31:0] tb_twiddle_dout;
    wire [15:0] data_out_re;
    wire [15:0] data_out_im;
    wire        data_out_valid;
    wire        done;
    wire [3:0]  dbg_stage;
    wire        dbg_stage_done;

    reg [15:0] input_mem [0:FFT_LEN*NUM_FRAMES-1];
    reg [31:0] twiddle_mem [0:TWIDDLE_LEN-1];

    integer frame_idx;
    integer file_out;
    integer aligned_file_out;

    function [9:0] bit_reverse_10;
        input [9:0] in;
        begin
            bit_reverse_10 = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7], in[8], in[9]};
        end
    endfunction

    fft_processor_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in_re(data_in_re),
        .tb_io_mode(tb_io_mode),
        .tb_skip_load(tb_skip_load),
        .tb_sram_we(tb_sram_we),
        .tb_sram_addr(tb_sram_addr),
        .tb_sram_din(tb_sram_din),
        .tb_twiddle_we(tb_twiddle_we),
        .tb_twiddle_addr(tb_twiddle_addr),
        .tb_twiddle_din(tb_twiddle_din),
        .tb_sram_dout(tb_sram_dout),
        .tb_twiddle_dout(tb_twiddle_dout),
        .data_out_re(data_out_re),
        .data_out_im(data_out_im),
        .data_out_valid(data_out_valid),
        .done(done),
        .dbg_stage(dbg_stage),
        .dbg_stage_done(dbg_stage_done)
    );

    always #2.5 clk = ~clk;

    task write_sram_row;
        input [9:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            tb_sram_addr <= addr;
            tb_sram_din <= data;
            tb_sram_we <= 1'b1;
            @(negedge clk);
            tb_sram_we <= 1'b0;
        end
    endtask

    task write_twiddle_row;
        input [8:0] addr;
        input [31:0] data;
        begin
            @(negedge clk);
            tb_twiddle_addr <= addr;
            tb_twiddle_din <= data;
            tb_twiddle_we <= 1'b1;
            @(negedge clk);
            tb_twiddle_we <= 1'b0;
        end
    endtask

    task read_sram_row;
        input [9:0] addr;
        output [31:0] data;
        begin
            @(negedge clk);
            tb_sram_addr <= addr;
            tb_sram_we <= 1'b0;
            @(posedge clk);
            @(posedge clk);
            data = tb_sram_dout;
        end
    endtask

    task load_twiddle_rom;
        integer idx;
        begin
            for (idx = 0; idx < TWIDDLE_LEN; idx = idx + 1) begin
                write_twiddle_row(idx[8:0], twiddle_mem[idx]);
            end
        end
    endtask

    task load_input_frame;
        input integer frame_number;
        integer idx;
        begin
            for (idx = 0; idx < FFT_LEN; idx = idx + 1) begin
                write_sram_row(idx[9:0], {input_mem[frame_number*FFT_LEN + idx], 16'd0});
            end
        end
    endtask

    task dump_output_frame;
        input integer frame_number;
        reg [31:0] sram_word;
        reg [8*64-1:0] file_name;
        reg [8*64-1:0] aligned_file_name;
        integer idx;
        integer signed re_int, im_int;
        real re_val, im_val;
        begin
            $sformat(file_name, "hw_output_frame%0d.txt", frame_number);
            $sformat(aligned_file_name, "hw_output_frame%0d_aligned.txt", frame_number);
            file_out = $fopen(file_name, "w");
            aligned_file_out = $fopen(aligned_file_name, "w");
            for (idx = 0; idx < FFT_LEN; idx = idx + 1) begin
                read_sram_row(idx[9:0], sram_word);
                $fwrite(file_out, "%0d\t%h\t%h\t%0d\t%0d\n",
                        idx, sram_word[31:16], sram_word[15:0],
                        $signed(sram_word[31:16]), $signed(sram_word[15:0]));
            end
            for (idx = 0; idx < FFT_LEN; idx = idx + 1) begin
                read_sram_row(bit_reverse_10(idx[9:0]), sram_word);
                re_int = $signed(sram_word[31:16]);
                im_int = $signed(sram_word[15:0]);
                re_val = ($itor(re_int) / 128.0) * 4.0;
                im_val = ($itor(im_int) / 128.0) * 4.0;
                $fwrite(aligned_file_out, "%0d\t%0.6f\t%0.6f\n", idx, re_val, im_val);
            end
            $fclose(file_out);
            $fclose(aligned_file_out);
        end
    endtask

    initial begin
        $dumpfile("tb_fft.vcd");
        $dumpvars(0, tb_fft);
    end

    initial begin
        $readmemh("input_q1_15_v3.hex", input_mem);
        $readmemh("twiddle_q15.hex", twiddle_mem);

        clk = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        data_in_re = 16'd0;
        tb_io_mode = 1'b1;
        tb_skip_load = 1'b1;
        tb_sram_we = 1'b0;
        tb_sram_addr = 10'd0;
        tb_sram_din = 32'd0;
        tb_twiddle_we = 1'b0;
        tb_twiddle_addr = 9'd0;
        tb_twiddle_din = 32'd0;
        frame_idx = 0;

        repeat (4) @(posedge clk);
        rst_n = 1'b1;

        load_twiddle_rom();

        for (frame_idx = 0; frame_idx < NUM_FRAMES; frame_idx = frame_idx + 1) begin
            load_input_frame(frame_idx);

            @(negedge clk);
            tb_io_mode <= 1'b0;
            start <= 1'b1;
            @(negedge clk);
            start <= 1'b0;

            wait(done == 1'b1);
            @(negedge clk);
            tb_io_mode <= 1'b1;

            dump_output_frame(frame_idx);
            $display("Completed frame %0d", frame_idx);
        end

        $display("Completed all %0d FFT frames", NUM_FRAMES);
        $finish;
    end

endmodule
