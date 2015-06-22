alias gst='git status -s'
compdef _git gst=git-status
alias gco='git checkout'
compdef _git gco=git-checkout
alias gci='git commit -v'
compdef _git gci=git-commit
alias gba='git branch -a'
compdef _git gba=git-branch
alias gll="git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"
compdef _git glgr=git-log
alias gl="git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s' --all"
compdef _git glgra=git-log
alias glg="git log"
compdef _git glg=git-log
alias ga='git add'
compdef _git ga=git-add
alias gdf='git diff'
compdef _git gdf=git-diff
alias gdw='git diff --word-diff'
compdef _git gdw=git-diff
alias gsu='(cd $(git rev-parse --show-toplevel) && git submodule update)'
alias gsui='(cd $(git rev-parse --show-toplevel) && git submodule update --init)'


function ph (){
    local dir
    dir=$(git rev-parse --show-cdup 2>/dev/null)
    if [ $? = 0 ]; then
        cd "${dir}"
    else
        echo "Not in git repo."
        return 1
    fi
}


# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
    SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
    SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

#compare the provided version of git to the version installed and on path
#prints 1 if input version <= installed version
#prints -1 otherwise
function git_compare_version() {
    local INPUT_GIT_VERSION=$1;
    local INSTALLED_GIT_VERSION
    INPUT_GIT_VERSION=(${(s/./)INPUT_GIT_VERSION});
    INSTALLED_GIT_VERSION=($(git --version));
    INSTALLED_GIT_VERSION=(${(s/./)INSTALLED_GIT_VERSION[3]});

    for i in {1..3}; do
        if [[ $INSTALLED_GIT_VERSION[$i] -lt $INPUT_GIT_VERSION[$i] ]]; then
            echo -1
            return 0
        fi
    done
    echo 1
}


#this is unlikely to change so make it all statically assigned
POST_1_7_2_GIT=$(git_compare_version "1.7.2")
#clean up the namespace slightly by removing the checker function
unset -f git_compare_version

function git_log2news(){
    git log --oneline "master..develop" | sed 's/^[^ ]* //' | awk '/NEW|BUG|REF|MOD|DEL/{print "* " $0}'
}


function gpr()
{
    local TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/gpr.XXXXXX")"
    echo '+refs/pull/*/head:refs/remotes/origin/pr/*' > "$TEMP_FILE"
    git config --get-all remote.origin.fetch | grep -v 'refs/remotes/origin/pr/\*$' >> "$TEMP_FILE"
    git config --unset-all remote.origin.fetch
    cat "$TEMP_FILE" | while read LINE
    do
        git config --add remote.origin.fetch "$LINE"
    done
    rm "$TEMP_FILE"

    git fetch
    if [[ -n "$1" ]]; then
        git checkout "pr/$1"
    fi
}


function gprrm()
{
    local TEMP_FILE="$(mktemp "${TMPDIR:-/tmp}/gpr.XXXXXX")"
    git config --get-all remote.origin.fetch | grep -v 'refs/remotes/origin/pr/\*$' >> "$TEMP_FILE"
    git config --unset-all remote.origin.fetch
    cat "$TEMP_FILE" | while read LINE
    do
        git config --add remote.origin.fetch "$LINE"
    done
    rm "$TEMP_FILE"

    git fetch
    if [[ -n "$1" ]]; then
        git checkout "pr/$1"
    fi
}
