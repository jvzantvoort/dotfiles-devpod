# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

EDITOR="vim"
HISTCONTROL=ignoredups

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# ---------------------------------------------------------------------------- #
#                                  Functions                                   #
# ---------------------------------------------------------------------------- #
function pathmunge() {
  local dirn="$1"
  [[ -z "${dirn}" ]] && return
  [[ -d "${dirn}" ]] || return

  if echo "$PATH" | grep -E -q "(^|:)$1($|:)"; then
    return
  fi

  if [[ "$2" = "after" ]]; then
    PATH=$PATH:$1
  else
    PATH=$1:$PATH
  fi
}

# ---------------------------------------------------------------------------- #
#                                     PATH                                     #
# ---------------------------------------------------------------------------- #
pathmunge "/bin"
pathmunge "/usr/bin"
pathmunge "/usr/local/bin"

pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/sbin"

pathmunge "${HOME}/bin" "after"
pathmunge "${HOME}/.bashrc.d/bin"
pathmunge "${HOME}/.local/bin"
pathmunge "${HOME}/go/bin"

pathmunge "/usr/libexec/gcc/x86_64-redhat-linux/11" "after"

if command -v path_clean >/dev/null 2>&1; then
  PATH="$(path_clean)"
fi

export PATH

# ---------------------------------------------------------------------------- #
#                                     JAVA                                     #
# ---------------------------------------------------------------------------- #
[[ -n "${JAVA_HOME}" ]] && pathmunge "${JAVA_HOME}/bin"

# ---------------------------------------------------------------------------- #
#                                 tmux-project                                 #
# ---------------------------------------------------------------------------- #
if command -v tmux-project >/dev/null 2>&1; then
  eval "$(tmux-project shell)"
fi

# ---------------------------------------------------------------------------- #
#                                     rust                                     #
# ---------------------------------------------------------------------------- #
if [[ -f "$HOME/.cargo/env" ]]; then
  . "$HOME/.cargo/env"
fi

# ---------------------------------------------------------------------------- #
#                                     fzf                                      #
# ---------------------------------------------------------------------------- #
if [[ -e "${HOME}/.fzf/bin" ]]; then
  pathmunge "${HOME}/.fzf/bin"

  if [[ -r "${HOME}/.fzf/shell/completion.bash" ]]; then
    source "${HOME}/.fzf/shell/completion.bash" 2 >/dev/null
  fi

  if [[ -r "${HOME}/.fzf/shell/key-bindings.bash" ]]; then
    source "${HOME}/.fzf/shell/key-bindings.bash"
  fi
fi

# ---------------------------------------------------------------------------- #
#                                     PS1                                      #
# ---------------------------------------------------------------------------- #
# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
