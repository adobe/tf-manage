#!/bin/bash

### Framework boilerplate
###############################################################################
# calculate script root dir
ROOT_DIR="$( dirname $(realpath ${BASH_SOURCE[@]}) )"

echo $ROOT_DIR

# import bash framework
source "${ROOT_DIR}/../vendor/bash-framework/lib/import.sh"

### Input validation
###############################################################################
function usage {
    cmd="${BASH_SOURCE[0]##*/} <module> <env> <action>"
    echo "Usage: ${cmd}"
    exit -1
}

# number of arguments
[ "$#" -ne 3 ] && usage

# gather input vars
_MODULE=${1}
_ENV=${2}
_TF_ACTION=${3}

### Check folder structure is valid
###############################################################################
# validate_module_dir
# validate_env_dir

### Check TF_ACTION is supported
###############################################################################
# validate_tf_action

### Build terraform command
###############################################################################
echo "terraform"
echo "$OK"
