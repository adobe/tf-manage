#!/bin/bash

### Framework boilerplate
###############################################################################
# calculate script root dir
ROOT_DIR="$( dirname $(realpath ${BASH_SOURCE[0]}) )"

# import bash framework
source "${ROOT_DIR}/../vendor/bash-framework/lib/import.sh"

# import TF wrapper modules
source "${ROOT_DIR}/../lib/import.sh"

### Input validation
###############################################################################
function usage {
    cmd="${BASH_SOURCE[0]##*/} <module> <env> <action>"
    error "Usage: ${cmd}"
    exit -1
}

# number of arguments
[ "$#" -ne 3 ] && usage

# gather input vars
_MODULE=${1}
_ENV=${2}
_TF_ACTION=${3}

### Load configuration
###############################################################################
__load_config

### Check folder structure is valid
###############################################################################
__validate_module_dir
__validate_env_dir

### Check TF_ACTION is supported
###############################################################################
__validate_tf_action

### Build terraform command
###############################################################################
