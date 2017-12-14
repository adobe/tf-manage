## prepare folder_not_found error
__tfm_project_dir_not_found_err() {
    dir_type="${1}"
    dir_path="${2}"
    tfm_dir_variable="${3}"
err_part1=$(decorate_error <<-HEREDOC
    Couldn\'t find ${dir_type} dir $(__add_emphasis_blue ${dir_path}) for $(__add_emphasis_blue ${__tfm_project_dir##*/})
    Please check ${__tfm_conf_path} for the $(__add_emphasis_blue ${tfm_dir_variable}) entry.
    The current setting is ${tfm_dir_variable}=$(__add_emphasis_blue ${!tfm_dir_variable})
    Or generate it, by running the snippet below:
HEREDOC)

generate_snippet=$(cat <<-HEREDOC
    mkdir -p ${__tfm_project_dir}/${!tfm_dir_variable}
HEREDOC)

    echo -ne "\n${err_part1}\n${generate_snippet}"
}

__validate_module_dir() {
    # compute project module dir path
    local dir_path="${TF_MODULE_PATH}"
    local dir_path_emph="$(__add_emphasis_blue ${dir_path})"

    ## Check dir exists
    _cmd="test -d ${dir_path}"
    run_cmd_silent_strict "${_cmd}" "Checking module dir exists" "$(__tfm_project_dir_not_found_err "module" "${dir_path}" "__tfm_module_rel_path")"

    ## Check selected module exists
    local module_path="${dir_path}/${_MODULE}"
    local module_name_emph="$(__add_emphasis_blue ${_MODULE})"
    _cmd="test -d ${module_path}"
    run_cmd_strict "${_cmd}" "Checking module ${module_name_emph} exists" "$(echo -e "Module ${module_name_emph} not found at ${dir_path_emph}" | decorate_error)"
}

__validate_env_dir() {
    # compute project environment dir path
    local dir_path="${TF_CONFIG_PATH}"
    local dir_path_emph="$(__add_emphasis_blue ${dir_path})"

    ## Check dir exists
    _cmd="test -d ${dir_path}"
    run_cmd_silent_strict "${_cmd}" "Checking environment dir exists" "$(__tfm_project_dir_not_found_err "environment" "${dir_path}" "__tfm_env_rel_path")"

    ## Check selected environment exists
    local env_path="${dir_path}/${_ENV}"
    local env_name_emph="$(__add_emphasis_blue ${_ENV})"
    _cmd="test -d ${env_path}"
    run_cmd_strict "${_cmd}" "Checking environment ${env_name_emph} exists" "$(echo -e "Environment ${env_name_emph} not found at ${dir_path_emph}" | decorate_error)"
}

__validate_config_path() {
    # compute project environment dir path
    local dir_path="${TF_CONFIG_PATH}/${_ENV}/${_MODULE}"
    local dir_path_emph="$(__add_emphasis_blue ${dir_path})"
    local env_name_emph="$(__add_emphasis_blue ${_ENV})"
    local module_name_emph="$(__add_emphasis_blue ${_MODULE})"

    ## Check dir exists
    _cmd="test -d ${dir_path}"
    run_cmd_silent_strict "${_cmd}" "Checking module config dir exists" "$(echo -e "Module ${module_name_emph} is missing a configuration folder for environment ${env_name_emph}\nShould be at ${dir_path_emph}" | decorate_error)"

    ## Check selected module has configuration present in the selected env
    local var_path="${dir_path}/${_VARS}"
    local var_path_emph="$(__add_emphasis_blue ${var_path##*/})"
    local var_path_abs_emph="$(__add_emphasis_blue ${var_path})"
    _cmd="test -f ${var_path}"
    run_cmd_strict "${_cmd}" "Checking config ${var_path_emph} exists" "$(echo -e "Terraform config file ${var_path_emph} not found at ${var_path_abs_emph}" | decorate_error)"
}

__print_valid_options() {
    ## Load valid products into an array
    __safe_set_bash_setting 'u'
    old_IFS="${IFS}"
    local valid_options=(${1})
    IFS="${old_IFS}"
    __safe_unset_bash_setting 'u'

    for p in "${valid_options[@]}"; do
        echo "* $(__add_emphasis_blue "${p}")"
    done
}

