export ZSH="/home/tanz/.oh-my-zsh"
export XDG_CURRENT_DESKTOP=sway
export EDITOR=vim

ZSH_THEME="clean"


plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  tmux
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -d "$HOME/.cargo/bin" ] ; then
   export PATH="$HOME/.cargo/bin:$PATH"
fi
export PATH="$HOME/.config/emacs/bin:$PATH"
export PATH="$HOME/Documents/dev/projects/cpp_libs/emsdk:$PATH"
export PATH="$HOME/Documents/dev/projects/cpp_libs/emsdk/upstream/emscripten:$PATH"

# general use aliases 
alias ls='exa' # just replace ls by exa and allow all other exa arguments
alias l='ls -lbF' #   list, size, type
alias ll='ls -la' # long, all
alias llm='ll --sort=modified' # list, long, sort by modification date
alias la='ls -lbhHigUmuSa' # all list
alias lx='ls -lbhHigUmuSa@' # all list and extended
alias tree='exa --tree' # tree view
alias lS='exa -1' # one column by just names

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
