;;; flake8
;;; flake8-docstrings
;;; virtualenv
;;; pep8-naming
;;; autopep8
(defun knbs-jedi:start ()
  (interactive)
  (setq jedi:setup-keys t)
  (setq jedi:complete-on-dot t)
  (jedi:setup)
  (jedi:ac-setup))
(add-hook 'python-mode-hook 'knbs-jedi:start)

;;; cygwinだと遅い
(unless (eq 'cygwin system-type)
  (add-hook 'python-mode-hook 'py-autopep8-enable-on-save))
