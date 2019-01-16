(use-package flycheck
  :config
  (setq flycheck-global-modes '(not python-mode)) ;elpy using flymake
  (setq flycheck-display-errors-function nil)
  (global-flycheck-mode t)
)

(defun flycheck-tip-current-line ()
  "Display error message in current line."
  (interactive)
  (require 'flycheck-tip)
  (setq error-tip-current-errors
        (assoc-default :current-line
                       (error-tip-collect-current-file-errors
                        flycheck-current-errors)))
  (error-tip-popup-error-message
   (error-tip-get-errors)))

(global-set-key  (kbd "C-c C-n") 'flycheck-tip-current-line)
