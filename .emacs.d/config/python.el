;;; flake8
;;; flake8-docstrings
;;; virtualenv
;;; pep8-naming
;;; autopep8

;; (defun knbs-jedi:start ()
;;   (interactive)
;;   (require 'jedi-core)
;;   (setq jedi:setup-keys t)
;;   (setq jedi:complete-on-dot t)
;;   (add-to-list 'company-backends 'company-jedi)
;;   (jedi:setup)
;;   )

;; (add-hook 'python-mode-hook 'knbs-jedi:start)

;; ;;; cygwinだと遅い
;; (unless (eq 'cygwin system-type)
;;   (add-hook 'python-mode-hook 'py-autopep8-enable-on-save))

(use-package elpy
  :init
  (add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
  :bind (:map elpy-mode-map
              ("M-." . elpy-goto-definition)
              ("M-," . pop-tag-mark))
  :config
  (setq elpy-rpc-backend "jedi"))

(use-package python
  :mode ("\\.py" . python-mode)
  :config
  (setq python-indent-offset 4)
  (elpy-enable)
  )

(defun py-autopep8-disable-on-save ()
  (interactive)
  (remove-hook 'before-save-hook 'py-autopep8-buffer t))
