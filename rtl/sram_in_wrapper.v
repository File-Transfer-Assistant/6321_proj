`timescale 1ns/1ps
`define DELAY #1

module sram_in_wrapper #(
    parameter DW = 16,
    parameter AW = 10
) (
    input               clk,
    input               cen,
    input               gwen,
    input  [AW-1:0]     addr,
    input  [DW-1:0]     din,
    output [DW-1:0]     dout
);

    wire             cen_delayed;
    wire             gwen_delayed;
    wire [AW-1:0]    addr_delayed;
    wire [DW-1:0]    din_delayed;

    assign `DELAY cen_delayed  = cen;
    assign `DELAY gwen_delayed = gwen;
    assign `DELAY addr_delayed = addr;
    assign `DELAY din_delayed  = din;

    sram_in sram_in_inst (
        .Q    (dout),
        .CLK  (clk),
        .CEN  (cen_delayed),
        .WEN  (2'b00),
        .A    (addr_delayed),
        .D    (din_delayed),
        .EMA  (3'b000),
        .GWEN (gwen_delayed),
        .RETN (1'b1)
    );

endmodule
