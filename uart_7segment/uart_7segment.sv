module top
#(
    parameter DELAY_FRAMES = 234 // 27,000,000 (27Mhz) / 115200 Baud rate
)
(
    input clk,
    input reset_n,
    input uart_rx,
    output uart_tx,
    output reg [6:0] leds,
    input btn1
);

localparam _0 = 7'b011_1111;
localparam _1 = 7'b0001001;
localparam _2 = 7'b1011110;
localparam _3 = 7'b1011011;
localparam _4 = 7'b1101001;
localparam _5 = 7'b1110011;
localparam _6 = 7'b1110111;
localparam _7 = 7'b0011001;
localparam _8 = 7'b111_1111;
localparam _9 = 7'b1111011;

localparam HALF_DELAY_WAIT = (DELAY_FRAMES / 2);

enum reg [2:0] {
    RX_STATE_IDLE      = 0
,   RX_STATE_START_BIT = 1
,   RX_STATE_READ_WAIT = 2
,   RX_STATE_READ      = 3
,   RX_STATE_STOP_BIT  = 4
} e_rx_state;

e_rx_state rxState;
// reg [3:0] rxState = 0;
reg [12:0] rxCounter = 0;
reg [7:0] dataIn = 0;
reg [2:0] rxBitNumber = 0;
reg byteReady = 0;
// localparam RX_STATE_IDLE = 0;
// localparam RX_STATE_START_BIT = 1;
// localparam RX_STATE_READ_WAIT = 2;
// localparam RX_STATE_READ = 3;
// localparam RX_STATE_STOP_BIT = 5;

always @(posedge clk or negedge reset_n) begin
    if(~reset_n)begin 
        uart_rx     <= 1;
        rxState     <= RX_STATE_IDLE;
        rxCounter   <= 0;
        rxBitNumber <= 0;
        byteReady   <= 0;
    end
    case (rxState)
        RX_STATE_IDLE: begin
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
            end
        end
    endcase
end

always @(posedge clk or negedge reset_n)  begin
    if (~reset_n)
      leds <= 0;
    else if (byteReady) begin
        //led <= ~dataIn[5:0];
        case (dataIn)
            0       :   leds <= _0;
            1       :   leds <= _1; 
            2       :   leds <= _2;
            3       :   leds <= _3;
            4       :   leds <= _4;
            5       :   leds <= _5;
            6       :   leds <= _6; 
            7       :   leds <= _7;
            8       :   leds <= _8;
            9       :   leds <= _9;
            default :   leds <= _5;
        endcase
    end
end



endmodule