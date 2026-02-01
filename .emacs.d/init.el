;;; init.el --- Short description -*- My emacs config; -*-

;; Init, Core
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      inhibit-startup-message t
      use-dialog-box nil
      ring-bell-function 'ignore)

(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t) ;; for e.g. dired 

(setq gc-cons-threshold (* 100 1024 1024))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024)))) ;; high gc at startup lower later
(setq read-process-output-max (* 1024 1024)) ;; speed up LSP IO

;; Packages
(require 'package)
(setq package-archives
      '(("elpa"  . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

(package-initialize)
(require 'use-package)
(setq use-package-always-ensure t)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; UI
(show-paren-mode 1)

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'gruber-darker t)
(set-frame-font "Inconsolata Nerd Font Mono 15" nil t)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq scroll-step 1
      scroll-margin 8 ;;scrolloff
      scroll-conservatively 10000
      scroll-preserve-screen-position t)

(setq display-buffer-alist
      '(("\\*\\(compilation\\|Warnings\\|Help\\|Messages\\|Flycheck errors\\|xref\\|lsp\\|eldoc\\|Async\\).*\\*"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-parameters . ((no-delete-other-windows . t)))
         (window-height . 0.20))))

(require 'uniquify) ;; keep buffer names unique when many of the same name
(setq uniquify-buffer-name-style 'forward)

;; Editing
(setq-default indent-tabs-mode nil
              tab-width 4
              fill-column 80
              c-basic-offset 4)         ;; shiftwidth
;; (electric-indent-mode 1)
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)
(setq tab-always-indent t)

;; EVIL
(setq evil-want-minibuffer t)

(use-package evil
  :init
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; VIM STUFF
;; Vim search polish
(setq isearch-lazy-count t
      search-upper-case t
      isearch-case-fold-search nil)
(with-eval-after-load 'evil
  (evil-define-key 'normal 'global (kbd "gcc") #'comment-line)
  (evil-define-key 'visual 'global (kbd "gc")  #'comment-region)
                                        ; nzzv
  (setq evil-symbol-word-search t);; fix * movement
  (evil-define-key 'normal 'global
    (kbd "n")
    (lambda ()
      (interactive)
      (evil-search-next)
      (evil-scroll-line-to-center nil)
      (evil-show-jump)))
  ;; Visual paste without clobber
  (evil-define-key 'visual 'global
    (kbd "SPC p") #'evil-paste-before)
  )
(setq evil-kill-on-visual-paste nil)

;; Move visual lines J/K
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

;; Keys
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
    "c a" 'lsp-execute-code-action
    "r n" 'lsp-rename
    "f d" 'lsp-format-buffer
    "r r" 'lsp-find-references
    "g d" 'lsp-find-definition
    "g D" 'lsp-find-declaration
    "g i" 'lsp-find-implementation
    "t d" 'lsp-find-type-definition
    "t h" 'lsp-inlay-hints-mode
    "v d" 'flymake-show-buffer-diagnostics))

(use-package which-key
  :config
  (which-key-mode 1))

;; Code Actions / Refactors
(define-key evil-normal-state-map (kbd "C-c c") #'compile)
(setq compilation-read-command t)

;; Minibuffer & Narrowing
(savehist-mode 1)
(recentf-mode 1)
(save-place-mode 1)

(use-package vertico
  :init (vertico-mode 1)
  :config (setq vertico-count 6
                vertico-cycle t)
  (evil-define-key 'insert vertico-map
    (kbd "C-p") #'vertico-previous
    (kbd "C-n") #'vertico-next))

(use-package orderless
  :init
  (setq completion-styles '(orderless basic)
        completion-ignore-case t
        completion-category-overrides '((file (styles partial-completion)))
        completion-category-defaults nil))


(use-package consult
  :config
  (setq recentf-max-saved-items 200
        recentf-auto-cleanup 'never))

;; Completion
;; tab-always-indent nil
(use-package corfu
  :init
  (global-corfu-mode 1)
  :config
  (setq corfu-count 8
        corfu-auto t
        corfu-auto-prefix 2
        corfu-auto-delay 0.1
        corfu-quit-no-match t
        corfu-preview-current nil
        corfu-preselect nil  
        corfu-auto-update t))  

(with-eval-after-load 'corfu
  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode 1)
  (setq corfu-popupinfo-delay 0.0))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-symbol)
  (add-to-list 'completion-at-point-functions #'cape-elisp-symbol))

;; Company 
(use-package company
  :commands (company-manual-begin)
  :config
  (setq company-idle-delay nil
        company-minimum-prefix-length 1
        company-backends '((company-files company-dabbrev))
        company-frontends
        '(company-pseudo-tooltip-frontend
          company-echo-metadata-frontend)))

(with-eval-after-load 'evil
  (define-key evil-insert-state-map (kbd "M-/") #'company-manual-begin))

;; Snippets
(use-package yasnippet
  :config
  (yas-global-mode 1))

;; Language Infrastructure 
;; treesitter doesnt pick up go
(setq treesit-language-source-alist
      '((go "https://github.com/tree-sitter/tree-sitter-go")
        (python "https://github.com/tree-sitter/tree-sitter-python")
        (c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")))
(setq treesit-font-lock-level 4)

(add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))
(add-to-list 'major-mode-remap-alist '(lua-mode . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))

;; LSP
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook ((c-mode c++-mode go-ts-mode python-mode js-mode typescript-mode)
         . lsp-deferred)
  :init
  (setq lsp-idle-delay 0.2
        lsp-enable-snippet t
        lsp-prefer-capf t
        lsp-file-watch-threshold 2000
        lsp-headerline-breadcrumb-enable nil
        lsp-eldoc-enable-hover t
        lsp-signature-auto-activate nil
        lsp-enable-file-watchers nil))

(use-package lsp-pyright
  :after lsp-mode
  :hook (python-mode . lsp-deferred))

(setq lsp-keep-workspace-alive nil)

(setq xref-backend-functions '(lsp-xref-backend))

(setq eldoc-echo-area-use-multiline-p t)
(setq eldoc-display-functions '(eldoc-display-in-echo-area))

(defvar my/last-line -1
  "Track the last line number we showed diagnostics for.")

(defun my/flymake-show-line-diagnostics ()
  "Show all Flymake diagnostics for the current line in the echo area."
  (let ((line (line-number-at-pos)))
    (unless (= line my/last-line)
      (setq my/last-line line)
      (let* ((beg (line-beginning-position))
             (end (line-end-position))
             (diags (flymake-diagnostics beg end)))
        (when diags
          (let ((msg (string-join
                      (mapcar #'flymake-diagnostic-text diags)
                      "\n")))
            (message "%s" msg)))))))

;; Trigger after cursor movement
(add-hook 'post-command-hook #'my/flymake-show-line-diagnostics)

(add-hook 'lsp-managed-mode-hook #'flymake-mode)
(add-hook 'lsp-mode-hook #'flymake-mode)

(setq lsp-diagnostics-provider :flymake)

(with-eval-after-load 'evil
  ;; Go to next/prev diagnostic
  (evil-define-key 'normal 'global
    (kbd "]d") #'flymake-goto-next-error
    (kbd "[d") #'flymake-goto-prev-error
    (kbd "]c") #'next-error
    (kbd "[c") #'previous-error))


;; Git / VCS
(use-package magit
  :commands (magit-status)
  :defer 1
  :after evil
  :init
  (evil-collection-init))

;; Dired
(setq dired-listing-switches "-alh"
      delete-by-moving-to-trash t
      trash-directory "~/.local/share/Trash/files"
      dired-create-destination-dirs 'ask
      dired-dwim-target t)

;; Misc / Utilities
(use-package hl-todo
  :hook ((prog-mode . hl-todo-mode)
         (yaml-mode . hl-todo-mode)))

(setq hl-todo-keyword-faces
      '(("TODO"   . "OrangeRed")
        ("PERF"   . "HotPink")
        ("HACK"   . "DarkOrange")
        ("NOTE"   . "DeepSkyBlue")
        ("WARNING". "Red")
        ("FIX"    . "Gold")))

;; Local
(dolist (p '("~/go/bin" "~/opt/gf"))
  (let ((dir (expand-file-name p)))
    (when (file-directory-p dir)
      (add-to-list 'exec-path dir)
      (setenv "PATH" (concat dir path-separator (getenv "PATH"))))))

(setq backup-directory-alist `(("." . ,(expand-file-name "tmp/backups" user-emacs-directory))))
;; (use-package exec-path-from-shell
;;   :config (exec-path-from-shell-initialize))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")
