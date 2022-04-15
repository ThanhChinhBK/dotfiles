
(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips

(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar


;; change font
;(set-face-attribute 'default nil :font "Fira Code Retina" :height 280)


;; Make ESC quit prompts - not my favorite
;(global-set-key (kbd "<escape>") 'keyboard-escape-quit)


;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; swipper is a better I-search
(unless (package-installed-p 'swiper)
   (package-install 'swiper))

;; turn on ivy mode
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; ivy rich mode
(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))


(use-package ivy-rich
  :init
  (ivy-rich-mode 1))


;; icon and modeline
(use-package all-the-icons)

;; NOTE: The first time you load your configuration on a new machine, you'll
;; need to run the following command interactively so that mode line icons
;; display correctly:
;;
;; M-x all-the-icons-install-fonts


(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 2)
  :custom ((doom-Modeline-height 12)))

; (use-package doom-themes
;   :init (load-theme 'doom-gruvbox-light t))

(use-package github-theme
  :init (load-theme 'github t))

;; column number
(column-number-mode)
(global-display-line-numbers-mode t)

;; use define-key to define key for each mode
(define-key emacs-lisp-mode-map (kbd "C-x C-e") 'eval-buffer)

;; use general to simple define key bindings
;; (use-package general)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; just for fun :)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; which key and helpfull, super helpful for lisp programing -> also not my favorite
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0))


;; (use-package helpful
;;   :custom
;;   (counsel-describe-function-function #'helpful-callable)
;;   (counsel-describe-variable-function #'helpful-variable)
;;   :bind
;;   ([remap describe-function] . counsel-describe-function)
;;   ([remap describe-command] . helpful-command)
;;   ([remap describe-variable] . counsel-describe-variable)
;;   ([remap describe-key] . helpful-key))


;; project title
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where I keep my Git repos
  (when (file-directory-p "~/dev")
    (setq projectile-project-search-path '("~/dev")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))


;; magit
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))

(use-package company
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  :config
  ( setq company-minimum-prefix-length 2)
  )



(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (lsp-mode . efs/lsp-mode-setup)
  :init
  (setq lsp-keymap-prefix "C-c l")  ;; Or 'C-l', 's-l'
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

(use-package lsp-ivy)

;; for python config

(use-package dap-mode
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)

  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed

  ;; Bind `C-c l d` to `dap-hydra` for easy access
)

(use-package python-mode
  :ensure t
  :hook (python-mode . lsp-deferred)
  :custom
  ;; NOTE: Set these if Python 3 is called "python3" on your system!
  ;; (python-shell-interpreter "python3")
  ;; (dap-python-executable "python3")
  (dap-python-debugger 'debugpy)
  :config
  (require 'dap-python))

(add-to-list 'default-frame-alist '(fullscreen . maximized))




(setq tab-always-indent nil)

;; auto close brace
(electric-pair-mode 1)
(setq electric-pair-preserve-balance nil)
(defun python-electric-pair-string-delimiter ()
  (when (and electric-pair-mode
             (memq last-command-event '(?\" ?\'))
             (let ((count 0))
               (while (eq (char-before (- (point) count)) last-command-event)
                 (setq count (1+ count)))
               (= count 3)))
    (save-excursion (insert (make-string 3 last-command-event)))))

(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'post-self-insert-hook
                      #'python-electric-pair-string-delimiter 'append t)))



;; C-s C-e to show  errors
(defun show-flymake-errors ()
  (local-set-key (kbd "C-q C-e") #'flymake-show-diagnostics-buffer))
  
(add-hook 'python-mode-hook 'show-flymake-errors)
(add-hook 'c-mode-hook 'show-flymake-errors)
(add-hook 'c++-mode-hook 'show-flymake-errors)

 


;; Ret instead Yes/y
(fset 'yes-or-no-p 'y-or-n-p)  ;; Ask for y/n instead of yes/no



;; Config for C++
(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  )

;; yaml
(use-package yaml-mode)

;; kill line without copy
(defun delete-line-no-kill ()
  (interactive)
  (delete-region
   (point)
   (save-excursion (move-end-of-line 1) (point)))
 (delete-char 1)
)
(global-set-key (kbd "C-k") 'delete-line-no-kill)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(github-theme yaml-mode which-key use-package typescript-mode sml-mode sml-basis smartparens rainbow-delimiters python-mode magit lsp-ui lsp-pyright lsp-ivy ivy-rich helpful general ein doom-themes doom-modeline dap-mode counsel-projectile company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
