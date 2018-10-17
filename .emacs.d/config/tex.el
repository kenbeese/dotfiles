(setq TeX-default-mode 'japanese-latex-mode)
(setq japanese-LaTeX-default-style "jsarticle")
(setq japanese-LaTeX-command-default "latexmk")

(setq preview-image-type 'dvipng)
(setq TeX-source-correlate-method 'synctex)
(setq TeX-source-correlate-start-server t)
(setq TeX-view-program-list '(()))
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
(add-hook 'LaTeX-mode-hook 'TeX-PDF-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
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
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
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
            ))

;; sumatrapdf option
;; c:\cygwin\usr\local\share\emacs\bin\emacsclientw.exe +%l "%f"
;; for wsl
;; bash -c "emacsclient -n +%l $$(echo '%f'|sed -e 's|\\|/|g' -e 's/^./\L&\E/g' -e 's/://' -e 's|^|/mnt/|')"
;;
;; kinsoku.el
;;
;; (setq kinsoku-limit 10)

(setenv "PATH" (concat "/usr/local/texlive/2016/bin/i386-cygwin/:" (getenv "PATH")))
(setq exec-path (parse-colon-path (getenv "PATH")))
