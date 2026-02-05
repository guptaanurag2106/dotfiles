export ZSH="/home/tanz/.oh-my-zsh"
export XDG_CURRENT_DESKTOP=sway
export EDITOR=vim

ZSH_THEME="robbyrussell"


plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  fzf-tab
  z
)

source $ZSH/oh-my-zsh.sh
#export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export XDG_CONFIG_HOME=~/.config

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

if [ -d "$HOME/.cargo/bin" ] ; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/go/bin" ] ; then
   export PATH="$HOME/go/bin:$PATH"
fi
export PATH="$HOME/opt/gf:$PATH"
#export PATH="${PATH}:${HOME}/.local/bin/"


if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# export TERM=tmux-256color
help2() {
  local cmd
  cmd="$(uwu "$@")" || return
  vared -p "" -c cmd
  print -s -- "$cmd"
  eval "$cmd"
}

alias todo='task rc.verbose=nothing rc.color=off rc.annotations=off rc.defaultwidth=0 \
     shell status:pending due.before:tomorrow sort:urgency-'
todo
[[ -f ~/.profile ]] && source ~/.profile

loadsecrets() {
  local env_file="$HOME/.env"

  if [[ -f "$env_file" ]]; then
    set -a
    source "$env_file"
    set +a
    echo "Loaded environment from $env_file"
  else
    echo "No .env file found in $(pwd)"
    return 1
  fi
}

alias dns-cloudf='sudo resolvectl dns wlp0s20f3 1.1.1.1'
alias dns-pihole='sudo resolvectl revert wlp0s20f3'
