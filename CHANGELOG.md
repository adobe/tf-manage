# tf-manage

## Changelog
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
