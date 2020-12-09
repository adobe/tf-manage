FROM alpine:3

RUN apk add --no-cache --no-progress wget sudo unzip git bash bash-doc bash-completion which vim

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
