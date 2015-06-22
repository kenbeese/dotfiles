## Keybind configuration
#
# emacs like keybind (e.x. Ctrl-a goes to head of a line and Ctrl-e goes
#   to end of it)
#
bindkey -e



###############################################
# その他                                      #
###############################################
# ファイル作成時のパーミッション
#umask 022

setopt no_beep              # ビープ音を消す
setopt nolistbeep           # 補完候補表示時などにビープ音を鳴らさない

#setopt interactive_comments # コマンドラインで # 以降をコメントとする

#setopt numeric_glob_sort     # 辞書順ではなく数値順でソート

#setopt no_multios            # zshのリダイレクト機能を制限する

#unsetopt promptcr            # 改行コードで終らない出力もちゃんと出力する
# setopt ignore_eof           # Ctrl-dでログアウトしない

#setopt no_hup                # ログアウト時にバックグラウンドジョブをkillしない
#setopt no_checkjobs          # ログアウト時にバックグラウンドジョブを確認しない
setopt notify                # バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる

setopt rm_star_wait         # rm * を実行する前に確認
#setopt rm_star_silent        # rm * を実行する前に確認しない
#setopt no_clobber           # リダイレクトで上書きを禁止
unsetopt no_clobber          # リダイレクトで上書きを許可

#setopt chase_links          # シンボリックリンクはリンク先のパスに変換してから実行
#setopt print_exit_value     # 戻り値が 0 以外の場合終了コードを表示
#setopt single_line_zle      # デフォルトの複数行コマンドライン編集ではなく、１行編集モードになる




###########################################################################
#                       For notify pwd to ansi-term                       #
###########################################################################
function chpwd_emacs_ansi_term() {
    echo '\033AnSiTc' $PWD
}

if [[ $EMACS =~ "(term:.*)" ]]; then
    chpwd_functions=($chpwd_functions chpwd_emacs_ansi_term)

    echo "\033AnSiTu" $USER
    echo "\033AnSiTh" ""
    chpwd_emacs_ansi_term
fi

###########################################################################
#                          For command-line-edit                          #
###########################################################################
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

###########################################################################
#                             For screensaver                             #
###########################################################################
if [ -e /usr/bin/xautolock ]; then
    pidof xautolock > /dev/null || /usr/bin/xautolock -secure -locker "/usr/bin/xlock -mode blank" -time 30 &!
fi


###########################################################################
#                             For report time                             #
###########################################################################
REPORTTIME=3
