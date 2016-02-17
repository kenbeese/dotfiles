(when (eq system-type 'cygwin)
  ;; (setq org-directory "/c/Users/takagi/Documents/Memo/")
  (setq org-directory "/c/Users/kentaro/Dropbox/org_sync/")
  (setq org-default-notes-file (expand-file-name "master.org" org-directory))
  (setq org-agenda-files (list org-default-notes-file))
  )
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c l") 'org-store-link)
(setq org-todo-keywords '((sequence "TODO" "STARTED" "|" "DONE")))
(setq org-clock-in-switch-to-state "STARTED")
(setq org-agenda-custom-commands
        '(
          ("p" "Projects -todo" tags-todo "PROJECT")

          ("Y" "MAYBE" todo "MAYBE")

          ("N" "Next Actions Lists"
           ((agenda "" ((org-agenda-sorting-strategy
                         (quote ((agenda habit-down
                                         time-up
                                         todo-state-down
                                         priority-down
                                         category-keep))))
                        (org-agenda-dim-blocked-tasks t)))
            (tags-todo "ToDo" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled))))
            (tags-todo "PROJECT" ((org-agenda-skip-function '(org-agenda-skip-entry-if 'scheduled)))))
           ((org-agenda-compact-blocks t)))

          ("D" "Daily Action List" agenda ""
           ((org-agenda-ndays 1)
            ;(org-agenda-dim-blocked-tasks 'invisible)
            (org-agenda-dim-blocked-tasks t)
            (org-deadline-warning-days 7)
            (org-agenda-sorting-strategy
             (quote ((agenda habit-down
                             time-up
                             todo-state-down
                             priority-down
                             category-keep))))
                         ;; (quote ((agenda time-up todo-state-down tag-up priority-down) )))
                        ))

          ("d" "Upcoming deadlines" agenda ""
           ((org-agenda-time-grid nil)
            (org-deadline-warning-days 365)
            (org-agenda-entry-types '(:deadline))))

          ("F" "Future list" agenda ""
           ((org-agenda-ndays 31)
            (org-agenda-sorting-strategy
             (quote ((agenda todo-state-up time-up tag-up priority-down) )))
            ))
          ))


(setq org-ditaa-jar-path  (concat user-emacs-directory "utils/jditaa.jar"))
(setq org-ditaa-jar-option "-Dfile.encoding=UTF-8 -jar")
(org-babel-do-load-languages
 'org-babel-load-languages
 '((ditaa . t)))
(when (eq system-type 'cygwin)
  (setq org-babel-ditaa-java-cmd "/c/Program\\ Files\\ \\(x86\\)/Java/jdk1.8.0_74/bin/java")

  (defun transform-cygpath (path)
    (format "`cygpath -w %s`" path))

  (require 'ob-ditaa)
  (defun org-babel-execute:ditaa (body params)
    "Execute a block of Ditaa code with org-babel.
This function is called by `org-babel-execute-src-block'."
    (let* ((result-params (split-string (or (cdr (assoc :results params)) "")))
           (out-file (let ((el (cdr (assoc :file params))))
                       (or el
                           (error
                            "ditaa code block requires :file header argument"))))
           (cmdline (cdr (assoc :cmdline params)))
           (java (cdr (assoc :java params)))
           (in-file (org-babel-temp-file "ditaa-"))
           (eps (cdr (assoc :eps params)))
           (cmd (concat org-babel-ditaa-java-cmd
                        " " java " " org-ditaa-jar-option " "
                        (transform-cygpath
                         (shell-quote-argument
                          (expand-file-name
                           (if eps org-ditaa-eps-jar-path org-ditaa-jar-path))))
                        " " cmdline
                        " " (transform-cygpath (org-babel-process-file-name in-file))
                        " " (transform-cygpath (org-babel-process-file-name out-file))))
           (pdf-cmd (when (and (or (string= (file-name-extension out-file) "pdf")
                                   (cdr (assoc :pdf params))))
                      (concat
                       "epstopdf"
                       " " (org-babel-process-file-name (concat in-file ".eps"))
                       " -o=" (org-babel-process-file-name out-file)))))
      (unless (file-exists-p org-ditaa-jar-path)
        (error "Could not find ditaa.jar at %s" org-ditaa-jar-path))
      (with-temp-file in-file (insert body))
      (message cmd) (shell-command cmd)
      (when pdf-cmd (message pdf-cmd) (shell-command pdf-cmd))
      nil)))
