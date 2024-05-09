module testbennch ();
   
    wire w_clock;
    wire w_reset_n;

   sysctrl ins_sysctrl(
        .clock   /* [0:0] output */ (w_clock)
    ,   .reset_n /* [0:0] output */ (w_reset_n)
   );

    //seven_segment ins_seven_segment(
    //    .clock   /* [0:0] input */ (w_clock)
    //,   .reset_n /* [0:0] input */ (w_reset_n)
    //);

	top ins_top(
		.clk	(w_clock)
	,	.rst_n	(w_reset_n)
	,	.leds	()
	);

endmodule