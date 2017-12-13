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
    cmd="${BASH_SOURCE[0]##*/} <module> <env> <vars> <action>"
    error "Usage: ${cmd}"
    exit -1
}

# number of arguments
[ "$#" -ne 4 ] && usage

# gather input vars
_MODULE=${1}
_ENV=${2}
_VARS=${3}
_TF_ACTION=${4}

### Load configuration
###############################################################################
__load_global_config
__load_project_config

### Check folder structure is valid
###############################################################################
__validate_product
__validate_module_dir
__validate_env_dir
__validate_config_path

### Check TF_ACTION is supported
###############################################################################
__validate_tf_action

### Check terraform workspace exists and is active
###############################################################################
__validate_tf_workspace

### Switch to targeted module path
###############################################################################
cd "${TF_MODULE_PATH}"

### Build terraform workspace (env) command
###############################################################################
_tf_command="terraform workspace list"
run_cmd "${_tf_command}" "Checking terraform workspace ${tf_workspace_emph} exists"
echo "${_tf_command}"

### Build terraform action command
###############################################################################
_tf_command="terraform ${_TF_ACTION} -var-file=\"${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/terraform.tfvars\""
echo "${_tf_command}"
