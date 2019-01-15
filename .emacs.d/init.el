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
;; (let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
;;                     (not (gnutls-available-p))))
;;        (proto (if no-ssl "http" "https")))
;;   (when no-ssl (warn "\
;; Your version of Emacs does not support SSL connections,
;; which is unsafe because it allows man-in-the-middle attacks.
;; There are two things you can do about this warning:
;; 1. Install an Emacs version that does support SSL and be safe.
;; 2. Remove this warning from your init file so you won't see it again."))
;;   ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
;;   (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
;;   (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
;;   (add-to-list 'package-archives (cons "org"  (concat proto "://orgmode.org/elpa/")) t)
;;   (when (< emacs-major-version 24)
;;     ;; For important compatibility libraries like cl-lib
;;     (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(add-to-list 'package-archives (cons "melpa-stable" "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives (cons "melpa" "http://melpa.org/packages/") t)
(add-to-list 'package-archives (cons "org"  "http://orgmode.org/elpa/") t)
(package-initialize)


(setq knbs-favorite-packages
      '(
        use-package
        init-loader
        company
        solarized-theme
        helm
        helm-dired-recent-dirs
        paredit
        auto-highlight-symbol
        migemo
        flycheck-tip
        flex-autopair
        anzu
        auto-save-buffers-enhanced
        import-popwin

        ;; auto-complete
        ;; jedi
        ;; ac-emmet
        elpy
        pyenv-mode

        markdown-mode

        emmet-mode
        web-mode

        origami

        js2-mode

        protobuf-mode

        yaml-mode
        ))

(let ((package-refreshed nil))
  (dolist (package knbs-favorite-packages)
    (unless (package-installed-p package)
      (unless package-refreshed
        (package-refresh-contents)
        (setq package-refreshed t))
      (package-install package))))


(require 'use-package)

(use-package init-loader
             :config
             (setq init-loader-byte-compile t)
             (init-loader-load (locate-user-emacs-file "init-loader")))

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

  ;; abcdefghij
  ;; あいうえお
  ;; サイズは1.5の倍数にしないと1:2にならない
  ;; 例 9, 10.5, 12, 13.5
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


;; abcdefghij
;; あいうえお
;; サイズは1.5の倍数にしないと1:2にならない
;; 例 9, 10.5, 12, 13.5
;; デフォルト フォント
(defun set-ricty-font ()
  (interactive)
  (set-face-font 'default "Ricty-12")
  (set-face-font 'variable-pitch "Ricty-12")
  (set-face-font 'fixed-pitch "Ricty-12")
  (set-face-font 'tooltip "Ricty-10.5")
  )
