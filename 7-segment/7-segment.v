module seven_segment (
    input clock
,   input reset_n
,   output reg [6:0] led
);

reg [24:0] r_counter_0;

always @(posedge clock or negedge reset_n) begin
    if(~reset_n)begin
        r_counter_0 <= 0;
    end else begin
        if(r_counter_0 == 27_000_747)begin
            r_counter_0 <= 27_000_747;
        end else begin
            r_counter_0 <= r_counter_0 + 1;
        end
    end
end

endmodule