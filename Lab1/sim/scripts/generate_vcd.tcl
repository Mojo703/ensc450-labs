vsim work.tb_Adder
restart -f

# Run init time (reset, setup, etc. – not measured)
run 20 ns

# Dump only the DUT for power analysis
vcd add -file Adder.vcd -r /tb_Adder/DUT/*

# Run VCD capture window
run 200 ns

# Close and convert VCD
vcd flush Adder.vcd
vcd2saif -input Adder.vcd -output Adder.vcd.saif -instance /tb_adder/DUT