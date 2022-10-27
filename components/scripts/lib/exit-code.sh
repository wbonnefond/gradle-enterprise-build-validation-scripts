#!/usr/bin/env bash

SUCCESS=0
INVALID_INPUT=1
UNEXPECTED_ERROR=2
BUILD_FAILED=3
BUILD_NOT_FULLY_CACHEABLE=4

readonly SUCCESS INVALID_INPUT UNEXPECTED_ERROR BUILD_FAILED BUILD_NOT_FULLY_CACHEABLE

# Overrides the die() function loaded from the argbash-generated parsing libs
die() {
  local _ret="${2:-${UNEXPECTED_ERROR}}"
  printf "${ERROR_COLOR}%s${RESTORE}\n" "$1"
  if [[ "${_PRINT_HELP:-no}" == "yes" ]]; then
    print_bl
    print_help >&2
  fi
  exit "${_ret}"
}

exit_with_return_code() {
  if [[ " ${build_outcomes[*]} " =~ " FAILED " ]]; then
    exit "${BUILD_FAILED}"
  fi

  # shellcheck disable=SC2034 # not all of the scripts have the --fail-if-not-fully-cacheable CLI argument
  if [ -n "${fail_if_not_fully_cacheable+x}" ]; then
    local executed_avoidable_tasks
    executed_avoidable_tasks=$(( executed_cacheable_num_tasks[1] ))
    if [[ "${fail_if_not_fully_cacheable}" == "on" ]] && (( executed_avoidable_tasks > 0 )); then
      print_bl
      die "FAILURE: Build is not fully cacheable for the given task graph." "${BUILD_NOT_FULLY_CACHEABLE}"
    fi
  fi
  exit "${SUCCESS}"
}
