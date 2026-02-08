# fcampi@sfu.ca Sept 2013
# Post-Layout Power estimation with parasitics from Cadence & multiple SAIF files

set search_path "/CMC/setups/ensc450/SOCLAB/LIBRARIES/NangateOpenCellLibrary_PDKv1_3_v2010_12/Front_End/DB"

set target_library "NangateOpenCellLibrary_slow.db"
set synthetic_library [list dw_foundation.sldb]
set link_library [concat $target_library $synthetic_library]

# Post-layout netlist
read_verilog -netlist ../syn_045/results/Adder.ref.v
current_design Adder
#read_parasitics ../BE_045/results/Adder.spef

# SAIF files from simulation
set VCDFILES {../sim/Adder.vcd.saif}

foreach file $VCDFILES {
    read_saif -input $file -instance tb_Adder/DUT
    report_power -analysis_effort high
}

#exit