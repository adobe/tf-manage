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

FROM docker-asr-release.dr.corp.adobe.com/behance/docker-base:3-alpine

RUN apk add --no-cache --no-progress wget sudo unzip git bash bash-doc bash-completion which vim tree curl aws-cli jq openssh

RUN echo "alias ll='ls -la'" >> /root/.bashrc
RUN mkdir -p /root/.ssh && chown 700 /root/.ssh
RUN echo 'git.corp.adobe.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGLBrZBX3PgtVfC9BDg+d37FA32XrZMTJ7lP7Vl8JUlMeAceT91Ki/WCUmabfFZgdCohM0CzRD56yn6uZo/slT0=' >> /root/.ssh/known_hosts

WORKDIR /opt/tf-manage
COPY ./ ./

# alpine fixes
ENV USER=root
RUN mkdir /etc/bash_completion.d/
RUN mkdir -p /root/.terraform.d/plugin-cache

# run installer
RUN /opt/tf-manage/bin/tf_install.sh
RUN echo "source /etc/bash_completion.d/tf" >> /root/.bashrc

WORKDIR /
