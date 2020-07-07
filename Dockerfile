FROM centos:8

RUN yum -y install wget sudo unzip git bash-completion which

RUN echo "alias ll='ls -la'" >> /root/.bashrc

WORKDIR /opt/tf-manage
COPY ./ ./

RUN /opt/tf-manage/bin/tf_install.sh

WORKDIR /
