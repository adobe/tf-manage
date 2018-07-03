#!/bin/bash

### Platform check
###############################################################################
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac

### Binary set
###############################################################################
case "${machine}" in
    Linux*)     BIN_READLINK="readlink";;
    Mac*)       BIN_READLINK="greadlink";;
    *)          BIN_READLINK="readlink";;
esac

### Framework boilerplate
###############################################################################
# calculate script root dir
ROOT_DIR="$( dirname $(${BIN_READLINK} -f ${BASH_SOURCE[0]}) )"

# import bash framework
source "${ROOT_DIR}/../vendor/bash-framework/lib/import.sh"

# import TF wrapper modules
source "${ROOT_DIR}/../lib/import.sh"

### Input validation
###############################################################################
function usage {
    cmd="${BASH_SOURCE[0]##*/} <component> <module> <env> <vars> <action> [workspace]"
    error "Usage: ${cmd}"
    exit -1
}

# number of arguments
( [ "$#" -lt 6 ] || [ "$#" -gt 7 ] ) && usage

# gather input vars
_PRODUCT=${1}
_COMPONENT=${2}
_MODULE=${3}
_ENV=${4}
_VARS=${5}
_TF_ACTION=${6}
_WORKSPACE_OVERRIDE=${7:-workspace=}

### Load configuration
###############################################################################
__load_global_config
__load_project_config

# get global variables inferred by the wrapper
__compute_common_paths

### Check folder structure is valid
###############################################################################
__validate_product
__validate_component
__validate_module_dir
__validate_env_dir
__validate_config_path

### Check TF_ACTION is supported
###############################################################################
__validate_tf_action

### Switch to targeted module path
###############################################################################
cd "${TF_MODULE_PATH}"

### Build terraform action command
###############################################################################
__tf_controller
