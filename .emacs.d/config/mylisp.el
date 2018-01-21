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
