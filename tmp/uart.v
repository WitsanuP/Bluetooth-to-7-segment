module top
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
    
)
(   
    input clk,
    input uart_rx,
    input reset_n,
    input btn1,
    output uart_tx,
    output reg [7:0] leds = 0
    
);

// localparam _0 = 7'b011_1111;
// localparam _1 = 7'b000_1001;
// localparam _2 = 7'b101_1110;
// localparam _3 = 7'b101_1011;
// localparam _4 = 7'b110_1001;
// localparam _5 = 7'b111_0011;
// localparam _6 = 7'b111_0111;
// localparam _7 = 7'b001_1001;
// localparam _8 = 7'b111_1111;
// localparam _9 = 7'b111_1011;

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

// enum reg[2:0]{
//     RX_STATE_IDLE       = 0,
//     RX_STATE_START_BIT  = 1,
//     RX_STATE_READ_WAIT  = 2,
//     RX_STATE_READ       = 3,
//     RX_STATE_STOP_BIT   = 4
// } e_rxState = RX_STATE_IDLE;

// reg [2:0] rxState = e_rxState;

localparam RX_STATE_IDLE = 0;
localparam RX_STATE_START_BIT = 1;
localparam RX_STATE_READ_WAIT = 2;
localparam RX_STATE_READ = 3;
localparam RX_STATE_STOP_BIT = 4;
reg [2:0] rxState = RX_STATE_IDLE;

reg [12:0] rxCounter = 0;
reg [7:0] dataIn = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;


always @(posedge clk ) begin
 
    case (rxState)
        RX_STATE_IDLE: begin
            //wait for bit ready when uart_rx==0, start resive data
            if (uart_rx == 0) begin
                rxState <= RX_STATE_START_BIT;
                rxCounter <= 1;
                rxBitNumber <= 0;
                byteReady <= 0;
                
            end
        end 
        RX_STATE_START_BIT: begin
            if (rxCounter == HALF_DELAY_WAIT) begin
                rxState <= RX_STATE_READ_WAIT;
                rxCounter <= 1;
            end else 
                rxCounter <= rxCounter + 1;
        end
        RX_STATE_READ_WAIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_READ;
            end
        end
        RX_STATE_READ: begin
            rxCounter <= 1;
            dataIn <= {uart_rx, dataIn[7:1]};
            rxBitNumber <= rxBitNumber + 1;
            if (rxBitNumber == 3'b111)
                rxState <= RX_STATE_STOP_BIT;
            else
                rxState <= RX_STATE_READ_WAIT;
        end
        RX_STATE_STOP_BIT: begin
            rxCounter <= rxCounter + 1;
            if ((rxCounter + 1) == DELAY_FRAMES) begin
                rxState <= RX_STATE_IDLE;
                rxCounter <= 0;
                byteReady <= 1;
                leds <= dataIn;
            end
        end
    endcase
end




endmodule

// // setting UART port on linux
// setting
// // stty -F /dev/ttyUSB1 115200
// // stty -F /dev/ttyUSB1 crtscts //setting RTS/CTS
// view setting
// // stty -a -F /dev/ttymxc2

// echo -n -e '\x0' > /dev/ttyUSB1
// cat /dev/ttyUSB1
