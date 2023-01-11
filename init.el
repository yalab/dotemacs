;;; init.el --- initialize yalab emacs   -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(setq inhibit-startup-message t)
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq indent-tabs-mode nil)

(if window-system
  (progn (tool-bar-mode -1)
         (menu-bar-mode -1)))

; color
(let (red green yellow blue cyan white magenta)
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
  (set-face-bold     'font-lock-keyword-face t)
  (set-face-foreground 'font-lock-function-name-face blue)
  (set-face-bold     'font-lock-function-name-face t)
  (set-face-foreground 'font-lock-variable-name-face yellow)
  (set-face-foreground 'font-lock-type-face green)
  (set-face-foreground 'font-lock-builtin-face magenta)
  (set-face-foreground 'font-lock-constant-face magenta)
  (set-face-foreground 'font-lock-warning-face white)
  (set-face-bold 'font-lock-warning-face nil))

(let (font-family)
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
              (font-spec :family font-family)))))

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
   '(dockerfile-mode exec-path-from-shell toml-mode rust-playground lsp-ui rustic use-package web-mode js2-mode yaml-mode rbs-mode lsp-mode elm-mode typescript-mode counsel nyan-mode flycheck migemo)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(if (string= system-type "darwin")
  (progn (add-to-list 'exec-path "/opt/homebrew/bin")
         (setq ns-command-modifier (quote meta))))

(require 'migemo)
(let (migemo-command migemo-options migemo-dictionary migemo-coding-system migemo-user-dictionary migemo-regex-dictionary)
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
  (migemo-init))

(require 'flycheck)
(add-hook 'ruby-mode-hook
          #'(lambda ()
             (setq flycheck-checker 'ruby-rubocop)))
(add-hook 'typescript-mode-hook
          #'(lambda ()
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

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'"   . js2-mode)
	                      '("\\.json\\'" . js2-mode))
(add-hook 'js2-mode-hook
          (lambda ()
             (setq js2-basic-offset 2)
             (setq js-switch-indent-offset 2)))

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-hook 'web-mode-hook
	  (lambda ()
	    (setq web-mode-enable-auto-pairing nil)
	    (set-face-attribute 'web-mode-html-tag-face nil :foreground "#6699ff")))

(global-set-key "\C-ci"
  (lambda () (interactive) (indent-rigidly (region-beginning) (region-end)  2)))
(global-set-key "\C-cu"
  (lambda () (interactive) (indent-rigidly (region-beginning) (region-end) -2)))

;;; init.el ends here

(use-package rustic
  :ensure
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action)
              ("C-c C-c r" . lsp-rename)
              ("C-c C-c q" . lsp-workspace-restart)
              ("C-c C-c Q" . lsp-workspace-shutdown)
              ("C-c C-c s" . lsp-rust-analyzer-status)
              ("C-c C-c e" . lsp-rust-analyzer-expand-macro)
              ("C-c C-c d" . dap-hydra)
              ("C-c C-c h" . lsp-ui-doc-glance))
  :config
  (add-hook 'rustic-mode-hook 'rust-format-buffer))

(defun rust-format-buffer ()
  (when buffer-file-name
    (setq-local buffer-save-without-query t))
  (add-hook 'before-save-hook 'lsp-format-buffer nil t))

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (lsp-rust-analyzer-cargo-watch-command "clippy")
  (lsp-eldoc-render-all t)
  (lsp-idle-delay 0.6)
  (lsp-rust-analyzer-server-display-inlay-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-enable "skip_trivial")
  (lsp-rust-analyzer-display-chaining-hints t)
  (lsp-rust-analyzer-display-lifetime-elision-hints-use-parameter-names nil)
  (lsp-rust-analyzer-display-closure-return-type-hints t)
  (lsp-rust-analyzer-display-parameter-hints nil)
  (lsp-rust-analyzer-display-reborrow-hints nil)
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package rust-playground :ensure)
(use-package toml-mode :ensure)
(use-package exec-path-from-shell
  :ensure
  :init (exec-path-from-shell-initialize))

(when (executable-find "lldb-mi")
  (use-package dap-mode
    :ensure
    :config
    (dap-ui-mode)
    (dap-ui-controls-mode 1)

    (require 'dap-lldb)
    (require 'dap-gdb-lldb)
    (dap-gdb-lldb-setup)
    (dap-register-debug-template
     "Rust::LLDB Run Configuration"
     (list :type "lldb"
           :request "launch"
           :name "LLDB::Run"
	   :gdbpath "rust-lldb"
           ))))
