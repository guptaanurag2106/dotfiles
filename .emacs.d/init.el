;;;; init.el My Emacs config

;; Init, Core
(fset 'yes-or-no-p 'y-or-n-p)
(setq use-short-answers t) ;; shorter prompts: y/n instead of yes/no, saving whole of 1-2 keystrokes (approximately 10seconds a day)

;; auto-reload files changed on disk (incl. dired)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(savehist-mode 1) ;; keep command & minibuffer history
(setq history-length 100)

(save-place-mode 1) ;; remember cursor positions in files

(recentf-mode 1) ;; track recently opened files
(setq recentf-max-saved-items 200)

(winner-mode 1) ;; undo window layout changes

(require 'uniquify) ;; unique buffer names like dir/file instead of file<2>
(setq uniquify-buffer-name-style 'forward)

(setq xref-search-program 'ripgrep) ;; use ripgrep for xref searches when available

(setq vc-follow-symlinks t) ;; follow symlinks automatically

(setq create-lockfiles nil) ;; do not create lockfiles (#file)

;; backups in one directory, versioned
(setq make-backup-files t
      version-control t
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      backup-directory-alist
      `(("." . ,(expand-file-name "backup/" user-emacs-directory))))

(modify-coding-system-alist 'file "" 'utf-8) ;; default UTF-8 handling

;; browser integration
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

(setq confirm-kill-emacs 'y-or-n-p) ;; confirm before quitting, bad :q habit

(setq sentence-end-double-space nil) ;; sentence detection: single space

;;; Packages 
(require 'package)
(setq package-archives
      '(("elpa"  . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;; UI basics
(show-paren-mode 1)
(setq show-paren-delay 0.1)

;; theme + font
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes") ;; TODO: relative path
(load-theme 'gruber-darker t)
(set-frame-font "Inconsolata Nerd Font Mono 15" nil t)

;; line & column numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(column-number-mode 1)

(setq-default display-line-numbers-width 3) ;; limit cost of width calculation

(setq-default fill-column 80) ;; fill column indicator for code
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(global-hl-line-mode -1) ;; disable current-line highlight

(setq-default truncate-lines t) ;; truncate long lines by default

;;; Scrolling behaviour
(setq scroll-margin 8
      scroll-conservatively 101
      scroll-preserve-screen-position t)

(setq mouse-wheel-follow-mouse t
      mouse-wheel-progressive-speed nil
      mouse-wheel-scroll-amount '(1 ((shift) . 3) ((control) . 6)))

(pixel-scroll-precision-mode 1)

;;; Editing defaults
(setq-default indent-tabs-mode nil
      tab-width 4)

(file-name-shadow-mode 1)

;;; Buffer placement rules
(setq display-buffer-alist
      '(("\\*\\(compilation\\|Warnings\\|Help\\|Messages\\|xref\\|eldoc\\).*\\*"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-height . 0.20))))

;;; Dired tweaks
(setq delete-by-moving-to-trash t) ;; use trash instead of deleting permanently
(setq dired-listing-switches "-alh"
      dired-create-destination-dirs 'ask
      dired-dwim-target t
      trash-directory "~/.local/share/Trash/files")

;;; Local PATH additions
(dolist (p '("~/go/bin" "~/opt/gf" "~/.local/bin/"))
  (let ((dir (expand-file-name p)))
    (when (file-directory-p dir)
      (add-to-list 'exec-path dir)
      (setenv "PATH"
              (concat dir path-separator (getenv "PATH"))))))

;;; Optional compatibility
(cua-mode) ;; enables CUA copy/paste keys while keeping Emacs behavior

;;; Evil
;; must be set BEFORE evil loads
(setq evil-want-keybinding nil      ; required for evil-collection
      evil-want-symbol-word t       ; treat symbols as words
      evil-want-minibuffer t        ; enable evil in minibuffer
      evil-kill-on-visual-paste nil)

(use-package evil
     :init
     :config
     (evil-mode 1))

(use-package evil-collection
     :after evil
     :config
     (evil-collection-init))

;; Search behaviour
(setq isearch-lazy-count t
      search-upper-case t
      isearch-case-fold-search nil)

;; Common key tweaks
(with-eval-after-load 'evil
      ;; gcc / gc comments using built-in functions
      (evil-define-key 'normal 'global (kbd "gcc") #'comment-line)
      (evil-define-key 'visual 'global (kbd "gc")  #'comment-region)

      ;; center after search like vim nzzv
      (evil-define-key 'normal 'global
            (kbd "n")
            (lambda ()
              (interactive)
              (evil-search-next)
              (evil-scroll-line-to-center nil)
              (evil-show-jump)))

      ;; visual paste without replacing register
      (evil-define-key 'visual 'global
            (kbd "SPC p") #'evil-paste-before)

      ;; diagnostics navigation
      (evil-define-key 'normal 'global
            (kbd "]d") #'flymake-goto-next-error
            (kbd "[d") #'flymake-goto-prev-error
            (kbd "]c") #'next-error
            (kbd "[c") #'previous-error))

;; Move selected lines
(defun evil-move-visual-lines (direction)
       (let* ((beg (save-excursion
                         (goto-char (region-beginning))
                         (line-beginning-position)))
              (end (save-excursion
                         (goto-char (region-end))
                         (if (bolp)
                             (line-beginning-position)
                           (line-end-position))))
              (text (delete-and-extract-region beg end)))
         (forward-line direction)
         (let ((new-beg (point)))
           (insert text)
           (evil-visual-select new-beg (point) 'line))))

(defun evil-move-visual-down ()
       (interactive)
       (evil-move-visual-lines 1))

(defun evil-move-visual-up ()
       (interactive)
       (evil-move-visual-lines -1))

(define-key evil-visual-state-map (kbd "J") #'evil-move-visual-down)
(define-key evil-visual-state-map (kbd "K") #'evil-move-visual-up)

;; Syntax tweaks
(defun my/prog-syntax-setup ()
       ;; treat _ as part of words in code
       (modify-syntax-entry ?_ "w")
       (modify-syntax-entry ?- "."))

(add-hook 'prog-mode-hook #'my/prog-syntax-setup)

;; Leader key
(use-package general
     :after evil
     :config
     (general-create-definer my/leader
              :states '(normal visual)
              :keymaps 'override
              :prefix "SPC")

     (my/leader
       "SPC" 'recentf
       "s f" 'find-file
       "-"   'dired
       "b b" 'consult-buffer
       "b d" 'kill-current-buffer
       "g s" 'magit-status
       "g g" 'magit-dispatch
       "r n" 'eglot-rename
       "c a" 'eglot-code-actions
       "f d" 'eglot-format
       "t h" 'eglot-inlay-hints-mode
       "g d" 'xref-find-definitions
       "g D" 'eglot-find-declaration
       "g i" 'eglot-find-implementation
       "t d" 'eglot-find-typeDefinition
       "r r" 'xref-find-references
       "v d" 'flymake-show-buffer-diagnostics))


;; Which key
(use-package which-key
     :defer 1
     :config
     (which-key-mode 1))

;; Compilation
(define-key evil-normal-state-map (kbd "C-c c") #'compile)
(setq compilation-read-command t)

;; Vim style number inc/dec
(use-package evil-numbers
     :commands (evil-numbers/inc-at-pt evil-numbers/dec-at-pt))

;;; Minibuffer completion
(use-package vertico
     :init
     (vertico-mode 1)
     :custom
     (vertico-count 8)
     (vertico-cycle t)
     :config
     ;; vim-like navigation
     (evil-define-key 'insert vertico-map
           (kbd "C-n") #'vertico-next
           (kbd "C-p") #'vertico-previous))

(use-package orderless
     :init
     (setq completion-styles '(orderless basic)
           completion-category-defaults nil
           completion-category-overrides
           '((file (styles partial-completion)))
           completion-ignore-case t))

(defun my/dired-disable-completion ()
       (setq-local completion-styles '(basic)))
(add-hook 'minibuffer-setup-hook
     (lambda ()
       (when (eq this-command 'dired-do-rename)
         (my/dired-disable-completion)))) ;; regex matching in completion so say rename key_bin to key.bin doesn't work as key.bin just matches key_bin and you rename same file

(use-package consult
     :after vertico
     :config
     ;; consult used for xref results
     (setq xref-show-xrefs-function #'consult-xref
           xref-show-definitions-function #'consult-xref))

;;; In-buffer completion
(use-package corfu
     :init
     (add-hook 'prog-mode-hook #'corfu-mode)
     :custom
     (corfu-auto t)
     (corfu-auto-prefix 2)
     (corfu-auto-delay 0.1)
     (corfu-preview-current nil)
     (corfu-preselect nil)
     (completion-cycle-threshold 3)
     :config
     ;; TAB completes
     (define-key corfu-map (kbd "TAB") #'corfu-complete)

     ;; RET should insert newline, not complete
     (define-key corfu-map (kbd "RET") #'corfu-quit)

     ;; ESC closes only popup
     (define-key corfu-map (kbd "<escape>") #'corfu-quit)

     ;; manual completion trigger
     (global-set-key (kbd "C-<tab>") #'completion-at-point))

;;; documentation popup
(with-eval-after-load 'corfu
      (require 'corfu-popupinfo)
      (corfu-popupinfo-mode 1)
      (setq corfu-popupinfo-delay 0.3))

;;; Extra completion sources
(use-package cape
     :init
     ;; make eglot completion composable
     (advice-add 'eglot-completion-at-point
             :around #'cape-wrap-buster)

     ;; fallback sources
     (add-to-list 'completion-at-point-functions #'cape-file)
     (add-to-list 'completion-at-point-functions #'cape-dabbrev)
     (add-to-list 'completion-at-point-functions #'cape-keyword))

;;; Snippets
(use-package yasnippet
     :hook (prog-mode . yas-minor-mode))

;;; Tree-sitter
(setq treesit-language-source-alist
      '((go "https://github.com/tree-sitter/tree-sitter-go")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))

(setq treesit-font-lock-level 4)

(add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))
(add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
(add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
(add-to-list 'major-mode-remap-alist '(lua-mode . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))

;;; Eglot (LSP client)
(use-package eglot
     :ensure nil
     :hook
     ((c-ts-mode
         c++-ts-mode
         go-ts-mode
         python-mode)
      . eglot-ensure)
     :custom
     (eglot-autoshutdown t)         ;; kill servers when last buffer closes
     (eglot-events-buffer-size 0)   ;; disable noisy event buffer
     (eglot-confirm-server-initiated-edits nil)
     (eglot-extend-to-xref t) ;; reuse servers when jump to definition in library
     :config

     ;; clangd configuration
     (add-to-list 'eglot-server-programs
          '((c-ts-mode c++-ts-mode)
            . ("clangd"
               "--background-index"
               "--clang-tidy"
               "--completion-style=detailed"
               "--all-scopes-completion"
               "--header-insertion=iwyu")))
     (add-to-list 'eglot-server-programs
          '(python-mode . ("basedpyright-langserver" "--stdio")))

     ;; gopls hints
     (setq-default eglot-workspace-configuration
           '(:gopls (:hints (:parameterNames t)))))

(add-hook 'eglot-managed-mode-hook
     (lambda ()
       (eglot-inlay-hints-mode -1)))

(add-hook 'kill-buffer-hook
     (lambda ()
       (when (and (bound-and-true-p eglot-managed-mode)
                  (not (eglot-current-server)))
         (ignore-errors (eglot-shutdown)))))

;;; Flymake diagnostics
(use-package flymake
     :ensure nil
     :hook (eglot-managed-mode . flymake-mode)
     :custom
     (flymake-show-diagnostics-at-end-of-line nil) ;; no inline text
     (flymake-indicator-type 'margins)
     :bind (:map flymake-mode-map
                 ("M-n" . flymake-goto-next-error)
                 ("M-p" . flymake-goto-prev-error)
                 ("C-c ! l" . flymake-show-buffer-diagnostics)))
(use-package eldoc
     :ensure nil
     :custom
     (eldoc-echo-area-use-multiline-p nil)
     (eldoc-documentation-strategy
            'eldoc-documentation-compose)
     :init
     (global-eldoc-mode))

;; Optional popup documentation
;; (use-package eldoc-box
;;   :hook (eglot-managed-mode . eldoc-box-hover-mode))

;;; Magit
(use-package magit
     :commands (magit-status magit-dispatch)
     :custom
     (magit-display-buffer-function
            #'magit-display-buffer-same-window-except-diff-v1))

;; optional: show changes in fringe like vim git signs
;; (use-package diff-hl
;;      :hook ((prog-mode . diff-hl-mode)
;;             (dired-mode . diff-hl-dired-mode)
;;             (magit-post-refresh . diff-hl-magit-post-refresh)))

;; Misc / Utilities
(use-package hl-todo
     :hook ((prog-mode . hl-todo-mode)
            (yaml-mode . hl-todo-mode)
            (emacs-lisp-mode . hl-todo-mode)))

(setq hl-todo-keyword-faces
      '(("TODO"   . "OrangeRed")
        ("PERF"   . "HotPink")
        ("HACK"   . "DarkOrange")
        ("NOTE"   . "DeepSkyBlue")
        ("WARNING". "Red")
        ("FIX"    . "Gold")))

;; FIX:
;; completion not perfect doesnt show all symbols
;; enter in c-mode (atleast) gives two space after you write the line it indents properly (electric indent?)
;; J to join line moves cursor (is it better worse? does it matter?)
;; File and word completion works only in non-prog mode, cant even trigger it manually in say printf
;; go mode just keeps starting servers for each file, and then servers just keep running after closing with 0 resource usage
;; evil-numbers doesnt work
;; python just starts ruff not basedpyright

;; NOTE: i think fixed
;; lsp server not stopping after all buffers closed
