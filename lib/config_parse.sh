## prepare config_not_found error
__config_not_found_err() {
err_part1=$(decorate_error <<-HEREDOC
    Couldn\'t find tf-manage config file $(__add_emphasis_blue ${__tfm_conf_path##*/}) for $(__add_emphasis_blue ${TLDIR##*/})
    You must create it at ${__tfm_conf_path}
    Or generate it, by running the snippet below:
HEREDOC)

generate_snippet=$(cat <<-HEREDOC
cat > ${__tfm_conf_path} <<-EOF
#!/bin/bash
export __tfm_env_rel_path='terraform/environments'
export __tfm_module_rel_path='terraform/modules'
EOF
HEREDOC)

err_part2=$(decorate_error <<'HEREDOC'
    You can customize the values if needed
    Then, re-run the script after you\'re done
HEREDOC)

    echo -ne "${err_part1}\n${generate_snippet}\n${err_part2}"
}

## get terraform module git repository top-level path
## Note: the assumption is that you're running the terraform wrapper from
##       within a git infrastructure repository
TLDIR=$(git rev-parse --show-toplevel)

## the default tf-manage configuration path
__tfm_conf_path="${TLDIR}/.tfm.conf"

## Check config file exists
_cmd="test -f ${__tfm_conf_path}"
run_strict_validation "${_cmd}" "Checking tf-manage config exists..." "${cmd_flags[@]}" "$(__config_not_found_err)"

## import the project-specific configuration
source ${__tfm_conf_path}
