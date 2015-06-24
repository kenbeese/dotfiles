;; package
(when load-file-name
  (setq user-emacs-directory (file-name-directory load-file-name)))

(let ((default-directory
	(file-name-as-directory (concat user-emacs-directory "site-lisp")))
      )
  (add-to-list 'load-path default-directory)
  (normal-top-level-add-subdirs-to-load-path)
  )

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)


(setq knbs-favorite-packages
      '(
        init-loader
        auto-complete
        solarized-theme
        helm
        helm-dired-recent-dirs
        markdown-mode
        eldoc-extension
        paredit
        term+
        term+key-intercept
        term+mux
        auto-highlight-symbol
        migemo
        ))



(let ((package-refreshed nil))
  (dolist (package knbs-favorite-packages)
    (unless (package-installed-p package)
      (unless package-refreshed
	(package-refresh-contents)
	(setq package-refreshed t))
      (package-install package))))



(init-loader-load (locate-user-emacs-file "init-loader"))

;; misc
(add-to-list 'auto-mode-alist '("\\.zsh$" . shell-script-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;                          for save-hist mode                        ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq savehist-save-minibuffer-history nil)
(setq savehist-additional-variables '(extended-command-history))
(setq savehist-file (locate-user-emacs-file "history"))
(savehist-mode 1)


(add-to-list 'backup-directory-alist
             (cons ".*" (locate-user-emacs-file "backup/")))



(add-to-list 'auto-save-file-name-transforms
             `("\\`/\\([^/]*/\\)*\\([^/]*\\)\\'" ,(concat (locate-user-emacs-file "backup/") "\\2") t))
(defvar my-disable-delete-trailing-modes '(org-mode markdown-mode))

(defun my-delete-trailing-whitespace ()
  (when (not (memq major-mode my-disable-delete-trailing-modes))
    (delete-trailing-whitespace)))

(add-hook 'before-save-hook 'my-delete-trailing-whitespace)


;; (set-language-environment "UTF-8") ;; UTF-8でも問題ないので適宜コメントアウトしてください

(when (eq 'cygwin system-type)

  ;; モードラインの表示文字列
  (setq-default w32-ime-mode-line-state-indicator "[Aa] ")
  (setq w32-ime-mode-line-state-indicator-list '("[Aa]" "[あ]" "[Aa]"))

  ;; IME初期化
  (w32-ime-initialize)

  ;; デフォルトIME
  (setq default-input-method "W32-IME")

  ;; IME無効／有効時のカーソルカラー定義
  (unless (facep 'cursor-ime-off)
    (make-face 'cursor-ime-off)
    (set-face-attribute 'cursor-ime-off nil
			:background "#839496" :foreground "White")
    )
  (unless (facep 'cursor-ime-on)
    (make-face 'cursor-ime-on)
    (set-face-attribute 'cursor-ime-on nil
			:background "#dc322f" :foreground "White")
    )

  (add-hook
   'w32-ime-off-hook
   '(lambda()
      (if (facep 'cursor-ime-off)
	  (let ( (fg (face-attribute 'cursor-ime-off :foreground))
		 (bg (face-attribute 'cursor-ime-off :background)) )
	    (set-face-attribute 'cursor nil :foreground fg :background bg)
	    )
	)
      )
   )
  (add-hook
   'w32-ime-on-hook
   '(lambda()
      (if (facep 'cursor-ime-on)
	  (let ( (fg (face-attribute 'cursor-ime-on :foreground))
		 (bg (face-attribute 'cursor-ime-on :background)) )
	    (set-face-attribute 'cursor nil :foreground fg :background bg)
	    )
	)
      )
   )

;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ language - fontset                                            ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

  ;; デフォルト フォント
  ;; (set-face-attribute 'default nil :family "Migu 1M" :height 110)
  (set-face-font 'default "Migu 1M-11:antialias=standard")

  ;; プロポーショナル フォント
  ;; (set-face-attribute 'variable-pitch nil :family "Migu 1M" :height 110)
  (set-face-font 'variable-pitch "Migu 1M-11:antialias=standard")

  ;; 等幅フォント
  ;; (set-face-attribute 'fixed-pitch nil :family "Migu 1M" :height 110)
  (set-face-font 'fixed-pitch "Migu 1M-11:antialias=standard")

  ;; ツールチップ表示フォント
  ;; (set-face-attribute 'tooltip nil :family "Migu 1M" :height 90)
  (set-face-font 'tooltip "Migu 1M-9:antialias=standard")



  )

;; フォントサイズ調整
(global-set-key (kbd "C-<wheel-up>")   '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-=")            '(lambda() (interactive) (text-scale-increase 1)))
(global-set-key (kbd "C-<wheel-down>") '(lambda() (interactive) (text-scale-decrease 1)))
(global-set-key (kbd "C--")            '(lambda() (interactive) (text-scale-decrease 1)))

;; フォントサイズ リセット
(global-set-key (kbd "M-0") '(lambda() (interactive) (text-scale-set 0)))



;; color-theme
(load-theme 'solarized-light t)
(disable-theme 'solarized-light)
(load-theme 'solarized-dark t)
(disable-theme 'solarized-dark)

;(enable-theme 'solarized-light)
(enable-theme 'solarized-dark)


;; (defun knbs-change-solarized-theme ()
;;   (interactive)
;;   (dolist (theme custom-enabled-themes)
;;     (disable-theme theme))
;;   (enable-theme knbs--next-solarized-theme))

(ac-config-default)
(eldoc-mode 1)


;; helm
(helm-mode 1)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x C-d") 'helm-dired-recent-dirs-view)


(defun helm-mini ()
    "Preconfigured `helm' lightweight version \(buffer -> recentf\)."
    (interactive)
    (require 'helm-buffers)
    (require 'helm-files)
    (unless helm-source-buffers-list
      (setq helm-source-buffers-list
            (helm-make-source "Buffers" 'helm-source-buffers)))
    (let* ((high-other-source '(helm-source-recentf
                                helm-source-bookmarks
                                helm-source-file-cache))
           (low-other-source `(,(and (not (string-match "^/sshx:.*" default-directory))
                                     'helm-source-files-in-current-dir)
                               ;helm-source-filelist
                               ;helm-source-locate
                               helm-source-buffer-not-found))
           (sources `(helm-source-buffers-list
                      ,@high-other-source
                      ,@low-other-source
                      )))
      (helm-other-buffer sources "*helm mini*")))

;; action shortcut key
(eval-after-load "helm"
  '(progn
     (define-key helm-map (kbd "C-e") '(lambda () (interactive) (helm-select-nth-action 1)))
     (define-key helm-map (kbd "C-j") '(lambda () (interactive) (helm-select-nth-action 2)))
     (define-key helm-map (kbd "M-j") 'helm-execute-persistent-action)
     ))

;; find-file時のキーマップ
(eval-after-load "helm-files"
  '(progn
     (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
     (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
     (define-key helm-read-file-map (kbd "C-z") 'helm-select-action)
     (define-key helm-find-files-map (kbd "C-z") 'helm-select-action)))


;; helmを無効にしたい関数
(eval-after-load "helm-mode"
  '(progn
     (add-to-list 'helm-completing-read-handlers-alist '(dired-create-directory . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(kill-buffer . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(write-file . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(dired . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
     ))
;; basenameを省略しない
(setq helm-ff-transformer-show-only-basename nil)



;; org-mode
(when (eq system-type 'cygwin)
  (setq org-directory "/c/Users/takagi/Documents/Memo/")
  (setq org-default-notes-file (expand-file-name "master.org" org-directory))
  (setq org-agenda-files (list org-default-notes-file))
  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c l") 'org-store-link)
  )


(setq org-todo-keywords '((sequence "TODO" "STARTED" "|" "DONE")))
(setq org-clock-in-switch-to-state "STARTED")
(setq org-agenda-custom-commands
        '(
          ("p" "Projects -todo" tags-todo "PROJECT")

          ("Y" "MAYBE" todo "MAYBE")

          ("N" "Next Actions Lists"
           ((agenda "" ((org-agenda-sorting-strategy
                         (quote ((agenda habit-down
                                         time-up
                                         todo-state-down
                                         priority-down
                                         category-keep))))
                        (org-agenda-dim-blocked-tasks t)))
            (tags-todo "ToDo" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))))
            (tags-todo "PROJECT" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled)))))
           ((org-agenda-compact-blocks t)))

          ("D" "Daily Action List" agenda ""
           ((org-agenda-ndays 1)
            ;(org-agenda-dim-blocked-tasks 'invisible)
            (org-agenda-dim-blocked-tasks t)
            (org-deadline-warning-days 7)
            (org-agenda-sorting-strategy
             (quote ((agenda habit-down
                             time-up
                             todo-state-down
                             priority-down
                             category-keep))))
                         ;; (quote ((agenda time-up todo-state-down tag-up priority-down) )))
                        ))

          ("d" "Upcoming deadlines" agenda ""
           ((org-agenda-time-grid nil)
            (org-deadline-warning-days 365)
            (org-agenda-entry-types '(:deadline))))

          ("F" "Future list" agenda ""
           ((org-agenda-ndays 31)
            (org-agenda-sorting-strategy
             (quote ((agenda todo-state-up time-up tag-up priority-down) )))
            ))
          ))

;; lisp
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)
(global-set-key (kbd "M-s") 'paredit-splice-sexp)

(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
(setq eldoc-idle-delay 0.01)
(setq eldoc-minor-mode-string "")


;; 同一バッファ名にディレクトリ付与
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
(setq uniquify-ignore-buffers-re "*[^*]+*")


;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - migemo                                               ;;;
;;;   https://github.com/emacs-jp/migemo                            ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;

(require 'migemo)

(defvar migemo-command nil)
(setq migemo-command "cmigemo")

(defvar migemo-options nil)
(setq migemo-options '("-q" "--emacs"))

(defvar migemo-dictionary nil)
(setq migemo-dictionary "/usr/local/share/migemo/utf-8/migemo-dict")

(defvar migemo-user-dictionary nil)

(defvar migemo-regex-dictionary nil)

(defvar migemo-coding-system nil)
(setq migemo-coding-system 'utf-8-unix)

(load-library "migemo")


;; emacs-server起動
(require 'server)
(defun server-ensure-safe-dir (dir) "Noop" t)
(setq server-socket-dir "~/.emacs.d")
(unless (server-running-p)
  (server-start)
)
(global-set-key (kbd "C-x C-c") 'server-edit)
(defalias 'exit 'save-buffers-kill-emacs)


;; javascript
(add-to-list 'auto-mode-alist '("\\.\\(js\\|json\\)$" . js2-mode))
(setq js2-enter-indents-newline t)
(setq js2-indent-on-enter-key t)


;; recentf
(setq recentf-max-saved-items 1000)
(run-with-idle-timer 600 t 'recentf-save-list)


;; csv-mode
(setq csv-separators '("	" ","))
(setq csv-separators '("," "	"))
(add-to-list 'auto-mode-alist '("\\.[Tt][Ss][Vv]\\'" . csv-mode))

;; term+
(setq term+shell-history-dont-exec t)

;; auto-highlight-symbol
(global-auto-highlight-symbol-mode t)
