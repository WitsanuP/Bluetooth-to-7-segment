module top (
    input             clk,
    input             reset_n,
    input             uart_rx,
    output wire       uart_tx,
    output wire [7:0] leds
);
    wire clk_30MHz;

    reg r_sync_0;
    reg r_sync_1;

    Gowin_rPLL myPll(
        .clkout     (clk_30MHz)    //output clkout
    ,   .clkin      (clk)       //input clkin
    );

    //sys uart
    always @(posedge clk_30MHz or negedge reset_n) begin
        if(~reset_n)begin
            r_sync_0 <= 1;
        end else begin
            r_sync_0 <= uart_rx;
        end
    end

    always @(posedge clk_30MHz or negedge reset_n) begin
        if(~reset_n)begin
            r_sync_1 <= 1;
        end else begin
            r_sync_1 <= r_sync_0;
        end
    end

    uart uart_m(
        .clk     /*  input */ (clk_30MHz)
    ,   .uart_rx /*  input */ (r_sync_1)
    ,   .reset_n /*  input */ (reset_n)
    ,   .btn1    /*  input */ ()
    ,   .uart_tx /* output */ ()
    ,   .leds    /* output */ (leds)

    );


endmodule
