
module sysctrl(
    output wire clock
,   output wire reset_n
);

reg r_clock = 0;
reg r_reset_n = 0;

always #(37037/2) r_clock <= !r_clock;

initial begin
    repeat(10)@(posedge r_clock);
    r_reset_n <= 1;

    repeat(30_000_000)@(posedge r_clock);
    $display("check : %f", (37037/2));
    $stop;
end

assign clock = r_clock;
assign reset_n = r_reset_n;

endmodule