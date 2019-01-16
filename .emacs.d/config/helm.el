;; helm
(helm-mode 1)
(global-set-key (kbd "C-x b") 'knbs-helm-buffer)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)


(defun knbs-helm-buffer ()
  (interactive)
  (require 'helm-x-files)
  (unless helm-source-buffers-list
    (setq helm-source-buffers-list
          (helm-make-source "Buffers" 'helm-source-buffers)))
  (let ((knbs-source-list `(helm-source-buffers-list
                            helm-source-recentf
                            helm-source-bookmarks
                            helm-source-file-cache
                            ,(and (not (string-match "^/sshx:." default-directory))
                                  'helm-source-files-in-current-dir)
                            helm-source-locate)))

    (helm :sources knbs-source-list
          :ff-transformer-show-only-basename nil
          :buffer "*knbs helm buffer*"
          :truncate-lines helm-buffers-truncate-lines)
    ))

;; action shortcut key
(eval-after-load "helm"
  '(progn
     (define-key helm-map (kbd "C-e") '(lambda () (interactive) (helm-select-nth-action 1)))
     (define-key helm-map (kbd "C-j") '(lambda () (interactive) (helm-select-nth-action 2)))
     (define-key helm-map (kbd "M-j") 'helm-execute-persistent-action)
     ))

;; find-file時のキーマップ
(eval-after-load "helm-files"
  '(progn
     (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
     (define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
     (define-key helm-read-file-map (kbd "C-z") 'helm-select-action)
     (define-key helm-find-files-map (kbd "C-z") 'helm-select-action)))


;; helmを無効にしたい関数
(eval-after-load "helm-mode"
  '(progn
     (add-to-list 'helm-completing-read-handlers-alist '(dired-create-directory . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(kill-buffer . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(write-file . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(dired . nil))
     (add-to-list 'helm-completing-read-handlers-alist '(find-file . nil))
     ))
;; basenameを省略しない
(setq helm-ff-transformer-show-only-basename nil)
