_yin_yang_utf="\xe2\x98\xaf"
_GENERIC_ERR_MESSAGE_text="\nNice job, you broke it!\n${_yin_yang_utf}   Take a DEEP breath   ${_yin_yang_utf}\nLet's stop for a moment and think about where you're screwing up..."
_GENERIC_ERR_MESSAGE=$(echo -e "${_GENERIC_ERR_MESSAGE_text}" | decorate_error)

__run_action_plan() {
    debug "Entered ${FUNCNAME}"

    # vars
    local var_file_path="${TF_VAR_FILE_PATH}"
    local plan_file_path="${TF_PLAN_FILE_PATH}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} -var-file='${var_file_path}' -out ${plan_file_path}"
    local _message="Executing $(__add_emphasis_magenta "terraform plan")"
    local _extra_notice="This $(__add_emphasis_green 'will not') affect infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[1]='print_cmd'
    _flags[4]="no_print_message"

    # notify user
    info "${_message}"
    info "${_extra_notice}"

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"

    # inform user .tfplan file was created
    local plan_file_emph="$(__add_emphasis_blue "${plan_file_path}")"
    info "Created Terraform plan file: ${plan_file_emph}"
}

__run_action_apply_tfplan() {
    # vars
    local plan_file_path="${TF_PLAN_FILE_PATH}"

    # build wrapper command
    local _cmd="terraform apply ${plan_file_path}"
    local _message="Executing $(__add_emphasis_red "terraform apply")"
    local _extra_notice="This $(__add_emphasis_red 'will') affect infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[1]='print_cmd'
    _flags[4]="no_print_message"

    # notify user
    info "${_message}"
    info "${_extra_notice}"

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_apply() {
    # vars
    local var_file_path="${TF_VAR_FILE_PATH}"
    local extra_tf_args=""

    # append extra arguments in case we're running in "unattended" mode
    [ "${TF_EXEC_MODE}" = 'unattended' ] && local extra_tf_args=" -input=false -auto-approve"

    # build wrapper command
    local _cmd="terraform apply -var-file='${var_file_path}'${extra_tf_args}"
    local _message="Executing $(__add_emphasis_red "terraform apply")"
    local _extra_notice="This $(__add_emphasis_red 'will') affect infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[1]='print_cmd'
    _flags[4]="no_print_message"

    # notify user
    info "${_message}"
    info "${_extra_notice}"

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_destroy() {
    debug "Entered ${FUNCNAME}"

    # vars
    local var_file_path="${TF_VAR_FILE_PATH}"

    # append extra arguments in case we're running in "unattended" mode
    [ "${TF_EXEC_MODE}" = 'unattended' ] && local extra_tf_args=" -auto-approve"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} -var-file='${var_file_path}'${extra_tf_args}"
    local _message="Executing $(__add_emphasis_red "terraform destroy")"
    local _extra_notice="This $(__add_emphasis_red 'will DESTROY') infrastructure resources."
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'
    _flags[1]='print_cmd'
    _flags[4]="no_print_message"

    # notify user
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

__run_action_init() {
    debug "Entered ${FUNCNAME}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION}"
    local _message="Executing $(__add_emphasis_green "terraform init")"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_refresh() {
    debug "Entered ${FUNCNAME}"

    # vars
    local var_file_path="${TF_VAR_FILE_PATH}"

    # build wrapper command
    local _cmd="terraform ${_TF_ACTION} -var-file='${var_file_path}'"
    local _message="Executing $(__add_emphasis_green "terraform refresh")"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__run_action_fmt() {
    debug "Entered ${FUNCNAME}"

    # build wrapper command
    local _cmd="terraform fmt"
    local _message="Executing $(__add_emphasis_green "terraform fmt")"
    local _flags=(${_DEFAULT_CMD_FLAGS[@]})
    _flags[0]='strict'

    # execute
    run_cmd "${_cmd}" "${_message}" "${_flags[@]}" "${_GENERIC_ERR_MESSAGE}"
}

__get_tf_version() {
    debug "Entered ${FUNCNAME}"

    # build wrapper command
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

    # Informal notice for current directory
    info "Running from ${PWD}"

    ### Check terraform workspace exists and is active
    ###############################################################################
    if [ "${_TF_ACTION}" != "init" ]; then  # don't need a workspace for running "init"
    if [ "${_TF_ACTION}" != "fmt" ]; then   # don't need a workspace for running "fmt"
        __validate_tf_workspace
    fi
    fi

    # execute function
    $wrapper_action_method
}
