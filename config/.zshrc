export ZSH="/home/tanz/.oh-my-zsh"
export XDG_CURRENT_DESKTOP=sway
export EDITOR=nvim

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

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

if [ -d "$HOME/.cargo/bin" ] ; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi
#export PATH="$HOME/.config/emacs/bin:$PATH"
#export PATH="$HOME/Documents/dev/projects/cpp_libs/emsdk:$PATH"
#export PATH="$HOME/Documents/dev/projects/cpp_libs/emsdk/upstream/emscripten:$PATH"
export PATH="$HOME/opt/gf:$PATH"
export PATH="${PATH}:${HOME}/.local/bin/"
export PATH="${PATH}:${HOME}/go/bin/"


if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/tanz/opt/raylib-5.5_linux_amd64/lib

# export TERM=tmux-256color
help() {
  local cmd
  cmd="$(uwu "$@")" || return
  vared -p "" -c cmd
  print -s -- "$cmd"
  eval "$cmd"
}
