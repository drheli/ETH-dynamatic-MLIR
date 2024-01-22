#!/bin/bash

source "$1"/tools/dynamatic/scripts/utils.sh

# ============================================================================ #
# Variable definitions
# ============================================================================ #

# Script arguments
DYNAMATIC_DIR=$1
LEGACY_DIR=$2
SRC_DIR=$3
OUTPUT_DIR=$4
KERNEL_NAME=$5

# Generated directories/files
SIM_DIR="$OUTPUT_DIR/sim"
C_SRC_DIR="$SIM_DIR/C_SRC"
C_OUT_DIR="$SIM_DIR/C_OUT"
VHDL_SRC_DIR="$SIM_DIR/VHDL_SRC"
VHDL_OUT_DIR="$SIM_DIR/VHDL_OUT"
INPUT_VECTORS_DIR="$SIM_DIR/INPUT_VECTORS"
HLS_VERIFY_DIR="$SIM_DIR/HLS_VERIFY"

# Shortcuts
COMP_DIR="$OUTPUT_DIR/comp"
HLS_VERIFIER="$DYNAMATIC_DIR/bin/hls-verifier"
RESOURCE_DIR="$DYNAMATIC_DIR/tools/hls-verifier/resources"

# ============================================================================ #
# Simulation flow
# ============================================================================ #

# Reset simulation directory
rm -rf "$SIM_DIR" && mkdir -p "$SIM_DIR"

# Create simulation directories
mkdir -p "$C_SRC_DIR" "$C_OUT_DIR" "$VHDL_SRC_DIR" "$VHDL_OUT_DIR" \
    "$INPUT_VECTORS_DIR" "$HLS_VERIFY_DIR"

# Copy integration header to a C source subdirectory so that its relative path
# is correct with respect to the source file containing the kernel 
DYN_INCLUDE_DIR="$C_SRC_DIR/dynamatic"
mkdir "$DYN_INCLUDE_DIR"
cp "$DYNAMATIC_DIR/include/dynamatic/Integration.h" "$DYN_INCLUDE_DIR"

# Copy VHDL module and VHDL components to dedicated folder
cp "$COMP_DIR/$KERNEL_NAME.vhd" "$VHDL_SRC_DIR"
cp "$COMP_DIR/"LSQ*.v "$VHDL_SRC_DIR" 2> /dev/null
cp "$LEGACY_DIR"/components/*.vhd "$VHDL_SRC_DIR"

# Copy sources to dedicated folder
cp "$SRC_DIR/$KERNEL_NAME.c" "$C_SRC_DIR" 
cp "$SRC_DIR/$KERNEL_NAME.h" "$C_SRC_DIR"

# Simulate and verify design
echo_info "Launching Modelsim simulation"
cd "$HLS_VERIFY_DIR"
"$HLS_VERIFIER" cover -aw32 "$RESOURCE_DIR" "../C_SRC/$KERNEL_NAME.c" \
  "../C_SRC/$KERNEL_NAME.c" "$KERNEL_NAME" \
  > "../report.txt"
exit_on_fail "Simulation failed" "Simulation succeeded"
