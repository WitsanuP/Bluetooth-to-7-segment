module testbench();
enum reg [1:0]{
    idle    = 0,
    start   = 1,
    data    = 2,
    stop    = 3
}uart_ez_state = idle;

    // ----------- registers -----------
    reg clk       = 0;
    reg uart_rx   = 1;
    reg t_reset_n = 1;
    reg btn       = 1;
    reg t_uart_tx = 1;
    reg [7:0] t_random_value = 0;
    // ----------- wires -----------
    wire       uart_tx;
    wire [5:0] led;
    integer uart_bit;

    // ----------- device under test -----------
    uart #(8'd8) u(
        .clk     /*  input       */ (clk      )
    ,   .uart_rx /*  input       */ (t_uart_tx)
    ,   .reset_n /*  input       */ (t_reset_n)
    ,   .btn1    /*  input       */ (btn      )
    ,   .uart_tx /* output       */ (         )
    ,   .leds    /* output [6:0] */ (         )
    );

    // ----------- system signal generator-----------
    always #1  clk = ~clk;

    // ----------- tasks -----------
    task write_data(input [7:0] wdata);
        uart_ez_state <= start;
        t_uart_tx     <= 0;
        #16;

        for (uart_bit = 7; uart_bit >= 0; uart_bit--) begin
            uart_ez_state <= data;
            t_uart_tx     <= wdata[uart_bit];
            #16;
        end

        uart_ez_state <= stop;
        t_uart_tx     <= 1;
        #16;

        uart_ez_state <= idle;
        uart_bit      <= 7;
    endtask : write_data

    // ----------- test scenarios -----------
    initial begin
    $display("Starting UART RX");
    $monitor("LED Value %b", led);
    #1000;

    // t_random_value = $urandom_range(0,255);
    // write_data(t_random_value);
    // t_random_value = 0;

    write_data(8'hA5);

    // #4 btn=0;
    // #4 btn=1;
    #1000 $stop;
    end

    // ----------- dumping wave -----------
    initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0,testbench);
    end
endmodule