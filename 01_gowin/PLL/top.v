module top (
    input clk,
    input reset,
    output wire clk_30
);

    Gowin_rPLL myPll(
        .clkout     (clk_30)    //output clkout
    ,   .clkin      (clk)       //input clkin
    );



endmodule
