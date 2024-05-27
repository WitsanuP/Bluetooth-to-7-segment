
`timescale 1ps/1ps

module testbench();
enum reg [1:0]{
    idle    = 0,
    start   = 1,
    data    = 2,
    stop    = 3
}uart_ez_state;

    // ----------- registers -----------
    reg clk       = 0;
    reg uart_rx   = 1;
    reg t_reset_n = 0;
    reg btn       = 1;
    reg t_uart_tx = 1;
    reg [7:0] t_leds ;
    
    reg [7:0] t_random_value = 0;
    // ----------- wires -----------
    wire       uart_tx;
    //wire [5:0] led;
    integer uart_bit;

    wire t_clk_30;

    // ----------- device under test -----------
    top dut(
        .clk     /*  input       */ (clk      )
    ,   .uart_rx /*  input       */ (t_uart_tx)
    ,   .reset_n /*  input       */ (t_reset_n)
    ,   .uart_tx ()
    ,   .leds    ()
    ,   .clk_30                     (t_clk_30)
    );

    // ----------- system signal generator-----------
    always #(37037/2) clk = ~clk;

    // ----------- tasks -----------
    task write_data(input [7:0] wdata,input string uart_mode = "start-stop");
        if(uart_mode=="start" | uart_mode=="start-stop")begin
            uart_ez_state <= start;
            t_uart_tx     <= 0;
            repeat(260)@(posedge t_clk_30);
        end

        for (uart_bit = 7; uart_bit >= 0; uart_bit--) begin
            uart_ez_state <= data;
            t_uart_tx     <= wdata[uart_bit];
            repeat(260)@(posedge t_clk_30);
        end
        if(uart_mode == "stop" | uart_mode=="start-stop")begin
            uart_ez_state <= stop;
            t_uart_tx     <= 1;
            repeat(260)@(posedge t_clk_30);
        end
        
        uart_ez_state <= idle;
        uart_bit      <= 7;
    endtask : write_data

    // ----------- test scenarios -----------
    initial begin
        $display("Starting UART RX");
        // t_random_value = $urandom_range(0,255);
        // write_data(t_random_value);
        // t_random_value = 0;
        repeat(100)@(posedge t_clk_30);
        t_reset_n <= 1;

        repeat(10_000)@(posedge t_clk_30);
        write_data(8'h13,"start");
        
        write_data(8'h50,"of");
        write_data(8'hB0,"stop");
        // #4 btn=0;
        // #4 btn=1;
        repeat(10000)@(posedge t_clk_30);
        $stop;
    end

    // ----------- dumping wave -----------
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0,testbench);
        
    end
    
endmodule