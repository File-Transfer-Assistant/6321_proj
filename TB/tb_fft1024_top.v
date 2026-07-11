`timescale 1ns/1ps

module tb_fft1024_top;
    localparam N = 1024;
    localparam NUM_BLOCKS = 10;
    localparam TOTAL_SAMPLES = N * NUM_BLOCKS;

    reg clk;
    reg rst_n;
    reg start;
    reg in_we;
    reg [9:0] in_addr;
    reg signed [15:0] in_re;
    reg signed [15:0] in_im;
    reg [9:0] out_addr;
    wire signed [15:0] out_re;
    wire signed [15:0] out_im;
    wire busy;
    wire done;

    reg [15:0] input_mem [0:TOTAL_SAMPLES-1];
    reg [31:0] twiddle_mem [0:511];
    integer block_idx;
    integer sample_idx;
    integer row;
    integer col;
    integer fd;

    fft1024_top dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .in_we(in_we),
        .in_addr(in_addr),
        .in_re(in_re),
        .in_im(in_im),
        .out_addr(out_addr),
        .out_re(out_re),
        .out_im(out_im),
        .busy(busy),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
	$dumpfile("fft1024_top.vcd");
	$dumpvars(1, dut);
        clk = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        in_we = 1'b0;
        in_addr = 10'd0;
        in_re = 16'sd0;
        in_im = 16'sd0;
        out_addr = 10'd0;

        $readmemh("../../input/input_q1_15_v3.hex", input_mem);
        $readmemh("../../input/twiddle_q15.hex", twiddle_mem);

        for (row = 0; row < 32; row = row + 1) begin
            dut.u_twiddle_mem.sram_twiddle_inst.mem[row] = {512{1'b0}};
            for (col = 0; col < 16; col = col + 1) begin
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][496 + col] = twiddle_mem[row * 16 + col][31];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][480 + col] = twiddle_mem[row * 16 + col][30];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][464 + col] = twiddle_mem[row * 16 + col][29];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][448 + col] = twiddle_mem[row * 16 + col][28];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][432 + col] = twiddle_mem[row * 16 + col][27];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][416 + col] = twiddle_mem[row * 16 + col][26];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][400 + col] = twiddle_mem[row * 16 + col][25];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][384 + col] = twiddle_mem[row * 16 + col][24];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][368 + col] = twiddle_mem[row * 16 + col][23];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][352 + col] = twiddle_mem[row * 16 + col][22];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][336 + col] = twiddle_mem[row * 16 + col][21];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][320 + col] = twiddle_mem[row * 16 + col][20];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][304 + col] = twiddle_mem[row * 16 + col][19];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][288 + col] = twiddle_mem[row * 16 + col][18];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][272 + col] = twiddle_mem[row * 16 + col][17];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][256 + col] = twiddle_mem[row * 16 + col][16];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][240 + col] = twiddle_mem[row * 16 + col][15];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][224 + col] = twiddle_mem[row * 16 + col][14];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][208 + col] = twiddle_mem[row * 16 + col][13];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][192 + col] = twiddle_mem[row * 16 + col][12];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][176 + col] = twiddle_mem[row * 16 + col][11];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][160 + col] = twiddle_mem[row * 16 + col][10];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][144 + col] = twiddle_mem[row * 16 + col][9];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][128 + col] = twiddle_mem[row * 16 + col][8];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][112 + col] = twiddle_mem[row * 16 + col][7];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][96 + col]  = twiddle_mem[row * 16 + col][6];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][80 + col]  = twiddle_mem[row * 16 + col][5];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][64 + col]  = twiddle_mem[row * 16 + col][4];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][48 + col]  = twiddle_mem[row * 16 + col][3];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][32 + col]  = twiddle_mem[row * 16 + col][2];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][16 + col]  = twiddle_mem[row * 16 + col][1];
                dut.u_twiddle_mem.sram_twiddle_inst.mem[row][0 + col]   = twiddle_mem[row * 16 + col][0];
            end
        end

        repeat (5) @(negedge clk);
        #1 rst_n = 1'b1;
        @(posedge clk);

        fd = $fopen("results/fft1024_top_dc_output_q97.txt", "w");
        if (fd == 0) begin
            $display("ERROR: cannot open output file");
            $finish;
        end

        for (block_idx = 0; block_idx < NUM_BLOCKS; block_idx = block_idx + 1) begin
            for (sample_idx = 0; sample_idx < N; sample_idx = sample_idx + 1) begin
                in_we = 1'b1;
                in_addr = sample_idx[9:0];
                in_re = input_mem[block_idx * N + sample_idx];
                in_im = 16'sd0;
                @(posedge clk);
            end

            in_we = 1'b0;
            in_addr = 10'd0;
            in_re = 16'sd0;
            in_im = 16'sd0;
            @(posedge clk);

            start = 1'b1;
            @(posedge clk);
            start = 1'b0;

            wait(done == 1'b1);
            @(posedge clk);

            out_addr = 10'd0;
            @(posedge clk);

            for (sample_idx = 0; sample_idx < N; sample_idx = sample_idx + 1) begin
                out_addr = sample_idx[9:0];
                @(posedge clk);
                @(posedge clk);
                #1;
                $fdisplay(fd, "%0d %0d", $signed(out_re), $signed(out_im));
            end
        end

        $fclose(fd);
        $display("TB done. Wrote results/fft1024_top_dc_output_q97.txt");
        $finish;
    end
endmodule
