FROM centos:8

RUN yum -y install wget sudo unzip git bash-completion which

RUN echo "alias ll='ls -la'" >> /root/.bashrc
RUN echo 'git.corp.adobe.com ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBGLBrZBX3PgtVfC9BDg+d37FA32XrZMTJ7lP7Vl8JUlMeAceT91Ki/WCUmabfFZgdCohM0CzRD56yn6uZo/slT0=' >> /root/.ssh/known_hosts

WORKDIR /opt/tf-manage
COPY ./ ./

RUN /opt/tf-manage/bin/tf_install.sh

WORKDIR /
