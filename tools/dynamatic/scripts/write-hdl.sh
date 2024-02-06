#!/bin/bash

source "$1"/tools/dynamatic/scripts/utils.sh

# ============================================================================ #
# Variable definitions
# ============================================================================ #

# Script arguments
DYNAMATIC_DIR=$1
OUTPUT_DIR=$2
KERNEL_NAME=$3

COMP_DIR="$OUTPUT_DIR/comp"
LSQ_JAR="$DYNAMATIC_DIR/data/vhdl/lsq.jar"
LSQ_JAR_URL="https://github.com/lana555/dynamatic/raw/52eec367775b4072160e764d7ae6161f3964cf3a/chisel_lsq/jar/lsq.jar"

# ============================================================================ #
# HDL writing flow
# ============================================================================ #

# Convert DOT graph to VHDL
cd "$COMP_DIR"
"$DYNAMATIC_DIR/bin/export-vhdl" $KERNEL_NAME "$COMP_DIR/$KERNEL_NAME.dot" \
  "$COMP_DIR"
exit_on_fail "Failed to convert DOT to VHDL" "Converted DOT to VHDL"
cd - > /dev/null

# Generate LSQs
for lsq_config in $COMP_DIR/lsq*_config.json; do
  # Skip non-existent files (the loop will iterate over
  # $COMP_DIR/lsq*_config.json if there are no LSQs)
  if [ ! -e "$lsq_config" ]; then continue; fi

  # If the Chisel-based LSQ generator is not present, download it from legacy
  # Dynamatic's public repository 
  if [ ! -e "$LSQ_JAR" ]; then 
    echo_info "Downloading LSQ generator from GitHub..." 
    curl -o "$LSQ_JAR" -L "$LSQ_JAR_URL"
    exit_on_fail "Failed to download LSQ generator" "Downloaded LSQ generator"
  fi

  # Run the LSQ generator
  java -jar -Xmx7G "$LSQ_JAR" --target-dir "$COMP_DIR" --spec-file \
    "$lsq_config" > /dev/null
  exit_on_fail "Failed to generate LSQs"
done

echo_info "HDL generation succeeded"
