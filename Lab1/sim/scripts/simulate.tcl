vsim E
add wave -radix hex {/e/A} {/e/B} {/e/S}
add wave -radix bin {/e/Cin} {/e/Cout} {/e/Ovfl}
restart -f ; run 300 ns