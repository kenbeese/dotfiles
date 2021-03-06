;;   以下のようなをファイルを作成しとく
;; #+NAME $HOME/.aspell.conf
;; #+BEGIN_SRC conf
;;   lang en_US
;; #+END_SRC

(if (not (executable-find "aspell"))
    (warn "Aspell is not found please install.")

  (setq-default ispell-program-name "aspell")

  (eval-after-load "ispell"
    '(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

  (setq flyspell-enable-mode-hooks '(fundamental-mode-hook
                                     default-generic-mode-hook
                                     markdown-mode-hook
                                     text-mode-hook
                                     org-mode-hook
                                     web-mode-hook
                                     ))

  (setq flyspell-prog-enable-mode-hooks '(python-mode-hook
                                          c-mode-hook
                                          c++-mode-hook
                                          emacs-lisp-mode-hook
                                          ))

  (dolist (mode flyspell-enable-mode-hooks)
    (add-hook mode
              '(lambda ()
                 (flyspell-mode 1))))
  (dolist (mode flyspell-prog-enable-mode-hooks)
    (add-hook mode
              '(lambda ()
                 (flyspell-prog-mode))))

  (setq flyspell-auto-correct-binding (kbd "<C-M-return>"))

  (defun flyspell-correct-word-popup-el ()
    "Pop up a menu of possible corrections for misspelled word before point."
    (interactive)
    ;; use the correct dictionary
    (flyspell-accept-buffer-local-defs)
    (let ((cursor-location (point))
          (word (flyspell-get-word nil)))
      (if (consp word)
          (let ((start (car (cdr word)))
                (end (car (cdr (cdr word))))
                (word (car word))
                poss ispell-filter)
            ;; now check spelling of word.
            (ispell-send-string "%\n")    ;put in verbose mode
            (ispell-send-string (concat "^" word "\n"))
            ;; wait until ispell has processed word
            (while (progn
                     (accept-process-output ispell-process)
                     (not (string= "" (car ispell-filter)))))
            ;; Remove leading empty element
            (setq ispell-filter (cdr ispell-filter))
            ;; ispell process should return something after word is sent.
            ;; Tag word as valid (i.e., skip) otherwise
            (or ispell-filter
                (setq ispell-filter '(*)))
            (if (consp ispell-filter)
                (setq poss (ispell-parse-output (car ispell-filter))))
            (cond
             ((or (eq poss t) (stringp poss))
              ;; don't correct word
              t)
             ((null poss)
              ;; ispell error
              (error "Ispell: error in Ispell process"))
             (t
              ;; The word is incorrect, we have to propose a replacement.
              (flyspell-do-correct (popup-menu* (car (cddr poss)) :scroll-bar t :margin t)
                                   poss word cursor-location start end cursor-location)))
            (ispell-pdict-save t)))))

  (add-hook 'flyspell-mode-hook
            (lambda ()
              (define-key flyspell-mode-map flyspell-auto-correct-binding 'flyspell-correct-word-popup-el)
              ))
  )
