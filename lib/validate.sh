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

__validate_tf_action() {
    local valid_actions=("plan" "apply")
    local action_emph="$(__add_emphasis_blue ${_TF_ACTION})"

    _cmd="echo \"${valid_actions[@]}\" | grep -q \"${_TF_ACTION}\""
    run_cmd_silent_strict "${_cmd}" "Validating supplied action" "$(echo -e "Action ${action_emph} is invalid\nValid options include: ${valid_actions[@]}" | decorate_error)"
}
