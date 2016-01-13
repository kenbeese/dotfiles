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
