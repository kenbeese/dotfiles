###############################################
# For prompt                                  #
###############################################

##### For Screen for bash?
# if [ $TERM = 'screen' ]; then
#     PROMPT_COMMAND='echo -ne "\ek\e\\"; echo -ne "\ek$shorthost$(basename $(pwd))\e\\"'
#     function t ()
#     {
#        echo -ne "\ek$1${2+ $2}${3+ $3}\e\\"
#       "$@"
#     }
# fi
setopt prompt_subst    # エスケープシーケンスをそのまま渡すのに必要
                                # 現在のプロンプトの設定には必須
setopt transient_rprompt                    # 右プロンプトに入力がきたら消す
autoload colors
colors

export TERM=$TERM
export HOST=$HOST

# Color shortcuts
RED=$fg[red]
YELLOW=$fg[yellow]
GREEN=$fg[green]
WHITE=$fg[white]
BLUE=$fg[blue]
CYAN=$fg[cyan]
BLACK=$fg[black]
RED_BOLD=$fg_bold[red]
YELLOW_BOLD=$fg_bold[yellow]
GREEN_BOLD=$fg_bold[green]
WHITE_BOLD=$fg_bold[white]
BLUE_BOLD=$fg_bold[blue]
CYAN_BOLD=$fg_bold[cyan]
BLACK_BOLD=$fg_bold[black]
RESET_COLOR=$reset_color



# %B Enable bold, %b disable bold, %F{color} enbale color, %f disable color
# Format for git_prompt_status()
ZSH_THEME_GIT_PROMPT_UNMERGED="%B%F{black}(%b%F{red}UU%B%F{black})%f%b"
ZSH_THEME_GIT_PROMPT_DELETED="%B%F{black}(%b%F{red}D%B%F{black})%f%b"
ZSH_THEME_GIT_PROMPT_MODIFIED="%B%F{black}(%b%F{yellow}M%B%F{black})%f%b"

ZSH_THEME_GIT_PROMPT_RENAMED="%B%F{black}(%b%F{green}R%B%F{black})%f%b"
ZSH_THEME_GIT_PROMPT_ADDED="%B%F{black}(%b%F{green}A%B%F{black})%f%b"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%B%F{black}(%b%F{white}??%B%F{black})%f%b"
# Format for git_prompt_stash()
ZSH_THEME_GIT_PROMPT_STASHED="%B%F{black}(%b%F{yellow}S%B%F{black})%f%b"
# Format for git_prompt_ahead_or_behind()
ZSH_THEME_GIT_PROMPT_AHEAD="%B%F{black}(%b%F{red}=>%B%F{black})%f%b"
ZSH_THEME_GIT_PROMPT_BEHIND="%B%F{black}(%b%F{red}<=%B%F{black})%f%b"


local smiley='\`-'"%(?,%{$fg[blue]%}>%{$reset_color%},%{$fg[red]%}>%{$reset_color%})"

function lines_separator() {
    local git_info git_bname color_prmpt num line_num
    local line='-'
    if [ $OSTYPE = cygwin ]; then
        git_info=""
    else
        git_info=$(vcs_super_info)
    fi
    color_prmpt="%{$BLUE_BOLD%}.-%{$reset_color%}%{$BLUE%}[%{$reset_color%}%{$CYAN%}%~%{$BLUE%}]%{$reset_color%}${git_info}%{$reset_color%}"
    num=${#${(S%%)color_prmpt//(\%([KF1]|)\{*\}|\%[Bbkf])}}
    line_num=$((${COLUMNS} - ${num} - 1))
    echo "${color_prmpt}%{$BLUE_BOLD%}${(l:${line_num}::-:)line}"
}

case ${UID} in
0)
  PROMPT=$'%{${fg[red]}%}%n@%m %{${fg[cyan]}%}[%/]%{${fg[red]}%}\n#%{${reset_color}%}%b '
  # PS1=$PROMPT
#  PROMPT="%B%{${fg[red]}%}%/#%{${reset_color}%}%b "
  PROMPT2="%B%{${fg[red]}%}%_#%{${reset_color}%}%b "
  SPROMPT="%B%{${fg[red]}%}%r is correct? [n,y,a,e]:%{${reset_color}%}%b "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="%{${fg[white]}%}${HOST%%.*} ${PROMPT}"
  ;;
*)
  PROMPT=$'$(lines_separator)\n'"${smiley}%b "
  # RPROMPT="%{${fg[yellow]}%} <%{${fg[yellow]}%}Jobs:%j>%{${reset_color}%}"
  RPROMPT=$'%{$BLACK_BOLD%}<%{$reset_color%}%{$GREEN%}%n@%m%{${reset_color}%}%{$BLACK_BOLD%}>%{$reset_color%}'
  PROMPT2="%{$GREEN%}%_%%%{${reset_color}%} "
  SPROMPT="%{$GREEN%}%r is correct? [n,y,a,e]:%{${reset_color}%} "
  [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="%{$YELLOW%}@${HOST%%.*}"$'\n'"${PROMPT}"
  ;;
esac
