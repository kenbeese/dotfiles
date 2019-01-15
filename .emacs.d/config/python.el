;;; jedi
;;; flake8
;;; flake8-docstrings
;;; pep8-naming
;;; autopep8
;;; yapf


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


(use-package pyenv-mode
  :init
  (add-to-list 'exec-path "~/.pyenv/shims")
  (setenv "WORKON_HOME" "~/.pyenv/versions/")
  :config
  (pyenv-mode)
  :bind
  ("C-x p e" . pyenv-activate-current-project)
  :hook
  (find-file . pyenv-mode-auto-hook)
  )

(defun pyenv-mode-auto-hook ()
  "Automatically activates pyenv version if .python-version file exists."
  (f-traverse-upwards
   (lambda (path)
     (let ((pyenv-version-path (f-expand ".python-version" path)))
       (if (f-exists? pyenv-version-path)
           (progn
             (pyenv-mode-set (car (s-lines (s-trim (f-read-text pyenv-version-path 'utf-8)))))
             t))))))

(defun pyenv-activate-current-project ()
  "Automatically activates pyenv version if .python-version file exists."
  (interactive)
  (pyenv-mode-auto-hook))
