###########################################################################
#                                 For zaw                                 #
###########################################################################
if [ -f  ~/.zsh.d/zaw/zaw.zsh ] ;then
    autoload -Uz select-word-style
    select-word-style default
    zstyle ':zle:*' word-chars " /:@+|"
    zstyle ':zle:*' word-style unspecified


    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both

    [ -f ~/.zsh.d/zaw/zaw.zsh ] && source ~/.zsh.d/zaw/zaw.zsh
    bindkey '^R' zaw-history
    zstyle ':filter-select' case-insensitive yes # 絞り込みをcase-insensitiveに
    zstyle ':filter-select' extended-search yes # see below
    stty -ixon
    bindkey '^S' zaw-cdr # zaw-cdrをbindkey
    bindkey '^X^S' zaw-git-status
    bindkey '^U' zaw-git-branches
    bindkey '^T' zaw-tmux
    bindkey -M filterselect '^E' accept-search
    [ -f  ~/.bibtex_source/bibtex.zsh ] && source ~/.bibtex_source/bibtex.zsh
    zstyle ':filter-select:highlight' selected bg=cyan,standout
fi



###########################################################################
#                           For zsh-completions                           #
###########################################################################
fpath=(~/.zsh.d/zsh-completions/src(N-/) $fpath)


######################
# For zsh-vcs-prompt #
######################
#source ~/.zsh.d/zsh-vcs-prompt/zshrc.sh
ZSH_VCS_PROMPT_ENABLE_CACHING='true'

ZSH_VCS_PROMPT_AHEAD_SIGIL='↑'
ZSH_VCS_PROMPT_BEHIND_SIGIL='↓'
ZSH_VCS_PROMPT_STAGED_SIGIL='A'
ZSH_VCS_PROMPT_CONFLICTS_SIGIL='U'
ZSH_VCS_PROMPT_UNSTAGED_SIGIL='M'
ZSH_VCS_PROMPT_UNTRACKED_SIGIL='?'
ZSH_VCS_PROMPT_STASHED_SIGIL='S'
ZSH_VCS_PROMPT_CLEAN_SIGIL='✔'
ZSH_VCS_PROMPT_HIDE_COUNT='true'

## Git without Action.
# VCS name
# ZSH_VCS_PROMPT_GIT_FORMATS='(%{%B%F{magenta}%}#s%{%f%b%})'
ZSH_VCS_PROMPT_GIT_FORMATS=''
# Branch name
ZSH_VCS_PROMPT_GIT_FORMATS+='%F{blue}<%f%b%{%F{green}%}#b%{%f%}'
# Ahead and Behind
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{red}%}#c#d%{%F{blue}%}|%{%f%b%}'
# Staged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{blue}%}#e%{%f%b%}'
# Conflicts
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{red}%}#f%{%f%b%}'
# Unstaged
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{yellow}%}#g%{%f%b%}'
# Untracked
ZSH_VCS_PROMPT_GIT_FORMATS+='#h'
# Stashed
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{yellow}%}#i%{%f%b%}'
# Clean
ZSH_VCS_PROMPT_GIT_FORMATS+='%{%F{green}%}#j%{%f%b%}%F{blue}>%f%b'

### Git with Action.
# VCS name
# ZSH_VCS_PROMPT_GIT_FORMATS='(%{%B%F{magenta}%}#s%{%f%b%})'
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS=''
# Branch name
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%B%F{black}<%f%b%{%B%F{green}%}#b%{%f%b%}'
# Action
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+=':%{%B%F{red}%}#a%{%f%b%}'
# Ahead and Behind
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='#c#d%B%F{black}|%f%b'
# Staged
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{blue}%}#e%{%f%b%}'
# Conflicts
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{red}%}#f%{%f%b%}'
# Unstaged
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{yellow}%}#g%{%f%b%}'
# Untracked
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='#h'
# Stashed
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{yellow}%}#i%{%f%b%}'
# Clean
ZSH_VCS_PROMPT_GIT_ACTION_FORMATS+='%{%F{green}%}#j%{%f%b%}%B%F{black}>%f%b'


# zsh-bd
# https://github.com/Tarrasch/zsh-bd

if [ -f  ~/.zsh.d/plugins/zsh-bd/bd.zsh ] ;then
    source ~/.zsh.d/plugins/zsh-bd/bd.zsh
else
    print "Please install zsh-bd"
fi
