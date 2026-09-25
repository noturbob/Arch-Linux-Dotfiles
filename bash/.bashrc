#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias code="code --enable-features=UseOzonePlatform --ozone-platform=wayland"

. "$HOME/.local/bin/env"
export PATH=$PATH:$HOME/go/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="$HOME/.local/share/flutter/bin:$HOME/.local/share/flutter/bin/cache/dart-sdk/bin:$PATH"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"

# Powerline prompt (Catppuccin Mocha blues, tinted toward the background so it reads as translucent; needs a Nerd Font)
. /usr/share/git/completion/git-prompt.sh
__prompt() {
  # *_bg = accent blended ~30% into base #1E1E2E, text = the full accent
  local lav='180;190;254' lav_bg='90;94;129' blue='137;180;250' blue_bg='64;78;111' sap='116;199;236' sap_bg='52;74;95'
  [ -r ~/.cache/themely/prompt.sh ] && . ~/.cache/themely/prompt.sh  # themely: current theme's colors, read every prompt
  local fg='\[\e[38;2;' bg='\[\e[48;2;' r='\[\e[0m\]' sep=$'' last=$blue_bg
  __branch=$(__git_ps1 '%s')  # referenced as \${__branch} so branch names can't inject commands
  PS1="${fg}${lav_bg}m\]"$''"${bg}${lav_bg}m\]${fg}${lav}m\] \u@\h ${bg}${blue_bg}m\]${fg}${lav_bg}m\]$sep${fg}${blue}m\] \W "
  if [[ -n $__branch ]]; then
    PS1+="${bg}${sap_bg}m\]${fg}${blue_bg}m\]$sep${fg}${sap}m\] "$''" \${__branch} "
    last=$sap_bg
  fi
  PS1+="$r${fg}${last}m\]$sep$r "
}
PROMPT_COMMAND="__prompt${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
