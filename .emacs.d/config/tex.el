(setq TeX-default-mode 'japanese-latex-mode)
(setq japanese-LaTeX-default-style "jsarticle")
(setq japanese-LaTeX-command-default "latexmk")

(setq preview-image-type 'dvipng)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(setq TeX-view-program-list '(()))
;; (add-hook 'LaTeX-mode-hook
;;           (function (lambda ()
;;                       (add-to-list 'TeX-command-list
;;                                    '("Latexmk"
;;                                      "latexmk %t"
;;                                      TeX-run-TeX nil (latex-mode) :help "Run Latexmk"))
;;                       )))

;;
;; RefTeX with AUCTeX
;;
(setq reftex-plug-into-AUCTeX t)

(setq TeX-view-program-list '(("PDFViewer" "SumatraPDF.exe %o"))) ; SumatraPDF

(setq TeX-view-program-selection '((output-pdf "PDFViewer")))

;; LaTeX mode hook
(add-hook 'LaTeX-mode-hook
          (lambda ()
            (TeX-source-specials-mode 1) ; source specials mode
            (setq TeX-source-specials-view-start-server t) ; server start without query
            ;; TeX Command List
            (add-to-list 'TeX-command-list
                         '("latexmk" "latexmk %t"
                           TeX-run-TeX nil (latex-mode) :help "Run ASCII pLaTeX")) ; latexmk
            (add-to-list 'TeX-command-list
                         '("pdfview" "SumatraPDF.exe %s.pdf"
                           TeX-run-discard-or-function t t)) ; sumatrapdf
            (add-to-list 'TeX-command-list
                         '("fwdsumatrapdf" "SumatraPDF.exe -reuse-instance -forward-search %t %n"
                           TeX-run-discard-or-function t t :help "Forward search with SumatraPDF")) ; fwdsumatrapdf, synctex, option 注意!
            (setq-local company-backends
                        '(company-reftex-labels
                          company-reftex-citations
                          (company-auctex-macros
                           company-auctex-symbols
                           company-auctex-environments)
                          company-dabbrev))
            (TeX-source-correlate-mode 1)
            (TeX-PDF-mode 1)
            (LaTeX-math-mode 1)
            (turn-on-reftex)
            (orgtbl-mode 1)
            (bind-keys :map LaTeX-mode-map
                       ("C-c f" . fill-region))
            ))

(use-package helm-bibtex
  :config
  (helm-delete-action-from-source "Insert citation" helm-source-bibtex)
  (helm-add-action-to-source "Insert citation" 'helm-bibtex-insert-citation helm-source-bibtex 0)
  (setq bibtex-completion-cite-prompt-for-optional-arguments nil)
  (defun knbs-set-helm-bibtex ()
      (bind-key "C-c [" 'helm-bibtex-with-local-bibliography reftex-mode-map)
    )
  :hook (reftex-mode . knbs-set-helm-bibtex)
  )
;; sumatrapdf option
;; c:\cygwin\usr\local\share\emacs\bin\emacsclientw.exe +%l "%f"
;; for wsl
;; bash -c "emacsclient -n +%l \"$(echo '%f'|sed -e 's|\\|/|g' -e 's/^./\L&\E/g' -e 's/://' -e 's|^|/mnt/|')\""
;;
;;; new wsl has wslpath
;; bash -c "emacsclient -n +%l \"$(wslpath '%f')\""
;; kinsoku.el
;;
;; (setq kinsoku-limit 10)

;; (setenv "PATH" (concat "/usr/local/texlive/2016/bin/i386-cygwin/:" (getenv "PATH")))
;; (setq exec-path (parse-colon-path (getenv "PATH")))
