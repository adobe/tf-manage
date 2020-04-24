# tf-manage

## Changelog

### 5.0.0
- [breaking] the default Terraform version to install is now 0.12.24

### 4.6.0
- [changed] removed hardcoded repo in the installer to allow support for custom forks
- [changed] moved character for generated tf workspaces into a variable to easier customization

### 4.5.4
- [fix] Fixed HEREDOC errors that appear on Mac's running newer versions of bash

### 4.5.3
- [changed] the default Terraform version to install is now 0.11.8
- [fix] Fixed MacOS instructions
- [fix] "unattended" mode now works for "terraform destroy" commands as well

### 4.5.2
- [added] MacOS requirement instructions

### 4.5.1
- [added] update readme and installer with instructions for linux (yum-based)

### 4.5.0
- [added] installer is now embedded in the same repository
- [added] created [README.md](README.md), with usage demo recording

### 4.4.1
- [fix] "apply_tfplan" action now correctly runs "terraform apply"
- [changed] used a different color for "operator" mode, to stand out from the wrapper argument value validations

### 4.4.0
- [added] "unattended" mode now refuses input for "apply" commands and auto-accepts changes

### 4.3.1
- [fix] fix $USER env var evaluation

### 4.3.0
- [added] initial support for running in CI environments

### 4.2.4, 4.2.5, 4.2.6
- [fix] HEREDOC syntax errors and regressions

### 4.2.3
- [added] proper detection of OSX vs Linux environments

### 4.2.2
- [fix] attempting to use tf completion in a git-less folder, no longer exists your shell

### 4.2.1
- [vendor] aemm-sre-tools/bash-framework moved to mob-sre-tools/bash-framework (the org was renamed)

### 4.2.0
- [removed] we no longer validate against a strict list of allowed products

### 4.1.2
- [fix] properly suggest products from current repo, instead of all allowed products

### 4.1.1
- [added] "ops" as allowed product until we can automatically rename workspaces with a helper script
- [fix] environment folder checks now show correct paths to check in error message

### 4.1.0
- [removed] "ops" no longer allowed product
- [added] "ROOT" is a new allowed product
    + not suggested by the completion script, but still valid
    + used to create the remote state "inception" stack (first_state)

### 4.0.0
- [vendor] upgrade to bash-framework 0.6.1
- [removed] product name from .tfm config
- [added] product name parameter
- [changed] var-files are now found under `terraform/environment/${product}/${env}/${module}/${component}.tfvars`

### 3.4.1
- [fix] workspace check regex is no longer sensitive to workspaces with names that are substring of others
- [vendor] upgrade to bash-framework 0.6.0

### 3.4.0
- [added] new commands: fmt
- [fix] init command: no longer relies on workspace validation

### 3.3.1
- [fix] broken reference after variable refactoring

### 3.3.0
- [enhancement] renamed wrapper commands to better match post 0.11.x default behaviours
    + apply --> apply_tfplan
    + plan_and_apply --> apply

### 3.2.0
- [removed] auto-init each run (was too time consuming and did not work well for all use cases)
- [fix] refactored project paths
- [added] extra notice when creating .tfplan files

### 3.1.1
- [enhancement] refactored computerd project paths

### 3.1.0
- [enhancement] .tfvars suggestsions no longer contain redundant extensions in the suggestions

### 3.0.1
- [fix] tfvars suggestions also included .tfplan files

### 3.0.0
- [added] new workspace naming convention
- [enhancement] removed code duplication for common value computation

### 2.0.1
- [fix] __tfm_project_config_path var was broken

### 2.0.0
- [added] new commands: plan_and_apply (terraform 0.11+ only)
- [enchacement] now running init before all commands
- [fix] .tfplan file names are now unique for each var-file

### 1.3.0
- [added] new commands: init

### 1.2.1
- [fix] destroy command
- [enchacement] now printing terraform command on destroy
- [enchacement] now printing terraform command on plan

### 1.2.0
- [added] new commands: output and refresh
- [enchacement] now printing terraform command on apply

### 1.1.0
- [added] support for plan file
- [added] workspace override
- [added] whitelist entry for ops projects

### 1.0.2
- enhanced wrapper messages, to better reflect impact

### 1.0.1
- clean extra newlines

### 1.0.0
- first functional wrapper with support for plan, apply and destroy
- upgrade to bash-framework v0.4.3
- terraform workspaces are automatically created/selected
- [added] product/component/workspace validation
- [added] controller for wrapping terraform commands
- [added] encouraging error message for failed terraform commands

### 0.2.0
- upgrade to bash-framework v0.3.0
- [added] strict check that we're in a git repository (hopefully a terraform module one)
- [added] module/env/action validation
- [changed] dynamically built module/env paths are now exported for reuse when loading the config
- [added] first terraform wrapped command

### 0.1.0
First draft with:
- bash-framework v0.2.0
- config parser for customizing the terraform module folder structure
- `tf.sh`: main Terraform wrapper entrypoint
- `tf_complete.sh`: bash completion with shared logic
