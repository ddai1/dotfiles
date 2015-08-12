#After running brew install bash, you can change the default shell safely by:
#- Adding /usr/local/bin/bash to /etc/shells
#- Running chsh -s /usr/local/bin/bash.

source ~/.sources/*.source
source ~/.bashrc

function growl() { echo -e $'\e]9;'${1}'\007' ; return ; }
function cwd() { cd "$(dirname $(which "${1}"))"; }
# Note, this function is only needed on OSX, linux has du -h | sort -h that can be used
function dus() { du -x -d 1 | sort -n | cut -f 2 | sed "s/'/\\\'/" | xargs -L1 -I {} du -h -x -d 0 "{}";  }
function root() {
  mkdir -p "${1}" && touch "${1}/.root"
}
function sum_files() {
  local MASK="$1"
  if [[ -z "${MASK}" ]]; then
    echo "Please provide a mask"
    return 1
  fi
  find . -type f -iname "${MASK}" -exec du '{}' \; | awk '{print $1}' | paste -s -d '+' - | bc | awk '{GB=$1/1024/1024; print GB}'
}
function aa_16 () {
for clbg in {40..47} {100..107} 49 ; do
  #Foreground
  for clfg in {30..37} {90..97} 39 ; do
    #Formatting
    for attr in 0 1 2 4 5 7 ; do
      #Print the result
      echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
    done
    echo #Newline
  done
done
}
# might need this: tset xterm-256color
function aa_256 () {
  ( x=`tput op` y=`printf %$((${COLUMNS}-6))s`;
  for i in {0..256};
  do
    o=00$i;
    echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;
  done )
}

function nvmrc () {
  # swtich to the nodejs version automatically, if an .nvmrc file is found in the current dir.
  [[ -f .nvmrc ]] || return 0
  local CURRENT_VERSION="$(nvm current)"
  local DESIRED_VERSION="$(<.nvmrc)"
  if [[ "${CURRENT_VERSION#*v}" != "${DESIRED_VERSION#*v}" ]]; then
    nvm use
  fi
}
export PROMPT_COMMAND="nvmrc"

function git_cleanup () {
local AREYOUSURE
read -e -p "type 'delete' to clean up merged branches, or anything else to see what would be cleaned up: " -i demo AREYOUSURE
if [[ "${AREYOUSURE}" == "delete" ]]; then
  git branch --no-color --merged | grep -v "\*" | while read BRANCH; do git branch -d "${BRANCH}" ; done
else
  echo "Preview of what would be cleaned up:"
  git branch --no-color --merged | grep -v "\*" | while read BRANCH; do echo "${BRANCH}" ; done
fi
}
function git_branch_age () {
#for k in `git -r branch|sed s/^..//`;do echo -e `git log -1 --pretty=format:"%Cgreen%ci %Cblue%cr%Creset" "$k"`\\t"$k";done|sort
#git for-each-ref --sort='-authordate' --format='%(refname)%09%(authordate)' refs/remotes/origin | sed -e 's-refs/remotes/origin/--'
:
}
function webshare () {
local PORT=8001
while lsof -iTCP@0.0.0.0:$PORT >> /dev/null 2>&1;
do
  let PORT+=1
  sleep 0.1
done
python -m SimpleHTTPServer $PORT
}

# History date format
export HISTTIMEFORMAT="%y/%m/%d %T "
# Ignore dupliate commands even if there is a space difference, and don't save them to history
export HISTCONTROL="erasedups:ignoreboth"
# Number of commands to save
export HISTSIZE=500000
# History maxiumum file size
export HISTFILESIZE=50000
# Ignore exit commands from history
export HISTIGNORE="&:[ ]*:exit"
# Never overwrise history, always append
shopt -s histappend
# Multiline commands become one line
shopt -s cmdhist

# 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
COLOR_CLEAR="\[\e[0m\]"
COLOR_GREEN="\[\e[0;32m\]"
COLOR_LGREEN="\[\e[1;32m\]"
COLOR_YELLOW="\[\e[0;33m\]"
COLOR_RED="\[\e[0;31m\]"
COLOR_CYAN="\[\e[0;36m\]"
COLOR_LCYAN="\[\e[1;36m\]"

export PS1="${COLOR_CLEAR}
\t ${COLOR_YELLOW}\w${COLOR_CLEAR} \$(git_ps1_info)
${COLOR_LGREEN}→${COLOR_CLEAR} "

#export PS1="${COLOR_CLEAR}
#\t ${COLOR_GREEN}\u${COLOR_CLEAR}@${COLOR_LCYAN}\h
#${COLOR_YELLOW}\w${COLOR_CLEAR} \$(git_ps1_info)
#${COLOR_LGREEN}→${COLOR_CLEAR} "

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

#calculator with math support
alias bc='bc -l'

#sha1 digest
#alias sha1='openssl sha1'

#show a nice path
alias path='echo -e ${PATH//:/\\n}'

#show a code tree
alias ctree='\tree -a -I .git'

#history + percol - date
alias hp="history | percol | awk '{\$1=\$2=\$3=\"\"; print \$0;}'"

# -A      List all entries except for . and ...  Always set for the super-user.
# -F      Display a slash ('/') immediately after each pathname that is a directory, an asterisk ('*') after each that is executable, an at sign ('@') after each symbolic link,
#         an equals sign ('=') after each socket, a percent sign ('%') after each whiteout, and a vertical bar ('|') after each that is a FIFO.
# -G      Enable colorized output.
# -h      When used with the -l option, use unit suffixes: Byte, Kilobyte, Megabyte, Gigabyte, Terabyte and Petabyte in order to reduce the number of digits to three or less
#         using base 2 for sizes.
alias ls="ls -AFGh"
# ls -d1 */	# list directories in current dir
# ls -1 M*	# list directories only starting with M
# \ls		# ingore alias for ls

# Flush DNS on Lion + Mountain Lion
alias flushdns="sudo killall -HUP mDNSResponder"

alias mux='tmux has && tmux -2 attach || tmux -2 new'

alias mirror00="rsync -avzr --delete --exclude '.fseventsd' --exclude '.DS_Store' --exclude '*.Trashes*' --exclude '.Spotlight*' /Volumes/Backup/ /Volumes/Pc/_mirror"
alias offload00="rsync -avzr --exclude '.fseventsd' --exclude '.DS_Store' --exclude '*.Trashes*' --exclude '.Spotlight*' /tmp/test/* /Volumes/Backup/Extract"
alias extract00='find -E . -type f -iregex ".*(mov|m4v|mp4)" -exec rsync -avR --remove-source-files {} /tmp/test \;'
alias docker_shell='eval "$(boot2docker shellinit)"'
alias mailserver='sudo python -m smtpd -n -c DebuggingServer localhost:25'

