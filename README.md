# tf-manage
A simple Terraform wrapper for organising your code and workflow.

## Requirements
### Linux
```bash
yum -y install wget sudo unzip git bash-completion which
```
### MacOS
```
brew install unzip git bash-completion gnu-which coreutils wget
```
## Installation
```bash
# clone this repo
git clone --recurse-submodules -j8 git@git.corp.adobe.com:mob-sre-tools/tf-manage.git

# run installer
# this will install terraform itself, the wrapper and bash completion for the wrapper
./tf-manage/bin/tf_install.sh

# you can customize the version of terraform that is installed
./tf-manage/bin/tf_install.sh 0.11.1
```

## Examples
### init
![tf init](/docs/images/init.svg)
