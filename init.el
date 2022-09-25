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
          (font-spec :family font-family))
))

