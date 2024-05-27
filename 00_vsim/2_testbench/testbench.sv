
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

    // ----------- device under test -----------
    top dut(
        .clk     /*  input       */ (clk      )
    ,   .uart_rx /*  input       */ (t_uart_tx)
    ,   .reset_n /*  input       */ (t_reset_n)
    ,   .uart_tx ()
    ,   .leds    ()
    
    );

    // ----------- system signal generator-----------
    always #(37037/2) clk = ~clk;

    // ----------- tasks -----------
    task write_data(input [7:0] wdata);
        uart_ez_state <= start;
        t_uart_tx     <= 0;
        repeat(234)@(posedge clk);

        for (uart_bit = 7; uart_bit >= 0; uart_bit--) begin
            uart_ez_state <= data;
            t_uart_tx     <= wdata[uart_bit];
            repeat(234)@(posedge clk);
        end

        uart_ez_state <= stop;
        t_uart_tx     <= 1;
        repeat(234)@(posedge clk);

        uart_ez_state <= idle;
        uart_bit      <= 7;
    endtask : write_data

    // ----------- test scenarios -----------
    initial begin
        $display("Starting UART RX");
        repeat(15)@(posedge clk);
        t_reset_n <= 1;

        // t_random_value = $urandom_range(0,255);
        // write_data(t_random_value);
        // t_random_value = 0;
        repeat(10_000)@(posedge clk);
        t_reset_n <= 0;
        repeat(100)@(posedge clk);
        t_reset_n <= 1;
        repeat(10_500)@(posedge clk);
        write_data(8'haa);
        repeat(500)@(posedge clk);
        t_reset_n <= 0;
        repeat(100)@(posedge clk);
        t_reset_n <= 1;
        repeat(20_000)@(posedge clk);
        write_data(8'hA5);
        repeat(1000)@(posedge clk);
        write_data(8'h66);
        // #4 btn=0;
        // #4 btn=1;
        repeat(1000)@(posedge clk);
        $stop;
    end

    // ----------- dumping wave -----------
    initial begin
        $dumpfile("uart.vcd");
        $dumpvars(0,testbench);
        
    end
    
endmodule