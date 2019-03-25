;; helm
(helm-mode 1)
(global-set-key (kbd "C-x b") 'knbs-helm-buffer)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "M-x") 'helm-M-x)
(if (executable-find "cmigemo")
    (helm-migemo-mode t)
    )

(require 'helm-imenu)
(setq helm-source-imenu nil)
(defclass helm-imenu-source (helm-source-sync)
  ((candidates :initform 'helm-imenu-candidates)
   (candidate-transformer :initform 'helm-imenu-transformer)
   (persistent-action :initform 'helm-imenu-persistent-action)
   (persistent-help :initform "Show this entry")
   (nomark :initform t)
   (keymap :initform helm-imenu-map)
   (help-message :initform 'helm-imenu-help-message)
   (action :initform 'helm-imenu-action)
   (group :initform 'helm-imenu)
   (migemo :initform t)))

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

(use-package helm-projectile
  :config
  (projectile-mode 1)
  (setq projectile-completion-system 'helm)
  (setq helm-projectile-sources-list
        '(helm-source-projectile-buffers-list
          helm-source-projectile-recentf-list
          helm-source-projectile-files-list
          helm-source-projectile-projects))
  (helm-projectile-on)
  :bind
  (:map projectile-mode-map
        ("C-c p" . projectile-command-map))
)


(use-package helm-swoop
  :bind
  (("M-i" . helm-swoop)
   ("M-I" . helm-swoop-back-to-last-point)
   :map isearch-mode-map
   ("M-i" . helm-swoop-from-isearch)
   :map helm-swoop-map
   ("C-s" . helm-next-line)
   ("C-r" . helm-previous-line)
   ("M-i" . helm-multi-swoop-all-from-helm-swoop)
   ("M-m" . helm-multi-swoop-current-mode-from-helm-swoop)
   :map helm-multi-swoop-map
   ("C-s" . helm-next-line)
   ("C-r" . helm-previous-line)
   )
)
