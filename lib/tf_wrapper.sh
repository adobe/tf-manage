_yin_yang_utf="\xe2\x98\xaf"
_GENERIC_ERR_MESSAGE_text="\nNice job, you broke it!\n${_yin_yang_utf}   Take a DEEP breath   ${_yin_yang_utf}\nLet's stop for a moment and think about where you're screwing up..."
_GENERIC_ERR_MESSAGE=$(echo -e "${_GENERIC_ERR_MESSAGE_text}" | decorate_error)

__run_action_plan() {
    debug "Entered ${FUNCNAME}"

    # vars
    local var_file_path="${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/${_VARS}"
    local plan_file_path="${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/.tfplan"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} -var-file='${var_file_path}' -out ${plan_file_path}"
    local _message="Executing $(__add_emphasis_magenta "terraform plan")"
    local _extra_notice="This $(__add_emphasis_green 'will not') affect infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[1]='print_cmd'
    _flags[4]="no_print_message"

    # execute
    info "${_message}"
    info "${_extra_notice}"
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_apply() {
    # vars
    local plan_file_path="${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/.tfplan"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} ${plan_file_path}"
    local _message="Executing $(__add_emphasis_red "terraform apply")"
    local _extra_notice="This $(__add_emphasis_red 'will') affect infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[1]='print_cmd'
    _flags[4]="no_print_message"

    # execute
    info "${_message}"
    info "${_extra_notice}"

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_destroy() {
    debug "Entered ${FUNCNAME}"

    # vars
    local var_file_path="${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/${_VARS}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} -var-file='${var_file_path}'"
    local _message="Executing $(__add_emphasis_red "terraform destroy")"
    local _extra_notice="This $(__add_emphasis_red 'will DESTROY') infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[4]="no_print_message"

    # execute
    info "${_message}"
    info "${_extra_notice}"

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_get() {
    debug "Entered ${FUNCNAME}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION}"
    local _message="Executing $(__add_emphasis_green "terraform get")"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_output() {
    debug "Entered ${FUNCNAME}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION}"
    local _message="Executing $(__add_emphasis_green "terraform output")"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_refresh() {
    debug "Entered ${FUNCNAME}"

    # vars
    local var_file_path="${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/${_VARS}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} -var-file='${var_file_path}'"
    local _message="Executing $(__add_emphasis_green "terraform refresh")"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__get_tf_version() {
    local _cmd="terraform --version | head -1 | grep -o 'v.*'"
    local _message="Getting terraform version"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[4]="no_print_message"
    _flags[5]="no_print_status"
    _flags[6]="no_print_outcome"

    # store
    export _TF_VERSION=$(run_cmd "${_cmd}" "${_message}" "${_flags[@]}")
}

## Main Terraform wrapper control logic
__tf_controller() {
    # get Terraform version from CLI
    __get_tf_version

    # notify user
    notice_msg="*** Terraform ${_TF_VERSION} ***"
    info "$(__add_emphasis_gray "${notice_msg}")"

    # build targeted wrapper command function name
    local wrapper_action_method="__run_action_${_TF_ACTION}"

    info "Running from ${PWD}"

    # execute function
    $wrapper_action_method
}
