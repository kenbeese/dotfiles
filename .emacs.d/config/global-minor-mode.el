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
(let ((hostname (or (getenv "HOST") (getenv "HOSTNAME"))))
  (setq recentf-save-file (concat "~/.recentf." hostname)))
(run-with-idle-timer 600 t 'recentf-save-list)


;; anzu-mode
(global-anzu-mode 1)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)


;; auto-save-buffer-enhanced

(require 'auto-save-buffers-enhanced)
(setq auto-save-buffers-enhanced-include-regexps
      (list (rx (or "master.org" "serverhistory.org" "memo.org"))))
(setq auto-save-buffers-enhanced-interval 60)
(auto-save-buffers-enhanced t)


(when (locate-library "mozc")
  (require 'mozc)
  (set-language-environment "Japanese")
  (setq default-input-method "japanese-mozc")

  (global-set-key [PreviousCandidate]
                  (lambda () (interactive)
                    (when (null current-input-method) (toggle-input-method))))
  (global-set-key [henkan]
                  (lambda () (interactive)
                    (when (null current-input-method) (toggle-input-method))))
  (global-set-key [muhenkan]
                  (lambda () (interactive)
                    (inactivate-input-method)))

   (defadvice mozc-handle-event (around intercept-keys (event))
     "Intercept keys muhenkan and zenkaku-hankaku, before passing keys
to mozc-server (which the function mozc-handle-event does), to
properly disable mozc-mode."
     (if (member event (list 'zenkaku-hankaku 'muhenkan))
         (progn
           (mozc-clean-up-session)
           (toggle-input-method))
       (progn                            ;(message "%s" event) ;debug
         ad-do-it)))
   (ad-activate 'mozc-handle-event)
   )
