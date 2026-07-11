`timescale 1ns/1ps
`define DELAY #1

module sram_work_wrapper #(
    parameter DW = 32,
    parameter AW = 10
) (
    input               clka,
    input               cena,
    input               gwena,
    input  [AW-1:0]     addra,
    input  [DW-1:0]     dina,
    output [DW-1:0]     douta,

    input               clkb,
    input               cenb,
    input               gwenb,
    input  [AW-1:0]     addrb,
    input  [DW-1:0]     dinb,
    output [DW-1:0]     doutb
);

    wire             cena_delayed;
    wire             gwena_delayed;
    wire [AW-1:0]    addra_delayed;
    wire [DW-1:0]    dina_delayed;
    wire             cenb_delayed;
    wire             gwenb_delayed;
    wire [AW-1:0]    addrb_delayed;
    wire [DW-1:0]    dinb_delayed;

    assign `DELAY cena_delayed  = cena;
    assign `DELAY gwena_delayed = gwena;
    assign `DELAY addra_delayed = addra;
    assign `DELAY dina_delayed  = dina;
    assign `DELAY cenb_delayed  = cenb;
    assign `DELAY gwenb_delayed = gwenb;
    assign `DELAY addrb_delayed = addrb;
    assign `DELAY dinb_delayed  = dinb;

    wire [31:0] qa;
    wire [31:0] qb;

    assign douta = qa[DW-1:0];
    assign doutb = qb[DW-1:0];

    sram_work sram_work_inst (
        .QA    (qa),
        .QB    (qb),
        .CLKA  (clka),
        .CENA  (cena_delayed),
        .WENA  (4'b0000),
        .AA    (addra_delayed),
        .DA    (dina_delayed),
        .CLKB  (clkb),
        .CENB  (cenb_delayed),
        .WENB  (4'b0000),
        .AB    (addrb_delayed),
        .DB    (dinb_delayed),
        .EMAA  (3'b000),
        .EMAB  (3'b000),
        .GWENA (gwena_delayed),
        .GWENB (gwenb_delayed),
        .RETN  (1'b1)
    );

endmodule
