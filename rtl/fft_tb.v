`timescale 1ns / 1ps

module fft_tb();

    reg clk;
    reg rst_n;
    reg start;
    reg [15:0] data_in_re;
    
    wire [15:0] data_out_re;
    wire [15:0] data_out_im;
    wire        data_out_valid;
    wire        done;

    // 例化顶层
    fft_processor_top uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .data_in_re(data_in_re),
        .data_out_re(data_out_re),
        .data_out_im(data_out_im),
        .data_out_valid(data_out_valid),
        .done(done)
    );

    // 时钟生成 (200MHz)
    always #2.5 clk = ~clk;

    // 存储你的 10240 个输入数据
    reg [15:0] input_mem [0:10239];
    integer i, file_out;

    initial begin
        // 读取外部 Hex 数据
        $readmemh("input_q1_15_v3.hex", input_mem);
        file_out = $fopen("hw_output_frame0.txt", "w");
        
        // 初始化信号
        clk = 0;
        rst_n = 0;
        start = 0;
        data_in_re = 0;

        // 系统复位
        #20;
        rst_n = 1;
        #10;
        
        // 发送 Start 信号启动第一帧
        start = 1;
        #5;
        start = 0;

        // 连续送入 1024 个数据点 (模拟 LOAD 状态)
        for (i = 0; i < 1024; i = i + 1) begin
            data_in_re = input_mem[i];
            #5; // 每个时钟周期喂一个数据
        end
        data_in_re = 0;

        // 等待整个 FFT 计算完成
        wait(done == 1);
        $display("✅ FFT 硬件运算已完成!");
        
        $fclose(file_out);
        $finish;
    end

    // 捕捉输出数据并写入 TXT，格式与 MATLAB 对齐
    integer out_cnt = 0;
    always @(posedge clk) begin
        if (data_out_valid) begin
            // 写入格式： 索引  实部(hex) 虚部(hex) 实部(带符号十进制) 虚部(带符号十进制)
            $fwrite(file_out, "%d\t%h\t%h\t%d\t%d\n", 
                    out_cnt, data_out_re, data_out_im, $signed(data_out_re), $signed(data_out_im));
            out_cnt = out_cnt + 1;
        end
    end

endmodule
