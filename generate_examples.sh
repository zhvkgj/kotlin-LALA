#!/bin/bash

set -e

out_dir="$(dirname "$0")/examples/"
mkdir -p "$out_dir"

COLOR_YELLOW="\033[1;33m"
COLOR_BLUE="\033[1;36m"
COLOR_NONE="\033[0m"

function print_step {
  printf "${COLOR_YELLOW}======[ ${1} ]======${COLOR_NONE}\n"
}

print_step "Kotlin"
"$(dirname "$0")/out/run.sh" kotlin --seed 0 --count 10 \
  --out "$out_dir/prog_#{SEED}.kt"
