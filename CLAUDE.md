# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Bash/Zsh Development Environment Setup Tool that automates the configuration of shell environments with special support for Windows Subsystem for Linux (WSL).

## Key Commands

### Installation and Updates
- **Initial Installation**: Run from remote URL (see readme.md)
- **Update Environment**: `~/devenv/update.sh` - Pulls latest changes and regenerates RC files
- **Install Zsh Plugins**: `zsh ~/devenv/install_plugins.zsh`

### Development Workflow
1. Make changes to template files in `template/` directory
2. Run `~/devenv/update.sh` to test changes locally
3. Commit changes to git when satisfied

### Testing Changes
- After modifying templates, run `update.sh` to regenerate `.devzshrc` or `.devbashrc`
- Source the updated RC file: `source ~/.devzshrc` or `source ~/.devbashrc`
- Test functionality in a new shell session

## Architecture

### Core Components
- **install.sh**: Entry point that clones repo and runs initial setup
- **update.sh**: Regenerates RC files from templates and updates plugins
- **template/**: Contains modular configuration files
  - `rc_bash.sh`: Bash-specific settings
  - `rc_zsh.sh`: Zsh-specific settings  
  - `aliases.sh`: Common aliases for both shells
  - `wsl.sh`: WSL-specific configurations (Windows SSH integration)

### Generated Files
- `~/.devzshrc` or `~/.devbashrc`: Generated RC files (DO NOT EDIT DIRECTLY)
- `~/devenv-plugins/`: Directory for auto-updating git-based plugins

### Key Design Decisions
1. **Template System**: All configurations are generated from templates to ensure consistency
2. **Non-invasive**: Creates separate RC files rather than modifying system files
3. **WSL Integration**: Redirects SSH commands to Windows OpenSSH binaries when in WSL
4. **Auto-update**: Both the environment and plugins can be updated with `update.sh`

## Important Notes

- When modifying shell configurations, always edit files in `template/` directory
- The `{[win_home]}` placeholder in `wsl.sh` is replaced with the Windows home path during generation
- Error handling uses `set -e` and explicit error checks for robustness
- The script supports both bash and zsh by detecting shell version variables
- WSL detection is done by checking for "Microsoft" in `/proc/version`