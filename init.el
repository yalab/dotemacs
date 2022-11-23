(setq inhibit-startup-message t)
(setq make-backup-files nil)
(setq auto-save-default nil)

(if window-system
  (progn (tool-bar-mode -1)
         (menu-bar-mode -1)))

; color
(setq black  "black")
(setq red    "#ff6666")
(setq green  "#66ff66")
(setq yellow "#ffd314")
(setq blue   "#6699ff")
(setq cyan   "cyan")
(setq white  "white")
(setq magenta "#9966ff")
(set-face-foreground 'font-lock-comment-face red)
(set-face-foreground 'font-lock-string-face  green)
(set-face-foreground 'font-lock-keyword-face cyan)
(set-face-bold-p     'font-lock-keyword-face t)
(set-face-foreground 'font-lock-function-name-face blue)
(set-face-bold-p     'font-lock-function-name-face t)
(set-face-foreground 'font-lock-variable-name-face yellow)
(set-face-foreground 'font-lock-type-face green)
(set-face-foreground 'font-lock-builtin-face magenta)
(set-face-foreground 'font-lock-constant-face magenta)
(set-face-foreground 'font-lock-warning-face white)
(set-face-bold-p 'font-lock-warning-face nil)

(setq font-family "Ricty")

(if window-system
  (progn (set-background-color "Black")
         (set-foreground-color "LightGray")
         (set-cursor-color "Gray")
         (set-frame-parameter nil 'alpha 90)
         (setq default-frame-alist (append (list '(width . 95)
						 '(height . 30))
					   default-frame-alist))
         (set-face-attribute 'default nil :family font-family :height 140)
         (set-fontset-font
          nil 'japanese-jisx0208
          (font-spec :family font-family))))

; package
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(js2-mode yaml-mode rbs-mode lsp-mode elm-mode typescript-mode counsel nyan-mode flycheck migemo)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(if (string= system-type "darwin")
  (progn (add-to-list 'exec-path "/opt/homebrew/bin")
         (setq ns-command-modifier (quote meta))))

(setq migemo-command "cmigemo")
(setq migemo-options '("-q" "--emacs" "-i" "\g"))
(cond ((string= system-type "darwin")
       (setq migemo-dictionary "/opt/homebrew/Cellar/cmigemo/20110227/share/migemo/utf-8/migemo-dict"))
      (t
       (setq migemo-dictionary "/usr/share/cmigemo/utf-8/migemo-dict")))
(setq migemo-coding-system 'utf-8-unix)
(setq migemo-user-dictionary nil)
(setq migemo-regex-dictionary nil)
(load-library "migemo")
(migemo-init)

(require 'flycheck)
(add-hook 'ruby-mode-hook
          '(lambda ()
             (setq flycheck-checker 'ruby-rubocop)))
(add-hook 'typescript-mode-hook
          '(lambda ()
             (setq flycheck-checker 'javascript-eslint)))
(flycheck-mode 1)


;(with-eval-after-load 'flycheck
;  (flycheck-add-mode 'javascript-eslint 'typescript-mode)

(require 'nyan-mode)
(nyan-mode)
(nyan-start-animation)

(require 'ivy)
(ivy-mode t)
(global-set-key (kbd "M-;") 'counsel-ibuffer)
(global-set-key (kbd "M-'") 'counsel-git-grep)
(add-to-list 'ivy-more-chars-alist '(counsel-git-grep . 3))
