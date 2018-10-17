;;region選択がactiveじゃなければ、後方の単語削除
(defadvice kill-region (around kill-word-or-kill-region activate)
  (if (and (called-interactively-p 'any) transient-mark-mode (not mark-active))
      (backward-kill-word 1)
    ad-do-it))


(defvar alc-search-url "http://eow.alc.co.jp/search?q=")
(defvar alc-content-id "#resultsArea")
(defun alc-word-url (word)
  (concat alc-search-url word alc-content-id))

(defvar eww-goto-alc-history)

(defun eww-goto-alc (word)
  (interactive  (list (read-string "Search word: " (thing-at-point 'word) 'eww-goto-alc-history)))
  (eww-browse-url (alc-word-url word) t))

(global-set-key (kbd "C-c w") 'eww-goto-alc)


(defun set-ricty-font ()
  (interactive)
  (set-face-font 'default "Ricty-12")
  (set-face-font 'variable-pitch "Ricty-12")
  (set-face-font 'fixed-pitch "Ricty-12")
  (set-face-font 'tooltip "Ricty-10.5")
  )



(defun my-replace-strings-in-region-by-list ($list)
  "Replace strings in a region according to $list"
  (if mark-active
      (let* (($beg (region-beginning))
             ($end (region-end))
             ($word (buffer-substring-no-properties $beg $end)))
        (mapc (lambda ($r)
                (setq $word (replace-regexp-in-string (car $r) (cdr $r) $word)))
              $list)
        $word)
    (error "Need to make region")))


(defun copy-region-remove-newline ()
  (interactive)
  (let ((body (my-replace-strings-in-region-by-list '(("\n" . "")))))
    (deactivate-mark)
    (kill-new body)
    ))
