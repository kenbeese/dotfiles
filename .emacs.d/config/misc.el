;; indentの設定
(setq-default tab-width 4 indent-tabs-mode nil)

;; statup画面の非表示
(setq inhibit-startup-screen t)

;; markがonの時に可視化
(setq transient-mark-mode t)

;; 対応するカッコの表示
(show-paren-mode 1)

;; C-hのbackspace化
(keyboard-translate ?\C-h ?\C-?)

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
