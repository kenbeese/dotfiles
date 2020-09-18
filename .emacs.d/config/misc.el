;; default encoding
(prefer-coding-system 'utf-8)

;; indentの設定
(setq-default tab-width 4 indent-tabs-mode nil)
(setq standard-indent 2)

;; statup画面の非表示
(setq inhibit-startup-screen t)

;; markがonの時に可視化
(setq transient-mark-mode t)

;; 対応するカッコの表示
(show-paren-mode 1)

;; C-hのbackspace化
(define-key key-translation-map [?\C-h] [?\C-?])
;(keyboard-translate ?\C-h ?\C-?)

;;; row数の表示
(line-number-mode 1)

;;; カラム数の表示
(column-number-mode 1)

;;; カーソルの点滅off
(blink-cursor-mode 0)

;;; ファイルシステム上で変更されたら自動で変更
(global-auto-revert-mode t)

;;; key-strokeの表示
(setq echo-keystrokes 0.1)

;;; beep音をやめる
(setq ring-bell-function 'ignore)
;(setq visible-bell nil)


;;; ツール、スクロール、メニューバーの非表示
(when (>= emacs-major-version 23)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (menu-bar-mode -1))

;;; buffer-listを見やすく
(define-key global-map "\C-x\C-b" 'ibuffer)
(setq ibuffer-default-sorting-mode 'filename/process)
(eval-after-load "ibuffer"
  '(define-key ibuffer-mode-map "R" 'Buffer-menu-grep-delete))

;;; ファイルの最終行に改行を入れる
(setq require-final-newline t)


;;; diredで編集作業に
(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)))

(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                          for save-hist mode                        ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq savehist-save-minibuffer-history nil)
(setq savehist-additional-variables '(extended-command-history))
(setq savehist-file (locate-user-emacs-file "history"))
(savehist-mode 1)


;;; auto-savefileの場所変更
(add-to-list 'backup-directory-alist
             (cons ".*" (locate-user-emacs-file "backup/")))

(add-to-list 'auto-save-file-name-transforms
             `("\\`/\\([^/]*/\\)*\\([^/]*\\)\\'" ,(concat (locate-user-emacs-file "backup/") "\\2") t))


;;; white spaceの削除
(defvar my-disable-delete-trailing-modes '(org-mode markdown-mode))
(add-to-list 'my-disable-delete-trailing-modes 'latex-mode)

(defun my-delete-trailing-whitespace ()
  (when (not (memq major-mode my-disable-delete-trailing-modes))
    (delete-trailing-whitespace)))

(add-hook 'before-save-hook 'my-delete-trailing-whitespace)


;; フォントサイズ調整
(global-set-key (kbd "C-<wheel-up>")   '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-=")            '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-<wheel-down>") '(lambda() (interactive) (text-scale-decrease 1)))
(global-set-key (kbd "C--")            '(lambda() (interactive) (text-scale-decrease 1)))

;; フォントサイズ リセット
(global-set-key (kbd "M-0") '(lambda() (interactive) (text-scale-set 0)))

(set-face-attribute 'default nil :height 105)

;; split-windowの挙動
(setq split-height-threshold nil)
(setq split-width-threshold 160)


;; 同一バッファ名にディレクトリ付与
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")


;; emacs-server起動
(require 'server)
(when (eq 'cygwin system-type)
  (defun server-ensure-safe-dir (dir) "Noop" t)
  (setq server-socket-dir "~/.emacs.d"))
(unless (server-running-p)
  (server-start)
  )
(global-set-key (kbd "C-x C-c") 'server-edit)
(defalias 'exit 'save-buffers-kill-emacs)



(global-origami-mode 1)
(global-set-key (kbd "<S-f7>") 'origami-toggle-all-nodes)
(global-set-key (kbd "<f7>") 'origami-recursively-toggle-node)
