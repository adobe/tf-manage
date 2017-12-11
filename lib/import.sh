# set critical internal variables
export __tfm_root_dir=$(cd ${BASH_SOURCE[0]%/*}/.. && pwd -P)
export __tfm_lib_dir="${__tfm_root_dir}/lib"

# import TF wrapper modules
source "${__tfm_lib_dir}/config_parse.sh"
source "${__tfm_lib_dir}/validate.sh"
