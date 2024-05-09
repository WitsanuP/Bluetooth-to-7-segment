module top
(
    input clk,
    input rst_n,


    output reg [0:6] leds
);

localparam WAIT_TIME = 13500000;
//localparam WAIT_TIME = 135;

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

reg [5:0] ledCounter;
reg [23:0] clockCounter;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)begin
        ledCounter   <= 0;
        clockCounter <= 0;
	leds         <= 0;
    end 
    else begin      
        // clockCounter filpflop      
        if(clockCounter == WAIT_TIME)begin
		if(ledCounter == 9)begin
			ledCounter <= 0;
		end else begin
			ledCounter <= ledCounter + 1;
		end 
            clockCounter <= 0;
        end else begin
            clockCounter <= clockCounter + 1;
        end

        // output multiplexer + output flipflop
        case (ledCounter)
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

        // if(ledCounter == 10)begin
        //     ledCounter <= 0;
        // end
        // if(ledCounter == 0)begin
        //     leds = _0;
            
        // end
        // else if(ledCounter == 1)begin
        //     leds = _1;
            
        // end
        // if(ledCounter == 2)begin
        //     leds = _2;
            
        // end
        // if(ledCounter == 3)begin
        //     leds = _3;
            
        // end
        // if(ledCounter == 4)begin
        //     leds = _4;
            
        // end
        // if(ledCounter == 5)begin
        //     leds = _5;
            
        // end
        // if(ledCounter == 6)begin
        //     leds = _6;
            
        // end
        // if(ledCounter == 7)begin
        //     leds = _7;
            
        // end
        // if(ledCounter == 8)begin
        //     leds = _8;
            
        // end
        // if(ledCounter == 9)begin
        //     leds = _9;
            
        // end
        
    end
end


endmodule