#!/bin/sh
LC_ALL="" LC_CTYPE="en_US.UTF-8"

### Check if properties are set, if not set the default

# Icons setting.
DYEN_SEGMENT_SEPARATOR="${DYEN_SEGMENT_SEPARATOR:-\u25E4}" # ◤
DYEN_STARTING_CHAR="${DYEN_STARTING_CHAR:-\u25E2}"         # ◢
DYEN_PROMPT_CHAR="${DYEN_PROMPT_CHAR:-\u21C1 }"            # ⇁
DYEN_BRANCH_ICON="${DYEN_BRANCH_ICON:-\ue0a0}"             # 
DYEN_FLAKE_ICON="${DYEN_FLAKE_ICON:-\u2744\uFE0F }"        # ❄️
DYEN_SHELL_ICON="${DYEN_SHELL_ICON:-\U1f41a}"              # 🐚
DYEN_SSH_ICON="${DYEN_SSH_ICON:-\U1f511}"                  # 🔑

# Color settings
DYEN_SSH_BG="${DYEN_SSH_BG:-236}"
DYEN_SSH_FG="${DYEN_SSH_FG:-196}"
DYEN_CONTEXT_BG="${DYEN_CONTEXT_BG:-92}"
DYEN_CONTEXT_FG="${DYEN_CONTEXT_FG:-15}"
DYEN_DIR_BG="${DYEN_DIR_BG:-196}"
DYEN_DIR_FG="${DYEN_DIR_FG:-0}"
DYEN_GIT_BG="${DYEN_GIT_BG:-37}"
DYEN_GIT_FG="${DYEN_GIT_FG:-0}"
DYEN_GIT_DIRTY_BG="${DYEN_GIT_DIRTY_BG:-214}"
DYEN_GIT_DIRTY_FG="${DYEN_GIT_DIRTY_FG:-0}"
DYEN_SHELL_BG="${DYEN_SHELL_BG:-8}"
DYEN_SHELL_FG="${DYEN_SHELL_FG:-15}"
DYEN_ACTIVE_SHELL_BG="${DYEN_ACTIVE_SHELL_BG:-33}"
DYEN_ACTIVE_SHELL_FG="${DYEN_ACTIVE_SHELL_FG:-15}"


### Utility variables and functions.

# Reusable colors.
CURRENT_BG='NONE'

# Generate a new segment. Takes 3 args:
# 1) background color;
# 2) foreground color;
# 3) content.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n "%{$bg%F{$CURRENT_BG}%}$DYEN_SEGMENT_SEPARATOR%{$fg%}"
  else
    echo -n "\n%k%F{$1}$DYEN_STARTING_CHAR%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# Function to end the promt. It clears colors.
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$DYEN_SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}\n $DYEN_PROMPT_CHAR"
  CURRENT_BG=''
}



### Prompts components.

# Ssh: show if is connected through ssh.
prompt_ssh() {
  if [[ -n "$SSH_CONNECTION" ]]; then
    prompt_segment $DYEN_SSH_BG $DYEN_SSH_FG " [SSH]$DYEN_SSH_ICON "
  fi
}

# Context: user@hostname (who am I and where am I)
prompt_context() {
  prompt_segment $DYEN_CONTEXT_BG $DYEN_CONTEXT_FG " $(whoami)@%m "
}

# Dir: current working directory
prompt_dir() {
  prompt_segment $DYEN_DIR_BG $DYEN_DIR_FG ' %~ '
}

# Git infos
git_branch() {
  (( $+commands[git] )) || return
  local user branch repo_path dirty bg_color fg_color mode
  branch=$(git rev-parse --abbrev-ref --symbolic-full-name HEAD 2>/dev/null)
  repo_path=$(git rev-parse --git-dir 2>/dev/null)
  dirty=$(git status --porcelain --ignore-submodules 2> /dev/null)
  user=$(git config user.name 2> /dev/null)

  if [[ -n $dirty ]]; then
    bg_color=$DYEN_GIT_DIRTY_BG
    fg_color=$DYEN_GIT_DIRTY_FG
  else
    bg_color=$DYEN_GIT_BG
    fg_color=$DYEN_GIT_FG
  fi
  
  if [[ -e "${repo_path}/BISECT_LOG" ]]; then
    mode=" <B>"
  elif [[ -e "${repo_path}/MERGE_HEAD" ]]; then
    mode=" >M<"
  elif [[ -e "${repo_path}/rebase" || -e "${repo_path}/rebase-apply" || -e "${repo_path}/rebase-merge" || -e "${repo_path}/../.dotest" ]]; then
    mode=" >R>"
  fi

  if [[ "$branch" = "HEAD" ]]; then
    branch="DETATCHED!"
  fi

  [[ -n "$branch" ]] && [[ -n "$user" ]] && prompt_segment $bg_color $fg_color " $user on $DYEN_BRANCH_ICON $branch$mode "
}

# Function to check if in a nix-shell
nix_shell() {
  local info=""
  local bg_color=$DYEN_SHELL_BG
  local fg_color=$DYEN_SHELL_FG
  local shell_name 
  [[ -n $name ]] && shell_name="$name" || shell_name="nix-shell-env"
  [[ -n "$IN_NIX_SHELL" ]] && info="$info $shell_name" && bg_color=$DYEN_ACTIVE_SHELL_BG && fg_color=$DYEN_ACTIVE_SHELL_FG
  [[ -f "flake.nix" ]] && info="$info $DYEN_FLAKE_ICON"
  [[ -f "shell.nix" ]] || [[ -f "default.nix" ]] && info="$info $DYEN_SHELL_ICON"
  if [[ -n $info ]]; then
    prompt_segment $bg_color $fg_color "$info "
  fi
}

build_prompt() {
  prompt_ssh
  prompt_context
  prompt_dir
  nix_shell
  git_branch
  prompt_end
}

# Customize the prompt
setopt PROMPT_SUBST
PROMPT='$(build_prompt)'
