vlog    -file ./0_filelist/rtl.f \
        -file ./0_filelist/tb.f

vsim work.testbench -L gowin

add wave -position insertpoint /testbench/dut/uart_m/uart_tx
add wave -position insertpoint /testbench/dut/uart_m/leds
add wave -position insertpoint /testbench/dut/uart_m/btn1
add wave -position insertpoint /testbench/dut/uart_m/clk
add wave -position insertpoint /testbench/dut/uart_m/uart_rx
add wave -position insertpoint /testbench/dut/uart_m/reset_n
add wave -position end  sim:/testbench/dut/uart_m/dataIn
add wave -position insertpoint sim:/testbench/dut/uart_m/rxCounter
add wave -position insertpoint sim:/testbench/dut/uart_m/rxState

restart -force

run -all

wave zoom full