__validate_tf_action() {
    local valid_actions="${__tfm_allowed_actions}"
    local action="${_TF_ACTION}"
    local action_emph="$(__add_emphasis_blue ${action})"

    ## Check selected product is whitelisted
    __assert_string_list_contains "${action}" "${valid_actions}"
    result=$?
    _cmd="test ${result} -eq 0"
    run_cmd_silent_strict "${_cmd}" "Checking supplied action ${action_emph} is valid" "$(echo -e "Action \"${action_emph}\" is invalid!\nValid options include:\n$(__print_valid_options "${valid_actions}")" | decorate_error)"

    _cmd="echo \"${valid_actions[@]}\" | grep -q \"${_TF_ACTION}\""
    run_cmd_silent_strict "${_cmd}" "Validating supplied action" "$(echo -e "Action ${action_emph} is invalid\nValid options include: ${valid_actions[@]}" | decorate_error)"
}

__validate_component() {
    local component="${_COMPONENT}"
    local component_emph="$(__add_emphasis_blue "${component}")"

    ## Check component is set
    _cmd="! test -z ${component}"
    run_cmd_strict "${_cmd}" "Checking component ${component_emph} is valid" "$(echo -e "Component is empty.\nMake sure the first argument is set to a non-null string" | decorate_error)"
}

__validate_product() {
    local valid_products="${__tfm_allowed_products}"
    local product="${__tfm_project_name}"
    local product_emph="$(__add_emphasis_blue "${product}")"
    local config_key_emph="$(__add_emphasis_blue '__tfm_project_name')"
    local project_config_emph="$(__add_emphasis_blue "${__tfm_project_config_path}")"

    ## Check product is set
    _cmd="! test -z ${product}"
    run_cmd_silent_strict "${_cmd}" "Checking product is set" "$(echo -e "Product is unset\n${config_key_emph} must be set in ${project_config_emph}\nValid options include: ${valid_products[@]}" | decorate_error)"

    ## Check selected product is whitelisted
    __assert_string_list_contains "${product}" "${valid_products}"
    result=$?
    _cmd="test ${result} -eq 0"
    run_cmd_strict "${_cmd}" "Checking product ${product_emph} is valid" "$(echo -e "Product \"${product_emph}\" is invalid!\nValid options include:\n$(__print_valid_options "${valid_products}")\nPlease update ${config_key_emph} in ${project_config_emph}" | decorate_error)"
}

__validate_tf_workspace() {
    ## Build expected workspace
    local workspace="${__tfm_project_name}-${_COMPONENT}-${_MODULE}-${_ENV}-${_VARS/\.tfvars/}"
    local workspace_emph="$(__add_emphasis_blue "${workspace}")"

    ## prepare flags for run_cmd
    cmd_flags=(
        "no_strict"
        "no_print_cmd"
        "no_decorate_output"
        "no_print_output"
        "no_print_message"
        "no_print_status"
        "no_print_outcome"
        "aborting..."
        "continuing..."
    )

    local message="Checking workspace ${workspace_emph} exists"

    ## Check workspace exists
    _cmd="terraform workspace list | grep ${workspace}"
    run_cmd "${_cmd}" "${message}" "${cmd_flags[@]}"
    result=$?

    ## Auto-creating missing workspace, if needed
    ## NOTE: Changing to the module directory is needed for local workspace support
    if [ "${result}" -ne 0 ]; then
        _cmd="cd ${TF_MODULE_PATH}/${_MODULE} && terraform workspace new ${workspace} && cd -"
        run_cmd_strict "${_cmd}" "Creating workspace ${workspace_emph}" "Could not create workspace!"
    fi

    ## Selecting workspace
    ## NOTE: Changing to the module directory is needed for local workspace support
    _cmd="cd ${TF_MODULE_PATH}/${_MODULE} && terraform workspace select ${workspace} && cd -"
    run_cmd_strict "${_cmd}" "Selecting workspace ${workspace_emph}" "Could not select workspace!"
}
