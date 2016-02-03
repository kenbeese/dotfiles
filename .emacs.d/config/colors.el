;; color-theme
;; (load-theme 'solarized-light t)
;; (disable-theme 'solarized-light)
(load-theme 'solarized-dark t)
(disable-theme 'solarized-dark)

;(enable-theme 'solarized-light)
(enable-theme 'solarized-dark)

(defun text-scale-increase-around (f &rest args)
  (if (and solarized-use-variable-pitch
           (not (eq args 0))
           (eq text-scale-mode-amount 0)
           )
      (let ((solarized-use-variable-pitch nil))
        (load-theme 'solarized-dark t)
        ))
  (apply f args)
  (if (and solarized-use-variable-pitch
           (not (eq args 0))
           (eq text-scale-mode-amount 0))
      (load-theme 'solarized-dark t))
  )
(advice-add 'text-scale-increase :around #'text-scale-increase-around)

;; (defun knbs-change-solarized-theme ()
;;   (interactive)
;;   (dolist (theme custom-enabled-themes)
;;     (disable-theme theme))
;;   (enable-theme knbs--next-solarized-theme))

(require 'whitespace)
(setq whitespace-style '(face           ; faceで可視化
                         trailing       ; 行末の空白
                         tabs           ; タブ
                         spaces         ; スペース
                         lines-tail     ; 80文字越えたら可視化
                         empty          ; 先頭/末尾の空行
                         space-mark     ; 表示のマッピング
                         tab-mark
                         ))

(setq whitespace-display-mappings
      '((space-mark ?\u3000 [?\u25a1])
        ;; WARNING: the mapping below has a problem.
        ;; When a TAB occupies exactly one column, it will display the
        ;; character ?\xBB at that column followed by a TAB which goes to
        ;; the next TAB column.
        ;; If this is a problem for you, please, comment the line below.
        (tab-mark ?\t [?\u00BB ?\t] [?\\ ?\t])))

(set-face-attribute 'whitespace-empty nil
                    :underline t
                    :inverse-video nil)

(setq whitespace-space-regexp "\\(\u3000+\\)")  ;; スペースは全角のみを可視化
(setq whitespace-global-modes '(not term-mode org-mode))
(global-whitespace-mode 1)
(setq-default show-trailing-whitespace t)
