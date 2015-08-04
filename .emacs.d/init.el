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
        jedi
        py-autopep8
        js2-mode
        flycheck-tip
        flex-autopair
        emmet-mode
        ac-emmet
        web-mode
        origami
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


;; javascript
(add-to-list 'auto-mode-alist '("\\.\\(js\\|json\\)$" . js2-mode))
(setq js2-enter-indents-newline t)
(setq js2-indent-on-enter-key t)
;; (eval-after-load 'js2-mode
;;   '(add-hook 'js2-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

;; (eval-after-load 'json-mode
;;   '(add-hook 'json-mode-hook
;;              (lambda ()
;;                (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))

;; csv-mode
(setq csv-separators '("	" ","))
(setq csv-separators '("," "	"))
(add-to-list 'auto-mode-alist '("\\.[Tt][Ss][Vv]\\'" . csv-mode))

;; term+
(setq term+shell-history-dont-exec t)


(global-origami-mode 1)

(global-set-key (kbd "<S-f7>") 'origami-toggle-all-nodes)
(global-set-key (kbd "<f7>") 'origami-recursively-toggle-node)
