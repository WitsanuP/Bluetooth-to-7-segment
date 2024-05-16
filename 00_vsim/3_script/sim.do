vlog    -file ./0_filelist/rtl.f \
        -file ./0_filelist/tb.f

vsim work.testbench -L gowin

add wave -position insertpoint sim:/testbench/u/clk
add wave -position insertpoint sim:/testbench/u/uart_rx
add wave -position insertpoint sim:/testbench/u/reset_n
add wave -position insertpoint sim:/testbench/u/uart_tx

restart -force

run -all

wave zoom full