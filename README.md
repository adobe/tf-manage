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
# clone repo and
git clone --recurse-submodules git@github.com:adobe/tf-manage.git
cd tf-manage

# run installer
# this will install:
# - terraform itself
# - the tf wrapper
# - and bash completion for the wrapper
./bin/tf_install.sh

# you can customize the version of terraform that is installed
./bin/tf_install.sh 1.0.11

# after the first install, you can use tf_install directly, as it is added to $PATH
# use it as a lightweight terraform version manager to switch back and forward between multiple versions
tf_install 0.12.24
tf_install 0.13.0
tf_install 1.0.1

# in order to upgrade tf-manage or choose a different version for the wrapper itself
cd /opt/terraform/tf-manage     # go to install dir
git fetch                       # pull in new references
git checkout <tag|branch|sha>   # choose desired version

# also ensure the vendored bash-framework is also pointing to the correct version
git submodule sync
git submodule update --init --recursive --remote
```

## Validate install
The "tf" command should be registered to the PATH
```bash
$ tf
[tf] Usage: tf <product> <repo> <module> <env> <component> <action> [workspace]
```

Prepare environment for testing bash-completion
```bash
mkdir /tmp/test
cd /tmp/test
git init
```

Test bash completion by typing "tf", followed by tabs
```
tf [TAB] [TAB]
```

You should be greeted by the interactive repository initiation tutorial built into the bash-completion
```
[tf] Couldn't find tf-manage config file .tfm.conf for test
[tf] You must create it at /private/tmp/test/.tfm.conf
[tf] Or generate it, by running the snippet below:
cat > /private/tmp/test/.tfm.conf <<-EOF
#!/bin/bash
export __tfm_env_rel_path='terraform/environments'
export __tfm_module_rel_path='terraform/modules'
EOF
[tf] You can customize the values if needed
[tf] Then, re-run the script after you're done
```

## Features
### Organise
- use an intuitive folder structure that blends flexibility and scalability for the needs of most team sizes
```bash
# sample folder structure
$ tree -a -I .git
.
├── .tfm.conf
└── terraform
    ├── environments
    │   └── product1
    │       ├── env1
    │       │   └── module1
    │       │       ├── component1.tfvars
    │       │       └── component2.tfvars
    │       └── env2
    │           └── module1
    │               ├── component1.tfvars
    │               └── component2.tfvars
    └── modules
        └── module1
            └── main.tf
```
- lower risk of human error - the wrapper generates these for you
  - var-file paths (built into terraform commands that accept them)
  - unique human-friendly terraform workspace names
  - automatic workspace select and prompts for creating new ones
  - use ENV vars to substitute key parameters, when building repo copy-paste friendly documentation
- when you're ready to move to a CI environment
  - just set `export TF_EXEC_MODE_OVERRIDE="non_empty_value"`
  - this will set an internal flag that will disable user prompts and auto-accept terraform confirmations for some commands like apply and destroy.`
```bash
$ tf
[tf] Usage: tf <product> <repo> <module> <env> <component> <action> [workspace]
```

### Ease of use
- auto-completion (Bash only for now)
- simple onboarding

### Encourage best practices
- separation (and isolation) of enviroments
- reduce blast radius by writing multiple modules with different logical roles (network, dns, lb, vms, etc, alerts, monitors, etc.)
- team collaboration and onboarding is easy via terraform workspaces (auto-created/selected by the tf-manage) and a remote state implementation
- cross-team collaboration is also intuitive if both teams use the same workspace format enforced/enabled by this tool and read-only access to remote state is provided across teams

### DRY code
- write and use native Terraform code
- easy to re-use code (write module once, then create .tfvars files for your environments and module instance variations - or as we call them, "components")
- use workspaces and remote state to reference upstream module outputs in a logical and programmable-friendly manner
```
# Sample workspaces
Pattern: <product>.<repo>.<module>.<env>.<component>
Samples:
adobe-dps.network-management.vpc.prod01.services
adobe-dps.network-management.vpc.prod01.admin
adobe-dps.dps-infrastructure.elb-sg.prod01.public-appbuilder
adobe-dps.dps-infrastructure.elb.prod01.public-appbuilder
adobe-dps.dps-infrastructure.rds.prod01.public-appbuilder
adobe-dps.dps-infrastructure.ec2-sg.prod01.public-appbuilder
adobe-dps.dps-infrastructure.ec2.prod01.public-appbuilder
```

## Demos
### terraform init
![tf init](/docs/images/init.svg)
