## prepare config_not_found error
__config_not_found_err() {
err_part1=$(decorate_error <<-HEREDOC
    Couldn\'t find tf-manage config file $(__add_emphasis_blue ${__tfm_project_config_path##*/}) for $(__add_emphasis_blue ${__tfm_project_dir##*/})
    You must create it at ${__tfm_project_config_path}
    Or generate it, by running the snippet below:
HEREDOC
)

generate_snippet=$(cat <<-HEREDOC
cat > ${__tfm_project_config_path} <<-EOF
#!/bin/bash
export __tfm_env_rel_path='terraform/environments'
export __tfm_module_rel_path='terraform/modules'
EOF
HEREDOC
)

err_part2=$(decorate_error <<-HEREDOC
    You can customize the values if needed
    Then, re-run the script after you\'re done
HEREDOC
)

    echo -ne "\n${err_part1}\n${generate_snippet}\n${err_part2}"
}

__load_project_config() {
    ## get terraform module git repository top-level path
    ## Note: the assumption is that you're running the terraform wrapper from
    ##       within a git infrastructure repository
    export __tfm_project_dir="$(git rev-parse --show-toplevel 2> /dev/null)"
    [ -z "${__tfm_project_dir}" ] && echo -e "Could not find a git repository at the current path!\nTerraform modules must be in their own git repository." | decorate_error && return 1

    ## the default tf-manage configuration path
    export __tfm_project_config_path="${__tfm_project_dir}/.tfm.conf"

    ## Check config file exists
    _cmd="test -f ${__tfm_project_config_path}"
    run_cmd_silent "${_cmd}" "Checking tf-manage project config exists..." "$(__config_not_found_err)"
    result=$?

    ## import the project-specific configuration
    [ $result -eq 0 ] && source ${__tfm_project_config_path}

    # build project paths
    export TF_PROJECT_MODULE_PATH="${__tfm_project_dir}/${__tfm_module_rel_path}"
    export TF_PROJECT_CONFIG_PATH="${__tfm_project_dir}/${__tfm_env_rel_path}"

    # pass command exit-code to caller
    return ${result}
}

__load_global_config() {
    export __tfm_global_config_path="${__tfm_conf_dir}/global_config.sh"

    ## Check config file exists
    _cmd="test -f ${__tfm_global_config_path}"
    run_cmd_silent "${_cmd}" "Checking tf-manage global config exists..." "$(echo -e "Global config missing!\nShould be at $(__add_emphasis_blue ${__tfm_global_config_path})")"
    result=$?

    ## import the project-specific configuration
    [ $result -eq 0 ] && source ${__tfm_global_config_path}

    # pass command exit-code to caller
    return ${result}
}

__compute_common_paths() {
    ## file locations
    # selected module folder
    export TF_MODULE_PATH="${TF_PROJECT_MODULE_PATH}/${_MODULE}"
    # selected environment folder
    export TF_ENV_PRODUCT_PATH="${TF_PROJECT_CONFIG_PATH}/${_PRODUCT}"
    export TF_ENV_PATH="${TF_ENV_PRODUCT_PATH}/${_ENV}"
    # selected per-environment module config folder
    export TF_MODULE_ENV_CONF_PATH="${TF_PROJECT_CONFIG_PATH}/${_PRODUCT}/${_ENV}/${_MODULE}"
    # selected per-environment module config var-file
    export TF_VAR_FILE_PATH="${TF_MODULE_ENV_CONF_PATH}/${_VARS}.tfvars"
    # selected per-environment module config tfplan file
    export TF_PLAN_FILE_PATH="${TF_MODULE_ENV_CONF_PATH}/${_VARS}.tfvars.tfplan"

    ## generated values
    # auto-selected workspace name, composed from component, module, env and var-file name
    export TF_WORKSPACE_GENERATED="${_PRODUCT}.${_COMPONENT}.${_MODULE}.${_ENV}.${_VARS}"
}

__detect_env() {
    case USER in
        jenkins )
            export TF_EXEC_MODE='CI'
            local tf_exec_mode_red="$(__add_emphasis_red "${TF_EXEC_MODE}")"
            ;;
        * )
            export TF_EXEC_MODE='DEV'
            local tf_exec_mode_red="$(__add_emphasis_blue "${TF_EXEC_MODE}")"
            ;;
    esac

    # report exec mode
    info "Detected exec mode: ${tf_exec_mode_red}"
}
