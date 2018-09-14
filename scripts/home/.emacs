;; ____________________________________________________________________________
;; Aquamacs custom-file warning:
;; Warning: After loading this .emacs file, Aquamacs will also load
;; customizations from `custom-file' (customizations.el). Any settings there
;; will override those made here.
;; Consider moving your startup settings to the Preferences.el file, which
;; is loaded after `custom-file':
;; ~/Library/Preferences/Aquamacs Emacs/Preferences
;; _____________________________________________________________________________

;; Added by Package.el.  This must come before configurations of
;; installed packages.
(require 'package)
(package-initialize)

(add-to-list 'package-archives
             '("melpa-stable" . "http://stable.melpa.org/packages/")
             t)

(load-file "~/Systems/jmrojas.github.io/scripts/emacs/emacs-common.el")

;; dracula theme
(add-to-list 'custom-theme-load-path "~/Systems/jmrojas.github.io/scripts/emacs/themes")
(load-theme 'dracula t)

;; ido mode
(require 'ido)
(ido-mode t)
