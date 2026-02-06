vsim E
restart -f
# Run Init time (Time needed to put the system in a consistent state, but that you don't want to measure. For example reset time, operand read, etc)
run 20 ns
vcd add -file LadnerFischer.vcd -r /e/uut/* 
# Run VCD time, depending on how long is the period you want to run your power analysis upon
run 200ns
# Closes vcd file
vcd flush LadnerFischer.vcd
vcd2saif -input LadnerFischer.vcd -output LadnerFischer.vcd.saif 
