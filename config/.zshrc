export ZSH="/home/tanz/.oh-my-zsh"
export XDG_CURRENT_DESKTOP=sway
export EDITOR=vim

ZSH_THEME="robbyrussell"


plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
#  tmux
  fzf-tab
  # zsh-vi-mode
  z
)

source $ZSH/oh-my-zsh.sh
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
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
export PATH="${PATH}:${HOME}/.local/bin/"


if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/tanz/opt/raylib-5.5_linux_amd64/lib

# export TERM=tmux-256color
help2() {
  local cmd
  cmd="$(uwu "$@")" || return
  vared -p "" -c cmd
  print -s -- "$cmd"
  eval "$cmd"
}

alias todo='task "(due:today or status:pending)" sort:priority-,urgency- limit:5'
