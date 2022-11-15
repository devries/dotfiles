export EDITOR=nvim
alias rm='rm -i'
alias mv='mv -i'
alias ls='ls -F'
alias graphlog="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

alias vim='/usr/local/bin/nvim'

# Load git prompt as set prompt
# from https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=True
source ~/.git_prompt.sh
export PS1='\h:\W$(__git_ps1 " (%s)")> '
export HISTTIMEFORMAT="%d/%m/%y %T "
