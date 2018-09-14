
;; Added by Package.el.  This must come before configurations of
;; installed packages.
(package-initialize)

(load-file "~/Custom-files/Config/emacs-common.el")

;; dracula theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'dracula t)

;; ido mode
(require 'ido)
(ido-mode t)
