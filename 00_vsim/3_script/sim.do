vlog    -file ./0_filelist/rtl.f \
        -file ./0_filelist/tb.f

vsim work.testbench -L gowin

add wave -position insertpoint sim:/testbench/clk
add wave -position insertpoint sim:/testbench/uart_rx

restart -force

run -all

wave zoom full