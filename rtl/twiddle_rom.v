`timescale 1ns / 1ps

module twiddle_rom (
    input  wire        clk,
    input  wire [8:0]  addr,
    output reg  [31:0] dout
);
    // 512 深度，32-bit位宽 (高16位实部，低16位虚部)
    reg [31:0] rom [0:511];

    initial begin
        // 读取指定的旋转因子文件
        $readmemh("twiddle_q15.hex", rom);
    end

    always @(posedge clk) begin
        dout <= rom[addr];
    end
endmodule
