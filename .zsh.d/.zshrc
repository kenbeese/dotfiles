#zmodload zsh/zprof

[ -f ~/.zsh.d/environment.zsh ] && source ~/.zsh.d/environment.zsh
[ -f ~/.zsh.d/alias.zsh ] && source ~/.zsh.d/alias.zsh
[ -f ~/.zsh.d/plugins.zsh ] && source ~/.zsh.d/plugins.zsh
[ -f ~/.zsh.d/completion.zsh ] && source ~/.zsh.d/completion.zsh
[ -f ~/.zsh.d/git.zsh ] && source ~/.zsh.d/git.zsh
[ -f ~/.zsh.d/history.zsh ] && source ~/.zsh.d/history.zsh
[ -f ~/.zsh.d/prompt.zsh ] && source ~/.zsh.d/prompt.zsh
[ -f ~/.zsh.d/etc.zsh ] && source ~/.zsh.d/etc.zsh
[ -f ~/.zsh.d/local.zsh ] && source ~/.zsh.d/local.zsh

if which pyenv > /dev/null; then eval "$(pyenv init -)";fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)";fi


#zprof
