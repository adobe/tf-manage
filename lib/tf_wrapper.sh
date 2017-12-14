## Main Terraform wrapper control logic
__tf_controller() {
    _tf_command="terraform ${_TF_ACTION} -var-file='${TF_CONFIG_PATH}/${_ENV}/${_MODULE}/${_VARS}'"
    echo "${_tf_command}"
}
