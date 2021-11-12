# Copyright (c) 2017 - present Adobe Systems Incorporated. All rights reserved.

# Licensed under the MIT License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

# https://opensource.org/licenses/MIT

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# set critical internal variables
export __tfm_root_dir=$(cd ${BASH_SOURCE[0]%/*}/.. && pwd -P)
export __tfm_lib_dir="${__tfm_root_dir}/lib"
export __tfm_conf_dir="${__tfm_root_dir}/etc"

# import TF wrapper modules
source "${__tfm_lib_dir}/config_parse.sh"
source "${__tfm_lib_dir}/validate.sh"
source "${__tfm_lib_dir}/tf_wrapper.sh"
