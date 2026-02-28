# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages configuration files for zsh, vim, tmux, and git. It uses symlinks to install configurations from `~/.dotfiles` to the home directory and git submodules for external plugins.

## Installation and Updates

**Initial installation:**
```bash
./install
```

**Update mode (skip existing symlinks and ssh key generation):**
```bash
./install -u
```

**Update dotfiles from remote:**
```bash
dfu  # alias defined in zsh/aliases.sh - pulls and re-runs install
```

The install script:
- Updates all git submodules
- Creates symlinks for vim, zsh, tmux, and git configs
- Sets up git global config (user.name, user.email, excludesfile, include.path)
- Generates SSH keys (initial install only)

## Architecture

### ZSH Configuration Loading Order

The zsh configuration follows a specific loading sequence in `zsh/zshrc`:

1. `zsh/functions.sh` - PATH manipulation functions (path_remove, path_append, path_prepend)
2. `zsh/plugins_before.zsh` - Pre-initialization plugins (zsh-completions, zsh-autosuggestions)
3. `zsh/settings.zsh` - Core zsh settings (completion, history, vim keybindings)
4. `zsh/aliases.sh` - Aliases and shell functions
5. `zsh/prompt.zsh` - Prompt configuration
6. `zsh/plugins_after.zsh` - Post-initialization plugins (zsh-syntax-highlighting, dircolors)

### Vim Plugin Management

Uses Pathogen for plugin management. Plugins are stored as git submodules in `vim/bundle/`:
- lightline.vim - statusline
- nerdtree - file explorer
- nerdcommenter - commenting utilities
- vim-colors-solarized - color scheme
- vim-cpp-modern - C++ syntax highlighting

### Git Submodules

All external dependencies are managed as git submodules (see `.gitmodules`). When modifying plugin versions, use:
```bash
git submodule update --init --recursive
```

## Key Customizations

**ZSH keybindings:**
- Vi-style line editing (`bindkey -v`)
- Ctrl-R for incremental search
- Menu completion with hjkl navigation

**Vim keybindings:**
- Leader-n: Toggle NERDTree
- Leader-f: Find current file in NERDTree
- Ctrl-hjkl: Window navigation
- H/L: Line beginning/end

**Shell functions in zsh/aliases.sh:**
- `mcd DIR` - mkdir and cd
- `up [N]` - go up N directories
- `xin DIR CMD...` - execute command in directory
- `cdgr` - cd to git root
- `dfu` - update dotfiles from remote

## File Organization

- `/git/` - Global git configuration and ignore patterns
- `/shell/` - Shell plugins (dircolors-solarized)
- `/tmux/` - Tmux configuration and plugins
- `/vim/` - Vim configuration, plugins, and file-type settings
- `/zsh/` - Zsh configuration files and plugins

## Important Notes

- The repository expects to be cloned/linked to `~/.dotfiles`
- API keys are currently hardcoded in `zsh/zshrc` (lines 54-55) - these should be moved to a local, non-committed file
- Conda initialization is included in `zsh/zshrc` with path to `/opt/anaconda3`
- The config is set up for macOS (darwin) and Linux compatibility with OS-specific checks
