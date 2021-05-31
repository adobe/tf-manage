#!/bin/bash

# calculate script root dir
export ROOT_DIR=$(cd ${BASH_SOURCE[0]%/*}/.. && pwd -P)

# import bash framework
source "${ROOT_DIR}/vendor/bash-framework/lib/import.sh"

function usage {
    cmd="${BASH_SOURCE[0]##*/} [<TF_VERSION>]"
    echo "Usage: ${cmd}"
    exit -1
}

## -- Setup
# generic folder logic
install_dir='/opt/terraform'
install_dir_wrapper='/opt/terraform/tf-manage'
tf_config_path="${HOME}/.terraformrc"
tf_wrapper_repo=$(git --git-dir=${ROOT_DIR}/.git remote get-url origin)

# input validation
[ "$#" -lt 0 ] || [ "$#" -ge 2 ] && usage

# gather input vars
# set TF version
version=${1:-0.13.5}

# gather platform info
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    *)          machine="UNKNOWN:${unameOut}"
esac
info "Detected platform: ${machine}"

# compute package url
download_path="/tmp/tf-${version}.zip"
package_url_prefix="https://releases.hashicorp.com/terraform/${version}"
case "${machine}" in
    Linux*)     package_url="${package_url_prefix}/terraform_${version}_linux_amd64.zip";;
    Mac*)       package_url="${package_url_prefix}/terraform_${version}_darwin_amd64.zip";;
    *)          package_url="UNKNOWN:${machine}"
esac
info "Computed package_url: ${package_url}"

# Sudo password notice
info "This will install/upgrade Terraform to version ${version}"
_message="Sudo credentials are required. Please insert your password below:"
_cmd="sudo echo \"Thank you! Continuing installation...\""
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[5]="no_print_status"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# Download release
_message="Downloading terraform archive..."
_cmd="wget -O ${download_path} ${package_url}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# prepare install dir
_message="Preparing install dir ${install_dir}"
_cmd="sudo mkdir -m 0775 -p ${install_dir} && sudo chown $USER: ${install_dir}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# switch dir
info "Entering ${install_dir}"
cd ${install_dir}

# unarchive
_message="Extracting binary from downloaded archive"
_cmd="sudo unzip -qo ${download_path}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# rename and link current version
_message="Adding version to binary name"
_cmd="sudo mv terraform terraform-${version}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

_message="Setting binary ownership"
_cmd="sudo chown root: terraform-${version}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

_message="Setting binary permissions"
_cmd="sudo chmod 755 terraform-${version}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

_message="Linking current version"
_cmd="sudo ln -s -f ${install_dir}/terraform-${version} ${install_dir}/terraform"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

_message="Adding terraform to PATH"
_cmd="sudo ln -s -f ${install_dir}/terraform /usr/local/bin/terraform"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# install terraform config
_message="Installing default TF configuration at ${tf_config_path}"
_cmd="echo 'plugin_cache_dir   = \"$HOME/.terraform.d/plugin-cache\"' > ${tf_config_path}"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# test installation
_message="Checking installation by printing the version"
_cmd="terraform version"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# install wrapper
_message="Installing tf-manage terraform wrapper at ${install_dir_wrapper}"
_cmd="sudo cp -a ${ROOT_DIR}/ ${install_dir_wrapper}/ && sudo chown -R ${USER}: ${install_dir_wrapper}/"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# add wrapper to PATH
_message="Adding tf wrapper to PATH"
_cmd="sudo ln -s -f ${install_dir_wrapper}/bin/tf.sh /usr/local/bin/tf"
_flags=(${_DEFAULT_CMD_FLAGS[@]})
_flags[0]="strict"
_flags[4]="no_print_message"
_flags[6]="no_print_outcome"
run_cmd "${_cmd}" "${_message}" "${_flags[@]}"

# install wrapper bash completion support for mac
if [ "${machine}" = 'Mac' ]; then
    if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
        _message="Installing bash completion for wrapper. The \"tf\" command will have bash completion support in new shells"
        _cmd="ln -fs ${install_dir_wrapper}/bin/tf_complete.sh $(brew --prefix)/etc/bash_completion.d/tf"
        _flags=(${_DEFAULT_CMD_FLAGS[@]})
        _flags[0]="strict"
        _flags[4]="no_print_message"
        run_cmd "${_cmd}" "${_message}" "${_flags[@]}"
    else
        info "You don't seem to have bash completion installed"
        info "The terraform wrapper also has bash completion support"
        info "Run \"brew install bash-completion && brew tap homebrew/completions\" to install it"
        info "Add \". \$(brew --prefix)/etc/bash_completion\" to your ~/.bash_profile"
        info "Then, you can re-run this script to install completion support"
        info "You will, of course, also need homebrew for this to work"
    fi
elif [ "${machine}" = 'Linux' ]; then
    if [ -e "/etc/bash_completion.d/" ]; then
        _message="Installing bash completion for wrapper. The \"tf\" command will have bash completion support in new shells"
        _cmd="ln -fs ${install_dir_wrapper}/bin/tf_complete.sh /etc/bash_completion.d/tf"
        _flags=(${_DEFAULT_CMD_FLAGS[@]})
        _flags[0]="strict"
        _flags[4]="no_print_message"
        run_cmd "${_cmd}" "${_message}" "${_flags[@]}"
    else
        info "You don't seem to have bash completion installed"
        info "The terraform wrapper also has bash completion support"
        info "Run \"yum -y install bash-completion\" to install it and restart your shell"
        info "Then, you can re-run this script to install completion support"
    fi
fi
