#!/bin/bash

# List of clock periods in ns
PERIODS=("10" "9" "8" "7" "6" "5.5" "5" "4.5" "4")

BASE_RESULT_DIR="results_sweep"
mkdir -p "$BASE_RESULT_DIR"

for P in "${PERIODS[@]}"
do
    echo "======================================="
    echo "Running synthesis for period = $P ns"
    echo "======================================="

    # Clean old results folder to avoid mixing files
    rm -rf results
    mkdir results

    # Create per-frequency results folder
    mkdir -p "${BASE_RESULT_DIR}/${P}"

    # Run synthesis with period override
    dc_shell-xg-t -x "set CLK_PERIOD $P; source scripts/synth.tcl" \
        > "${BASE_RESULT_DIR}/${P}/synth.log"

    # Run power estimation (uses existing VCD)
    dc_shell-xg-t -f scripts/power_estimate.tcl \
        > "${BASE_RESULT_DIR}/${P}/power_estimate.log"

    # Move entire results folder contents into it
    mv results/* "${BASE_RESULT_DIR}/${P}/"

done

echo "Sweep complete."