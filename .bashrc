export PATH=/usr/local/bin:$PATH

export NVM_DIR="/Users/phadviger/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:/Users/phadviger/apprunner/AppRunner:$HOME/.rvm/bin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
