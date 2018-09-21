
;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Set up the keyboard so the delete key on both the regular keyboard
;; and the keypad delete the character under the cursor and to the right
;; under X, instead of the default, backspace behavior.
(global-set-key [delete] 'delete-char)
(global-set-key [kp-delete] 'delete-char)

;; Visual feedback on selections
(setq-default transient-mark-mode t)

;; Always end a file with a newline
(setq require-final-newline t)

;; Stop at the end of the file, not just add lines
(setq next-line-add-newlines nil)

;; Enable wheelmouse support by default
(cond (window-system
       (mwheel-install)
))
;; --------------------------------------------------
;; Common libraries
(setq load-path (cons (expand-file-name "~/Custom-files/Config/Emacs") load-path))
(setq load-path (cons (expand-file-name "~/Projects/EU/HATS/HATS-global/Tools/ABS-emacs") load-path))
(setq load-path (cons (expand-file-name "~/Systems/abstools/emacs") load-path))
;;

(setq load-path (cons "/usr/share/emacs/site-lisp/flim" load-path))
(setq load-path (cons "/usr/share/emacs/site-lisp/apel" load-path))
(setq load-path (cons "/usr/share/emacs/site-lisp/vm" load-path))

;(require 'psvn)

;; --------------------------------------------------
;; .emacs stuff common to all machines and situations
;; --------------------------------------------------
(setq inhibit-startup-message t)
(setq visible-bell t)
(setq default-case-fold-search nil) 
(setq default-major-mode 'text-mode)
(setq fill-column 75) ;; Normally it is 70
;(standard-display-european t)
(setq compile-command "make \"CFLAGS = -g -k\"")
(setq version-control nil) ;; Default, but just in case
(setq require-final-newline t)
;; Added "-" to pattern for Prolog
(setq shell-prompt-pattern "^[^#$%>\n-]*[#$%>-] *")
;; hilight marked regions, etc.
(transient-mark-mode t)
(setq mark-even-if-inactive t)
;; ASCII Printing
;; (setq ps-paper-type 'ps-a4)
(setq ps-paper-type 'a4)
(setq ps-font-size 8)
(setq ps-left-margin 20)
(setq ps-right-margin 20)
(setq ps-inter-column 20)
(setq ps-top-margin 30)
(setq ps-header-font-size 9)
(setq ps-header-title-font-size 10)
(setq ps-header-offset 20)
(setq ps-lpr-command "lpr")
(setq ps-print-header t) ;; Set to nil to avoid header
(setq ps-landscape-mode t) ;; 2 pages, landscape
(setq ps-number-of-columns 2) ;; 2 pages, landscape
(setq ps-zebra-stripes t) ;; Makes reading easier?
(setq ps-spool-duplex t) ;; Optimizes for duplex printers
;(setq ps-lpr-switches '("-Plope"))
;; 
(setq ps-right-header '("/pagenumberstring load" time-stamp-dd-mm-yy))
(setq lpr-command "lpr") ;; Default, but OK
;; Auto-fill and comment hooks -- may want to add others
(setq emacs-lisp-mode-hook 'turn-on-auto-fill)
(setq lisp-mode-hook 'turn-on-auto-fill)
(setq text-mode-hook 'turn-on-auto-fill)
(setq c-mode-hook    'turn-on-auto-fill)

;; Number of lines kept in *Messages* buffer
(setq message-log-max 500)

;; SPREADSHEETS
;; ;; dismal spreadsheet
;; (load "/usr/local/lib/emacs/site-lisp/dismal-1.02/dismal-mode-defaults")
;; ;; spread.el spreadsheet
;; (setq auto-mode-alist (cons '("\\.sp$"  . spread-mode)  auto-mode-alist))
;; (autoload 'spread-mode "spread")
;; My latex-spread.el spreadsheet...
(autoload 'latex-spread-mode "latex-spread" "Simple LaTeX spreadsheet."  t)

(global-set-key [f7] 'vm)

;; Auc-TeX
;; (defvar TeX-view-style '(  ("." "xdvi %d -s 7 -hushspecials -hl green -bd red -cr blue -expert -paper a4 -geometry -0+0")))
(load "tex-site")
(setq-default TeX-parse-self t) ;; Parses options in file!
;; Auc-TeX options - eliminate parsing which makes things unreasonably slow 
;; (setq-default TeX-auto-regexp-list 'LaTeX-auto-minimal-regexp-list)
;; The documentstyle command is usually near the beginning.
;; (setq-default TeX-auto-parse-length 2000)
;;;;(setq TeX-print-command "dvips -f < %d | lpr -P%p")
;; For slides
;; (setq TeX-print-command "dvips -t landscape -t a4 -f < %d | lpr -P%p-1")

;; Reftex
(autoload 'reftex-mode    "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" t)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)   ; with AUCTeX LaTeX mode
(add-hook 'latex-mode-hook 'turn-on-reftex)   ; with Emacs latex mode

;; For Preview
(require 'tex-site)
(add-hook 'LaTeX-mode-hook #'LaTeX-preview-setup)
(autoload 'LaTeX-preview-setup "preview")

;;; My Miscellaneous stuff...
;(load "manuel-misc-stuff.el")

;; Automatic compression and uncompression
;; (load "jka-compr19")
;(load "crypt++")
;; aargh -- keeps thinking that .e files should be encrypted!
(defun crypt-build-encryption-alist ()
  ;; Returns the encryption alist
  (list
   ;; crypt
   (list 'crypt
         crypt-encryption-magic-regexp crypt-encryption-magic-regexp-inverse
;; MH
;;         (or crypt-encryption-file-extension "\\(\\.e\\)$")
         (or crypt-encryption-file-extension "\\(\\.crypt\\)$")
         "crypt" "crypt"
         nil
         nil
         "Crypt"
         nil
         t
         )
   ;; DES (Cipher Block Chaining - CBC) [DES' default]
   (list 'des
         crypt-encryption-magic-regexp crypt-encryption-magic-regexp-inverse
         (or crypt-encryption-file-extension "\\(\\.des\\)$")
         "des" "des"
         '("-e" "-k")
         '("-d" "-k")
         "DES-CBC"
         nil
         t
         )
   ;; DES (Electronic Code Book - ECB)
   (list 'des-ecb
         crypt-encryption-magic-regexp crypt-encryption-magic-regexp-inverse
         (or crypt-encryption-file-extension "\\(\\.des\\)$")
         "des" "des"
         '("-e" "-b" "-k")
         '("-d" "-b" "-k")
         "DES-ECB"
         nil
         t
         )
   ;; PGP
   (list 'pgp
         crypt-encryption-magic-regexp crypt-encryption-magic-regexp-inverse
         (or crypt-encryption-file-extension "\\(\\.pgp\\)$")
         "pgp" "pgp"
         '("+batchmode" "+verbose=0" "-c" "-f" "-z")
         '("+batchmode" "+verbose=0" "-f" "-z")
         "PGP"
         nil
         t
         )
   ;; Add new elements here ...
   ))


;(global-set-key [f4] 'iso-accents-mode)
; GP needed for accents in Spanish in Ubuntu 13.10
(require 'iso-transl) 

(defun acento (char)
  "If the previous character is one of {a,e,i,o,u,n,N} accent it in LaTeX
format, else insert the last pressed key."
  (interactive "*c")
  (cond
    ((equal char ?b) (insert-string "\\'{b}"))
    ((equal char ?g) (insert-string "\\'{g}"))
    ((equal char ?h) (insert-string "\\'{h}"))
    ((equal char ?d) (insert-string "\\'{d}"))
    ((equal char ?w) (insert-string "\\'{w}"))
    ((equal char ?z) (insert-string "\\'{z}"))
    ((equal char ?t) (insert-string "\\'{t}"))
    ((equal char ?y) (insert-string "\\'{y}"))
    ((equal char ?k) (insert-string "\\'{k}"))
    ((equal char ?s) (insert-string "\\'{s}"))
    ((equal char ?l) (insert-string "\\'{l}"))
    ((equal char ?m) (insert-string "\\'{m}"))
    ((equal char ?n) (insert-string "\\~{n}"))
    ((equal char ?p) (insert-string "\\'{p}"))
    ((equal char ?q) (insert-string "\\'{q}"))
    ((equal char ?u) (insert-string "\\'{u}"))
    ((equal char ?n) (insert-string "\\~{n}"))
    ((equal char ?a) (insert-string "\\'{a}"))
    ((equal char ?e) (insert-string "\\'{e}"))
    ((equal char ?i) (insert-string "\\'{\\i}"))
    ((equal char ?o) (insert-string "\\'{o}"))
    ((equal char ?u) (insert-string "\\'{u}"))
    ((equal char ?N) (insert-string "\\~{N}"))
    ((equal char ?A) (insert-string "\\'{A}"))
    ((equal char ?E) (insert-string "\\'{E}"))
    ((equal char ?I) (insert-string "\\'{I}"))
    ((equal char ?O) (insert-string "\\'{O}"))
    ((equal char ?U) (insert-string "\\'{U}"))
    ((equal char ??) (insert-string "?`"))
    ((equal char ?!) (insert-string "!`"))
    ( t (insert-char char 1))))

(add-hook
 'TeX-mode-hook
 (function
  (lambda ()
    (define-key LaTeX-mode-map [f2] 'acento)
    (define-key LaTeX-mode-map [f3] 'acordes)
    (define-key LaTeX-mode-map [f4] 'remesp)
    (define-key LaTeX-mode-map [f5] 'circelus)
    (define-key LaTeX-mode-map [f6] 'subrayado)
;;    (define-key LaTeX-mode-map [f7] 'chord)
    (define-key LaTeX-mode-map [f8] 'chord)
    (define-key LaTeX-mode-map [f9] 'puntoSubrayado)
;;    (define-key LaTeX-mode-map [f8] 'spchars)
    )
  )
 )


;; Drag Mode Line
;(global-set-key [mode-line down-mouse-1] 'mldrag-drag-mode-line)
;(global-set-key [vertical-line down-mouse-1] 'mldrag-drag-vertical-line)
;(require 'mldrag)

;; Archie
(autoload 'archie "archie" "Archie interface" t)
(setq archie-search-type "case-insensitive")
;;(autoload 'archie-sez "archie" "Insert results of archie query" t)
(setq archie-server "archie.sura.net")

;; FAQ
(autoload (function find-faq) "faq"
  "*Find the archived Usenet NEWSGROUP FAQ file..." t)

;; ISPELL (watch out -- using v3, which is better than the v4 built into E19 
(load "ispell")		;interactive spelling checker
(autoload 'ispell-word "ispell"
  "Check the spelling of word in buffer." t)
(autoload 'ispell-region "ispell"
  "Check the spelling of region." t)
(autoload 'ispell-buffer "ispell"
  "Check the spelling of buffer." t)
(autoload 'ispell-complete-word "ispell"
  "Look up current word in dictionary and try to complete it." t)
(autoload 'ispell-change-dictionary "ispell"
  "Change ispell dictionary." t)
(autoload 'ispell-message "ispell"
  "Check spelling of mail message or news post.")
(setq ispell-check-comments t)
;; checks each word as it is typed
(autoload 'auto-ispell-mode "ispell-mode" "Check every word as it is typed" t)
;; Useful only for troff:
(defvar ispell-words-have-boundaries nil)
;; May not work
(defvar ispell-highlight t)
(global-set-key "\e$" 'ispell-word)
;; Not necessary in ispell 3 (but it is in ispell 4?)
;;(defvar ispell-program-name "detex -w | spell")

;; Ask if directory should be created if it doesn't exist - MH
(setq find-file-not-found-hooks
      (list 
       (function 
	(lambda ()
	  (let ((dir (file-name-directory buffer-file-name)))
	    (if (and (not (file-exists-p (directory-file-name dir)))
		     (y-or-n-p (format 
				"Directory not found: %s --- Create? " 
				dir)))
		(make-directory dir t)))))))

; -------------------------------------------------------------------------
; If you want cleanup of temporary files:
; (add-hook 'kill-buffer-hook 'ciao-del-temp-file)    
; -------------------------------------------------------------------------

;; Source debugger and emacs debugger support (old version!)
;; (load "/usr/local/lib/emacs/site-lisp/source_debug-1.1/sicstus-debug")

;; Some `global-set-key's
;;
;;(global-set-key "\C-cm" 'rmail)
;;(global-set-key [f8] 'rmail)
;; for stupid terminals which catch C-s
(global-set-key "\C-x\C-m" 'save-buffer)

;; WAS (defun html-accent-next-letter (char)
(defun html-accent-letter (char)
  "Inserts all the auxiliary characters to write Spanish in HTML."
  (interactive "*c")
  ( cond
    ((equal char ?n) (insert-string  "&ntilde;"))
    ((equal char ?N) (insert-string  "&Ntilde;"))
    ((equal char ?a) (insert-string  "&aacute;"))
    ((equal char ?e) (insert-string  "&eacute;"))
    ((equal char ?i) (insert-string  "&iacute;"))
    ((equal char ?o) (insert-string  "&oacute;"))
    ((equal char ?u) (insert-string  "&uacute;"))
    ((equal char ?A) (insert-string  "&Aacute;"))       
    ((equal char ?E) (insert-string  "&Eacute;"))
    ((equal char ?I) (insert-string  "&Iacute;"))
    ((equal char ?O) (insert-string  "&Oacute;"))
    ((equal char ?U) (insert-string  "&Uacute;"))
     ( t (insert-char char 1))))

;; ALTERNATIVE
;; html-helper-mode <begin>
(setq auto-mode-alist
      (cons '(".*\\.html$".html-helper-mode) auto-mode-alist))
(autoload 'html-helper-mode "html-helper-mode" "Edit HTML docs" t)
(setq html-helper-address-string 
      "<a href=\"http://www.clip.dia.fi.upm.es/~german\">German Puebla</a>")
(setq html-helper-do-write-file-hooks t); update time stamp
(setq tempo-interactive nil)              ; DO NOT ask in the buffer
(setq html-helper-build-new-buffer t)
(setq html-helper-timestamp-start "<!-- hhmts start -->\n<em>\n")
(setq html-helper-timestamp-end "</em>\n<!-- hhmts end -->\n")

(defun html-save-file ()
    (interactive)
    (save-buffer)
    (shell-command 
        (concat 
            "chmod og-rwx " 
            (buffer-file-name) 
            "; chmod g+wr " 
            (buffer-file-name) 
            "; chgrp webboss "
            (buffer-file-name) 
            " \n")
            nil)
)

(add-hook
 'html-helper-mode-hook
 (function
  (lambda ()
    (auto-fill-mode)
    (define-key html-helper-mode-map [f2] 'html-accent-letter)
    (define-key html-helper-mode-map "\C-x\C-s" 'html-save-file)
)))

(if (not window-system) (setq baud-rate 38400))
(if window-system
    (progn
      (setq baud-rate 153600) ;; Seems to speed up things?
;;       (set-default-font 
;;        "-adobe-courier-medium-r-normal--14-100-100-100-m-90-iso8859-1")
;; For Balboa:
;;       (set-default-font 
;;        "fixed")
      (set-foreground-color "black")
      (set-background-color "white")
;; To distinguish emacs at clip from others...
       (cond 
        ((equal (system-name) "clip.dia.fi.upm.es")
 	(set-background-color "Wheat")
;; 	;; following two lines for logging in from elcano
;; 	;; good size/font for Linux + external Sun-size monitor
;; 	(set-frame-size (selected-frame) 80 51)
;; 	(set-default-font "9x15")
 	))
;;        ((equal (system-name) "orion.ctp.fi.upm.es")
;; 	(set-background-color "grey90"))
;;        ((equal (system-name) "elcano.dia.fi.upm.es")
;; 	;; good size/font for Linux + xga LCD panel
;; 	(set-frame-size (selected-frame) 80 47)
;; 	(set-default-font "9x15"))
;;        )
;;       (set-border-color "green")
;; The modeline has its own face. You can change its foreground color
;; within your .emacs with:
;; 
;	(set-face-background 'modeline "darkslateblue")
;	(set-face-foreground 'modeline "yellow")
;; ;; 
;; ;; Or you could use any of these functions:
;; ;; 
;; 	(set-face-font        'face "<NameOfFont>")
;; 	(set-face-underline-p 'face <nil or t>)
;; 	(set-face-foreground  'face "<NameOfColor>")
;; 	(set-face-background  'face "<NameOfColor>")
;; 	(set-face-background-pixmap 'face "<NameOfPixmap>")
;;
;; This sort of works, but looks terrible with hilit
;      (if (eq invocation 'main)
;	  (set-foreground-color "black") )
;    (if (eq invocation 'clip)
;		(set-foreground-color "green") ) 
;	    (if (eq invocation 'basic)
;		(set-foreground-color "orange") )
;	    (if (eq invocation 'main)
;		(set-background-color "black") )
;	    (if (eq invocation 'clip)
;		(set-background-color "Grey20") ) 
;	    (if (eq invocation 'basic)
;		(set-background-color "Grey20") )
	    (set-cursor-color "red")
	    (set-mouse-color "NavyBlue")
	    ))


(defun svgaemacs () (interactive)
	(set-frame-size (selected-frame) 80 36))
(defun vgaemacs () (interactive)
	(set-frame-size (selected-frame) 67 28))

;; Get started
(turn-on-auto-fill)

;; OZ
;; where to find oz-mode
(setq load-path (cons (concat (getenv "OZHOME") "/lib/elisp") load-path))
;; autoload "oz.el" if the functions oz-mode or run-oz are executed
(autoload 'oz-mode "oz" "" t)
(autoload 'run-oz "oz" "" t)
;; enter Oz mode if a file with the suffix ".oz" is loaded 
(setq auto-mode-alist (cons '("\.oz$" . oz-mode) auto-mode-alist))


;; blast those MIME characters
(defun off-quoted-printable ()
  "Make readable quoted-printable emails from point downwards.
Substitute =<hex codes> triples by the character with this hexadecimal code,
and suppress =<RET> tuples."
  (interactive)
  (let ((inipt (point)))
    (setq inhibit-read-only t)
    (while (search-forward "=" nil t)
      (if (= (following-char) 10) ; newline
          (progn
            (delete-char -1)
            (delete-char 1))
        ;; else
        (let* ((h1 (hex-val (following-char)))
               (h0 (hex-val (char-after (+ 1 (point)))))
               (ch (and h1 h0 (+ (* 16 h1) h0))))
          (if ch
              (progn
                (delete-char -1)
                (delete-char 2)
                (insert-char ch 1))))))
    (setq inhibit-read-only nil)
    (goto-char inipt)))

(defun hex-val (N)
  (cond ((and (>= N ?0) (<= N ?9)) (- N ?0))
        ((and (>= N ?A) (<= N ?F)) (+ 10 (- N ?A)))))

;; tired of typing this
;; (defun ak () (interactive) (find-file "/home/clip/bibtex/clip/a_k.bib"))
;; (defun lz () (interactive) (find-file "/home/clip/bibtex/clip/l_z.bib"))
;;(defun clip () (interactive) (find-file "/home/clip/bibtex/clip/clip.bib"))
(defun others () (interactive) (find-file "/home/clip/bibtex/clip/others.bib"))
(defun curr () (interactive) (find-file "/home/clip/Projects/curr_herme/NEWTHINGS"))
(defun jlp () (interactive) (find-file
			     "/home/herme/conferences/JLP/db_papers.pl")) 
(defun pdbs () (interactive) (find-file
			     "/home/herme/PDBS/D/dbase.pl")) 
;; (require 'browse-url)

;; (require 'altavista)

;; Split LaTeX slide
(defun split-slide ()
  "Split latex slide at point (just a hack...)"
  (interactive)
  (beginning-of-line)
  (newline)
  (LaTeX-close-environment)
  (search-backward "\\end{")
  (forward-char 4)
  (set-mark (point))
  (search-forward "}")
  (setq env (buffer-substring (mark) (point)))
  (newline 2)
  (insert-string 
   "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
  (newline)
  (insert-string "\\stitle{")
  (previous-line 1)
  (search-backward-regexp "\\(\\\\stitle\\|\\\\subsection\\)")
  (beginning-of-line)
  (set-mark (point))
  (end-of-line)
  (setq str (buffer-substring (mark) (point)))
  (next-line 1)
  (search-forward "\\stitle")
  (beginning-of-line)
  (delete-char 8)
  (insert-string str)
  (backward-char 1)
  (insert-string " (Contd.)")
  (forward-char 1)
  (newline)
  (insert-string 
   "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
  (newline 2)
  (insert-string "\\begin")
  (insert-string env)
;;  (hilit-recenter nil)
)

(defun xfig-insert-new-figure ()
  "Insert figure at point and start xfig on it."
  (interactive)
  (let (figname)
    (setq figname (read-string "Figure name?" "fig"))
    (insert-string (concat "\\begin{center}\n"
			   " \\mbox{\\psfig{figure=\\figpath/"
			   figname
			   ".eps,width=0.5\\basewidth}}\n"
			   "\\end{center}\n"
			   )))
  (previous-line 2)
  (save-buffer)
  (xfig-figure)
  )

(defun xfig-figure ()
  "Start xfig on figure around point (just a hack...)"
  (interactive)
  (beginning-of-line)
  (search-forward-regexp "\\(.eps\\|.ps,\\)")
  (backward-char 4)
  (set-mark (point))
  (search-backward "/")
  (forward-char 1)
  (shell-command (concat "cd Figs; xfig "
                         (buffer-substring (mark) (point))
			 ".fig &"))
  ;; (bury-buffer "*Async Shell Command*")
  )

;; Setup Demo screens (EXPO'97 configuration)
(defun demo-frame ()
  "Create a frame with suitable dimensions for demos."
  (interactive)
  (tool-bar-mode 1)
  (setq demoframe 
	(new-frame '((user-position . t) ;(top . 0) (left . 80)
		     (name . "Demo Screen") 
		     (height . 34) 
		     (width . 68) 
		     (minibuffer . t) )))
  (select-frame demoframe)
;;  (scroll-bar-mode nil)
;;  (set-default-font
;;  "-adobe-courier-bold-r-normal--*-200-*-*-m-*-iso8859-1")
(set-default-font "-adobe-courier-bold-r-normal--24-240-75-75-m-150-iso8859-1" nil)
; (set-default-font "-adobe-courier-bold-r-normal--*-240-*-*-m-*-iso8859-1")  
  (shell)
;;  (set-background-color "black")
;;  (set-foreground-color "white")
  (set-background-color "white")
  (set-foreground-color "black")
  (rename-buffer "demo-shell")
  (comint-send-string (get-buffer-process (current-buffer)) "stty cols 67\n")
  (comint-send-string (get-buffer-process (current-buffer)) "stty rows 29\n")
  )
(defun demo-frame-xga ()
  "Create a frame with suitable dimensions for demos."
  (interactive)
;  (tool-bar-mode)
  (setq demoframe 
	(new-frame '((user-position . t) ;(top . 0) (left . 80)
		     (name . "Demo Screen") 
		     (height . 29) 
		     (width . 63) 
		     (minibuffer . t) )))
  (select-frame demoframe)
;;  (scroll-bar-mode nil)
;;  (set-default-font
;;  "-adobe-courier-bold-r-normal--*-200-*-*-m-*-iso8859-1")
 (set-default-font "-adobe-courier-bold-r-normal--*-240-*-*-m-*-iso8859-1")  
  (shell)
;;  (set-background-color "black")
;;  (set-foreground-color "white")
  (set-background-color "white")
  (set-foreground-color "black")
  (rename-buffer "demo-shell")
  (comint-send-string (get-buffer-process (current-buffer)) "stty cols 61\n")
 (comint-send-string (get-buffer-process (current-buffer)) "stty rows 28\n")
  )
;;comint-last-input-start
;; (top . 1) (left . 1)
(defun demoxdvi ()
  (interactive)
  (setq tex-dvi-view-command "/home/clip/Systems/xdvipresent/present svga"))
(defun normalxdvi ()
  (interactive)
  (setq tex-dvi-view-command "xdvi"))
;;  (setq tex-dvi-view-command "~/xdvipresent/xdvik/xdvi.sh")
;; (demoxdvi)

;; ;; Always battling those stupid C-Ms
;; ;; (add-hook 'comint-output-filter-functions 'rlogin-carriage-filter)
;; (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
;; (add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

; Comments the current region. The string used to comment is decided by the
;; function comment-prefix-from-mode, and passed to comment-ask-region.

(defun flex-comment-region ()
  "Make the region a comment block. Comment prefix is decided based on the major mode."
  (interactive)
  (comment-ask-region (comment-prefix-from-mode))
  )

(global-set-key "\e\"" 'flex-comment-region)

(defun comment-out-region (S)
  "Make the region a comment block..."
  (interactive "sComment with:")
  (save-excursion
    (if (< (mark) (point)) (exchange-point-and-mark))
    (if (= (current-column) 0) (insert-string S))
    (while (progn
	     (forward-line)
	     (< (point) (mark)))
      (insert-string S))))
(global-set-key "\C-c;" 'comment-out-region)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Function to visit the file just produced by ciao (add to ciao.el?)
;; Position the cursor in the compiler window and call the function.
(defun visit-last-ciao-output-file ()
  (interactive)
  (end-of-buffer)
  (search-backward "{written")
  (search-forward "}")
  (search-backward "/")
  (forward-char 1)
  (set-mark (point))
  (search-forward "}")
  (backward-char 1)
  (setq name (buffer-substring (mark) (point)))
  (end-of-buffer)
  (find-file name))
;; *** Should really be local to ciao-shells...
(global-set-key "\C-c\C-b" 'visit-last-ciao-output-file)

(defun off-quoted-printable ()
  "Make readable quoted-printable emails from point downwards.
Substitute =<hex codes> triples by the character with this hexadecimal code,
and suppress =<RET> tuples."
  (interactive)
  (let ((inipt (point)))
    (setq inhibit-read-only t)
    (while (search-forward "=" nil t)
      (if (= (following-char) 10) ; newline
          (progn
            (delete-char -1)
            (delete-char 1))
        ;; else
        (let* ((h1 (hex-val (following-char)))
               (h0 (hex-val (char-after (+ 1 (point)))))
               (ch (and h1 h0 (+ (* 16 h1) h0))))
          (if ch
              (progn
                (delete-char -1)
                (delete-char 2)
                (insert-char ch 1))))))
    (setq inhibit-read-only nil)
    (goto-char inipt)))

(defun hex-val (N)
  (cond ((and (>= N ?0) (<= N ?9)) (- N ?0))
        ((and (>= N ?A) (<= N ?F)) (+ 10 (- N ?A)))))

; //)

;; (add-hook 'comint-output-filter-functions 'rlogin-carriage-filter)
;; (add-hook 'comint-output-filter-functions  'comint-truncate-buffer)
(add-hook 'comint-output-filter-functions  'comint-watch-for-password-prompt)
;; Always battling those stupid C-Ms -- does this work?
(add-hook 'comint-output-filter-functions  'comint-strip-ctrl-m)

;; for headers (MCL)
;;(load "header")

(defun header-m2-prefix-string () " * ")
(defun header-m2-start () (insert  "(** \n"))
(defun header-m2-end ()   (insert " **)\n\n"))
(defun m2-pre-post ()
    (interactive)
    (header-m2-start)
    (insert " * PRE: ")
    (setq m2-local-point (point))
    (insert "\n * \n")
    (insert " * POST: \n")
    (insert " * SOL: \n")
    (insert " * COMPLEJIDAD: O()\n")
    (header-m2-end)
    (goto-char m2-local-point)
)

(defun m2-mode-init ()
        (make-local-variable 'make-header-hooks)
        (setq make-header-hooks '(header-m2-start
                                  header-file-name
                                  header-copyright
                                  header-AFS
                                  header-author
                                  header-creation-date
                                  header-modification-author
                                  header-modification-date
                                  header-update-count 
                                  header-status
                                  header-m2-end))
        (define-key m2-mode-map "\C-c\C-p" 'm2-pre-post)
)

(add-hook 'm2-mode-hook 'm2-mode-init)

(defun portable ()
  (or 
   (equal (system-name) "morena.ls.fi.upm.es")
   )
  )



(defun large-font ()
  (interactive)
  (set-default-font 
          "-adobe-courier-bold-r-normal--24-240-75-75-m-150-iso8859-1")
)

(defun medium-font ()
  (interactive)
  (set-default-font 
          "-adobe-courier-bold-r-normal--20-140-100-100-m-110-iso8859-1")
)

(defun small-font ()
  (interactive)
  (set-default-font 
           "-adobe-courier-bold-r-normal--17-120-100-100-m-100-iso8859-1")
)

;(medium-font)

; different configurations for different screen sizes
(if     ( or (equal (system-name) "costa.ls.fi.upm.es")
	     (equal (system-name) "espadin")
	)
    (large-font) 
    nil)

(if     (portable)
    (tool-bar-mode nil)
    nil)



(setq shell-prompt-pattern "^\\([^#$%> \n]*[#$%>]+\\|[0-9]* *\\?-\\) +")

(add-hook 'shell-mode-hook
           (function (lambda () (setq font-lock-defaults nil))))

(defun clip ()
  "inserts the full internet address of the clip main server."
  (interactive)
  (insert-string "clip.dia.fi.upm.es"))

(defun clip1 ()
  "inserts the full internet address of the clip main server."
  (interactive)
  (insert-string "clip1.dia.fi.upm.es"))

(defun svnrep ()
  "inserts the prefix for clip SVN repositories."
  (interactive)
  (insert-string "svn+ssh://clip/home/clip/SvnReps")
)

(defun cpp ()
  "loads ciaopp in the ciao top-level."
  (interactive)
  (insert-string "use_module(ciaopp(ciaopp)).")
  (comint-send-input)
  (insert-string "set_pp_flag(fixpoint,di).")
  (comint-send-input)
;;   (insert-string "set_pp_flag(intermod,on).")
;;   (comint-send-input)
;;   (insert-string "set_pp_flag(part_conc,on).")
;;   (comint-send-input)
)

(defun prepare ()
  "loads ciaopp in the ciao top-level."
  (interactive)
  (insert-string "use_module(myprofiler_rt).")
  (comint-send-input)
  (insert-string "init_counter.")
  (comint-send-input)
  (insert-string "use_module(kalman_self_cont).")
  (comint-send-input)
  (insert-string "set_pp_flag(unf_bra_fac,0).")
  (comint-send-input)
  (insert-string "set_pp_flag(sim_ari_exp,both).")
  (comint-send-input)
  (insert-string "set_menu_flag(opt, global_control,off).")
  (comint-send-input)
)

(defun myciaopp ()
  "starts ciaopp and sets intermod to on."
  (interactive)
  (ciaopp)
  (insert-string "set_pp_flag(intermod,on).")
  (comint-send-input)
)

(defun hats ()
  "changes to the HATS directory."
  (interactive)
  (insert-string "cd ~/Projects/EU/HATS/HATS-global")
  (comint-send-input)
)

(defun hats-frontend ()
  "changes to the HATS frontend directory."
  (interactive)
  (insert-string "cd ~/Projects/EU/HATS/HATS-global/Tools/ABS/trunk/frontend")
  (comint-send-input)
)

(defun hats-model-mining ()
  "changes to the HATS Model Mining directory."
  (interactive)
  (insert-string "cd ~/Projects/EU/HATS/HATS-global/WP3_Evolvability/Task-3.2_ModelMining/")
  (comint-send-input)
)

(defun ping ()
  "pings for testing network"
  (interactive)
  (insert-string "ping lml.ls.fi.upm.es")
  (comint-send-input)
)

(defun benchmarks ()
  "changes to the Benchmarks directory."
  (interactive)
  (insert-string "cd /home/german/Papers/AI-with-spec-def/Experiments/Benchmarks")
  (comint-send-input)
)

(defun driver ()
  "changes to the COSTA driver directory."
  (interactive)
  (insert-string "cd ~/Systems/costa/main/src/driver")
  (comint-send-input)
)

(defun hatsc ()
  "changes to the HATS central repository."
  (interactive)
  (insert-string "cd ~/Projects/EU/proposals/FET-FY/Central_Repository")
  (comint-send-input)
)

;; Shell names
(setq current_shell_number 0)
(defun new-shell ()
  "Same as shell, but gives the shell an appropriate name"
  (interactive)
  (save-window-excursion
    (shell)
;; ??
;;    (define-key shell-mode-map "\C-i" 'in-line-file-name-completion)
    )
  (switch-to-buffer "*shell*")
  (setq current_shell_number (+ 1 current_shell_number))
  (setq shell-name (concat (int-to-string current_shell_number) "shell"))
  (rename-buffer shell-name)
  )
(global-set-key "\C-cns" 'new-shell)

(new-shell)
(server-start)
(put 'set-goal-column 'disabled nil)
(put 'eval-expression 'disabled nil)

(scroll-bar-mode nil)

;; Haskell stuff
(setq auto-mode-alist
      (append auto-mode-alist
	      '(("\\.[hg]s$"  . haskell-mode)
		("\\.hi$"     . haskell-mode)
		("\\.l[hg]s$" . literate-haskell-mode))))
(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts." t)
;; To turn any of the supported modules on for all buffers, add the
;; appropriate line(s) to .emacs:
(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs)



;(custom-set-faces
; '(modeline ((t (:inverse-video t :foreground "yellow" :background "darkslateblue")))))


(set-background-color "gray")
;(set-background-color "black")
(set-foreground-color "black")

(setq completion-ignored-extensions
      (append '(".o" ".ali")
              completion-ignored-extensions))

;;(require 'mime-compose)


(custom-set-faces
  ;; custom-set-faces was added by Custom -- don't edit or cut/paste it!
  ;; Your init file should contain only one such instance.
 )

(defun tasks () (interactive) (find-file
			     "/home/clip/public_html/Local/ClipTasks/tasks/")) 


;(setenv "MAILHOST" "clip.dia.fi.upm.es")
;(setenv "MAILHOST" "smtp.ruc.dk")

(defun view-html-environment ()
  (interactive)
  (search-backward "<html>")
  (set-mark (point))
  (search-forward "</html>")
  (view-html-region-arg (buffer-substring (mark) (point)))
)

(defun view-html-region ()
  (interactive)
  (view-html-region-arg (buffer-substring (mark) (point))))

(defun view-html-region-arg (region)
  (find-file "/tmp/tmphtml.htm")
  (beginning-of-buffer)
  (set-mark (point))
  (end-of-buffer)
  (delete-region (mark) (point))
  (insert-string region)
  (save-buffer (current-buffer))
  (kill-buffer (current-buffer))
  (w3m-find-file "/tmp/tmphtml.htm"))

;; Fix spanish accents from latex to ascii - MH
(defun ISO-unfix-accents ()
  "Fix spanish accents: from latex to ascii format"
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (replace-string        "\\'\{a\}" "á"  ) ;; a' 
    (beginning-of-buffer)
    (replace-string        "\\'\{e\}" "é"  ) ;; e'
    (beginning-of-buffer)
    (replace-string        "\\'\{\\i\}" "í") ;; i'
    (beginning-of-buffer)
    (replace-string        "\\'\{o\}" "ó"  ) ;; o'
    (beginning-of-buffer)
    (replace-string        "\\'\{u\}" "ú"  ) ;; u'
    (beginning-of-buffer)
    (replace-string        "\\\"\{u\}" "" ) ;; u:
    (beginning-of-buffer)
    (replace-string        "\\~\{n\}" "ñ"  ) ;; n~ 
    (beginning-of-buffer)
    (replace-string        "\\'\{A\}" "Á"  ) ;; A' 
    (beginning-of-buffer)
    (replace-string        "\\'\{E\}" "É"  ) ;; E'
    (beginning-of-buffer)
    (replace-string        "\\'\{I\}" "Í"  ) ;; I'
    (beginning-of-buffer)
    (replace-string        "\\'\{O\}" "Ó"  ) ;; O'
    (beginning-of-buffer)
    (replace-string        "\\'\{U\}" "Ú"  ) ;; U'
    (beginning-of-buffer)
    (replace-string        "\\~\{N\}" "Ñ"  ) ;; N~ 
    (beginning-of-buffer)
    (replace-string        "\\\"\{U\}" "š" ) ;; U:
    (beginning-of-buffer)
    (replace-string        "!\`" "¡") ;; begin exclamation mark
    )
  )



(server-start)

;(setq ciao-ciaopp-use-graphical-menu nil)
(setq ciao-ciaopp-use-graphical-menu t)


;; -------------------------------------------------------------------------
;; Help for cleaning up
;; -------------------------------------------------------------------------

(defun du (depth)
  "Run du command on current dir. Prefix is tree depth level. Default=1." 
  (interactive "p")
  (let ((nchars 0) (lines 0) (newbuff nil) (maxdigits 8))
    (setq newbuff (get-buffer-create "du"))
    (switch-to-buffer newbuff)
    (erase-buffer)
    (message "Running 'du' command on current dir...")
    (call-process 
     "du" nil newbuff  t  (concat "--max-depth=" (number-to-string depth)) ".")
    (message "Padding buffer with zeros...")
    (delete-blank-lines)
    (untabify (point-min) (point-max))
    (goto-char (point-min))
    (while 
	(progn
	  (beginning-of-line)
	  (set-mark (point))
	  (forward-word 1)
	  (setq nchars (- maxdigits (current-column)))
	  (beginning-of-line)
	  (insert-char ?0 nchars)
	  (beginning-of-line)
	  (forward-word 1)
	  (insert-char ?  (- maxdigits nchars))
	  (beginning-of-line)
	  (forward-word 1)
	  (if (> (- (point-max) (point)) (- maxdigits 1))
	      (delete-char (- maxdigits 1))
	    (delete-char (- (point-max) (point))))
	  ;; Test for end of buffer
	  (= (forward-line 1) 0)))
    (message "Sorting buffer...")
    (sort-lines t (point-min) (point-max))
    (beginning-of-buffer)
    (message "Done.")
    ))

;; Commenting regions. 

;; If argument (a string) is provided, the region is commented out with this
;; string. If the argument is not provided, the user is asked for it.
(defun comment-ask-region (S)
  "Make the region a comment block..."
  (interactive "sComment with:")
  (save-excursion
    (if (< (mark) (point)) (exchange-point-and-mark))
    (if (= (current-column) 0) (insert-string S))
    (while (progn
         (forward-line)
         (< (point) (mark)))
      (insert-string S))))
(global-set-key "\C-c?" 'comment-ask-region)

;; Comments the current region. The string used to comment is decided by the
;; function comment-from-major-mode, and passed to comment-ask-region.
(defun flex-comment-region ()
  "Make the region a comment block. Comment prefix is decided based on the major mode"
  (interactive)
  (comment-ask-region (comment-prefix-from-mode))
  )
(global-set-key "\C-c;" 'flex-comment-region)
;; A binding for the emacs native comment-region facility
;; tried to customize it, but it needs a hook for every mode and it
;; was more work than just taking flex-comment-region
(global-set-key "\C-c%" 'comment-region)

;; Returns comment prefix string according to current major mode. If
;; unknown, an error message is issued.
(defun comment-prefix-from-mode ()
  (cond
   ((eq major-mode 'emacs-lisp-mode) ";; ")
   ((eq major-mode 'c-mode) "* ")               ;; Only to highlight
   ((eq major-mode 'prolog-mode) "%% ")
   ((eq major-mode 'and-prolog-mode) "%% ")
   ((eq major-mode 'ciao-mode) "%% ")
   ((eq major-mode 'text-mode) "# ")             ;; Usually scripts
   ((eq major-mode 'tex-mode) "%% ")        
   ((eq major-mode 'latex-mode) "%% ")
   ((eq major-mode 'bibtex-mode) "%% ")
   ((eq major-mode 'TeX-mode) "%% ")        
   ((eq major-mode 'LaTeX-mode) "%% ")
   ((eq major-mode 'LaTeX2e-mode) "%% ")
   ((eq major-mode 'pdbs-mode) "%% ")
   ((eq major-mode 'mail-mode) " > ")
   ((eq major-mode 'rmail-edit-mode) " > ")
   (t (error (format "Unknown comment symbol for %s mode!" mode-name) "")))
  )

(defun scroll-one-line-up (&optional arg)
  "Scroll the selected window up (forward in the text) one line (or N lines)."
  (interactive "p")
  (scroll-up (or arg 1)))

(defun scroll-one-line-down (&optional arg)
  "Scroll the selected window down (backward in the text) one line (or N)."
  (interactive "p")
  (scroll-down (or arg 1)))

(global-set-key "\C-z" 'scroll-one-line-up)
(global-set-key "\ez" 'scroll-one-line-down)

; Making SWI the default Prolog mode in emacs
(setq auto-mode-alist (cons '("\\.pl$" . prolog-mode) auto-mode-alist))
(setq prolog-system (quote swi))

; Loading the ABS and MAUDE modes for emacs from HATS svn repo
(if (file-exists-p "~/Projects/EU/HATS/HATS-global/Tools/ABS-emacs/maude-mode.el")
(progn 
  (load "maude-mode.el")
  (load "peg.el")
  (load "abs-visualization.el")
  (load "abs-mode.el"))
)

; Loading the ABS and MAUDE modes for emacs from new abstools git repo
(if (file-exists-p "~/Systems/abstools/emacs/abs-mode.el")
(progn 
;  (load "maude-mode.el")
  (load "abs-mode.el"))
)

;(require 'php-mode)

; Leicester's directories
; TODO: FIX
(defun leicestermount ()
  "mounts Leicester's directories."
  (interactive)
  (message "Mounting Leicester's directories...")
  (insert-string "sudo mkdir -p /Volumes/leicester/resources/CO3095;")
  (newline)
  (insert-string "sudo mkdir -p /Volumes/leicester/CO-Modules18-19;")
  (newline)
  (insert-string "sudo mkdir -p /Volumes/leicester/texmf;")
  (newline)
  (insert-string "sudo sshfs -o allow_other,defer_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 jmrs3@nyx.mcs.le.ac.uk:/var/cscampus/teaching/resources/CO3095 /Volumes/leicester/resources/CO3095;")
  (newline)
  (insert-string "sudo sshfs -o allow_other,defer_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 jmrs3@nyx.mcs.le.ac.uk:/MCS-Local/Data/ModuleForms/CO-Modules18-19/ /Volumes/leicester/CO-Modules18-19;")
  (newline)
  (insert-string "sudo sshfs -o allow_other,defer_permissions,reconnect,ServerAliveInterval=15,ServerAliveCountMax=3 jmrs3@nyx.mcs.le.ac.uk:/MCS-Local/TeX/teTeX-local/texmf/ /Volumes/leicester/texmf")
  (newline)
)
