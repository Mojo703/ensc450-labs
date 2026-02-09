vsim tb_Adder
add wave -radix bin {/tb_Adder/clk} 
add wave -radix hex {/tb_Adder/A} {/tb_Adder/B} {/tb_Adder/S}
add wave -radix bin {/tb_Adder/Cin} {/tb_Adder/Cout} {/tb_Adder/Ovfl}
add wave -radix hex {/tb_Adder/DUT/A} {/tb_Adder/DUT/B} {/tb_Adder/DUT/S}
restart -f ; run 100000 ns