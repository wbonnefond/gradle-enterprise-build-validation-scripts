#!/usr/bin/env bash

wizard() {
  local text
  text="$(echo "${1}" | fmt -w 78)"

  print_wizard_text "${text}" "
"
}

wait_for_enter() {
  read -r
  UP_ONE_LINE="\033[1A"
  ERASE_LINE="\033[2K"
  echo -en "${UP_ONE_LINE}${ERASE_LINE}"
  echo -en "${UP_ONE_LINE}${ERASE_LINE}"
  echo -en "${UP_ONE_LINE}${ERASE_LINE}"
}


print_wizard_text() {
  echo -n "${RESTORE}"
  echo -n "$@"
}

print_separator() {
  printf '=%.0s' {1..80}
  echo
}

print_introduction_title() {
  cat <<EOF
${HEADER_COLOR}Gradle Enterprise - Build Validation

Experiment ${EXP_NO}: ${EXP_DESCRIPTION}${RESTORE}
EOF
}

explain_prerequisites_ccud_gradle_plugin() {
  local text preparation_step

  if [ -n "$1" ]; then
    preparation_step="$1 "
  else
    preparation_step=""
  fi

  IFS='' read -r -d '' text <<EOF
$(print_separator)
${HEADER_COLOR}Preparation ${preparation_step}- Configure build with Common Custom User Data Gradle plugin${RESTORE}

To get the most out of this experiment and also when building with Gradle
Enterprise during daily development, it is advisable that you apply the Common
Custom User Data Gradle plugin to your build, if not already the case. Gradle
provides the Common Custom User Data Gradle plugin as a free, open-source add-on.

https://plugins.gradle.org/plugin/com.gradle.common-custom-user-data-gradle-plugin

An extract of a typical build configuration is described below.

settings.gradle:
plugins {
    id 'com.gradle.enterprise' version '<latest version>'
    id 'com.gradle.common-custom-user-data-gradle-plugin' version '<latest version>'
}

Your updated build configuration should be pushed before proceeding.

${USER_ACTION_COLOR}Press <Enter> once you have (optionally) configured your build with the Common Custom User Data Gradle plugin and pushed the changes.${RESTORE}
EOF
  print_wizard_text "${text}"
  wait_for_enter
}

explain_experiment_dir() {
  wizard "All of the work we do for this experiment will be stored in
$(info "${EXP_DIR}")"
}

explain_collect_git_details() {
  local text
  IFS='' read -r -d '' text <<EOF
$(print_separator)
${HEADER_COLOR}Configure experiment${RESTORE}

The experiment will run using a fresh checkout of a given project stored in
Git. The fresh checkout ensures reproducibility of the experiment across
machines and users since no local changes and commits will be accidentally
included in the validation process.

Optionally, the project can be validated and optimized on an existing
branch and only merged back to the main line once all improvements are
completed.
EOF
  print_wizard_text "${text}"
}

explain_collect_gradle_details() {
  local text
  IFS='' read -r -d '' text <<EOF
Once the project is checked out from Git, the experiment will invoke the
project’s contained Gradle build with a given set of tasks and an optional
set of arguments. The Gradle tasks to invoke should resemble what users
typically invoke when building the project.

The build will be invoked from the project’s root directory or from a given
sub-directory.

In order to become familiar with the experiment, it is advisable to
initially choose a task that does not take too long to complete, for example
the 'assemble' task.
EOF
  print_wizard_text "${text}"
}

explain_collect_maven_details() {
  local text
  IFS='' read -r -d '' text <<EOF
Once the project is checked out from Git, the experiment will invoke the
project’s contained Maven build with a given set of goals and an optional
set of arguments. The Maven goals to invoke should resemble what users
typically invoke when building the project.

The build will be invoked from the project’s root directory or from a given
sub-directory.

In order to become familiar with the experiment, it is advisable to
initially choose a goal that does not take too long to complete, for example
the 'install' goal.
EOF
  print_wizard_text "${text}"
}

explain_clone_project() {
  local text
  IFS='' read -r -d '' text <<EOF
$(print_separator)
${HEADER_COLOR}Check out project from Git${RESTORE}

All configuration to run the experiment has been collected. In the first
step of the experiment, the Git repository that contains the project to
validate will be checked out.

${USER_ACTION_COLOR}Press <Enter> to check out the project from Git.${RESTORE}
EOF
  print_wizard_text "${text}"
  wait_for_enter
}

explain_command_to_repeat_experiment() {
  local text
  IFS='' read -r -d '' text <<EOF
The 'Command Line Invocation' section below demonstrates how you can rerun the
experiment with the same configuration and in non-interactive mode.
EOF
  echo -n "${text}"
}

explain_when_to_rerun_experiment() {
  local text
  IFS='' read -r -d '' text <<EOF
Once you have addressed the issues surfaced in build scans and pushed the
changes to your Git repository, you can rerun the experiment and start over
the cycle of run → measure → improve → run.
EOF
  echo -n "${text}"
}
