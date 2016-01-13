;;; flex-autopair
(global-flex-autopair-mode t)
(setq flex-autopair-disable-modes
      '(emacs-lisp-mode lisp-interaction-mode lisp-mode ilem-mode web-mode))


;; auto-highlight-symbol
(global-auto-highlight-symbol-mode t)
(add-to-list 'ahs-modes 'js2-mode)

;;; auto-complete
(ac-config-default)
(ac-flyspell-workaround)
(add-to-list 'ac-modes 'html-mode)
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
;;; @ search - migemo                                               ;;;
;;;   https://github.com/emacs-jp/migemo                            ;;;
;;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; ;;;
(if (not (executable-find "cmigemo"))
    (warn "cmigemo is not found please install.")
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

  (load-library "migemo"))


;; recentf
(setq recentf-max-saved-items 1000)
(run-with-idle-timer 600 t 'recentf-save-list)

(global-auto-revert-mode 1)
