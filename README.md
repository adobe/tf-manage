# tf-manage
A simple Terraform wrapper for organising your code and workflow.

## Advantages
- structure your code logically
- easy to re-use code (DRY)
- separation (and isolation) of enviroments
- team collaboration
- auto-completion
- reduced human error
- easy onboarding

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
# clone this repo (directly with submodules)
git clone --recurse-submodules -j8 git@git.corp.adobe.com:Target-ops/tf-manage.git

# clone repo and get submodules in separate steps
git clone git@git.corp.adobe.com:Target-ops/tf-manage.git
git submodule init
git submodule update

# run installer
# this will install:
# - terraform itself
# - the tf wrapper
# - and bash completion for the wrapper
./tf-manage/bin/tf_install.sh

# you can customize the version of terraform that is installed
./tf-manage/bin/tf_install.sh 0.12.24
```

## Examples
### terraform init
![tf init](/docs/images/init.svg)
