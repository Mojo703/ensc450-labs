vsim tb_Adder
add wave -radix hex {/tb_Adder/A} {/tb_Adder/B} {/tb_Adder/S}
add wave -radix bin {/tb_Adder/clk} {/tb_Adder/Cin} {/tb_Adder/Cout} {/tb_Adder/Ovfl}
restart -f ; run 300 ns