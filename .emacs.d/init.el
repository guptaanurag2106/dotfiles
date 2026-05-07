;;; init.el --- Init  -*- lexical-binding: t; -*-

;; Init, Core
(setq use-short-answers t) ;; shorter prompts: y/n instead of yes/no, saving whole of 1-2 keystrokes (approximately 10seconds a day)
;;(setq confirm-kill-emacs 'y-or-n-p) ;; confirm before quitting, bad :q habit

;; (add-hook 'after-save-hook #'executable-make-buffer-file-executable-if-script-p)
;; auto-reload files changed on disk (incl. dired)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(savehist-mode 1) ;; keep command & minibuffer history
(setq history-length 100)

(save-place-mode 1) ;; remember cursor positions in files

(recentf-mode 1) ;; track recently opened files
(setq recentf-max-saved-items 50
      recentf-max-menu-items 15
      recentf-auto-cleanup 'mode)

(setq
 calendar-date-style 'european
 calendar-week-start-day 1)

(require 'uniquify) ;; unique buffer names like dir/file instead of file<2>
(setq uniquify-buffer-name-style 'forward)

(setq vc-follow-symlinks t) ;; follow symlinks automatically

(setq create-lockfiles nil) ;; do not create lockfiles (#file)

(setq native-comp-async-query-on-exit t) ;; ask to terminate async comps on exit

(setq read-process-output-max (* 1024 1024)) ;; improve LSP/process throughput

(setq enable-recursive-minibuffers t) ; Allow nested minibuffers

(setq custom-buffer-done-kill t)

(setq eval-expression-print-length nil
      eval-expression-print-level nil) ;; Disable truncation of printed s-expressions in the message buffer

;; Set backup and autosave options
(make-directory (expand-file-name "autosave/" user-emacs-directory) t)
(setq make-backup-files nil
      version-control t
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      auto-save-file-name-transforms
      `((".*" ,(expand-file-name "autosave/" user-emacs-directory) t))
      backup-directory-alist
      `(("." . ,(expand-file-name "backup/" user-emacs-directory))))

;; browser integration
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")

(setq sentence-end-double-space nil) ;; sentence detection: single space

;; (setq native-comp-async-report-warnings-errors 'silent
;;       translate-upper-case-key-bindings nil
;;       tags-revert-without-query t
;;       tags-add-tables t
;;       undo-auto-current-boundary-timer t
;;       long-line-threshold nil
;;       dabbrev-upcase-means-case-search t
;;       dabbrev-case-replace nil
;;       dabbrev-case-distinction nil)

;;; Packages 
(require 'package)
(setq package-archives
      '(("elpa"  . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")))

;(setq package-quickstart t)

(unless package--initialized
  (package-initialize))

(require 'use-package)

;;; UI basics
(show-paren-mode 1)
(setq show-paren-delay 0.0)
;;(electric-pair-mode) ; Autopairing
(add-hook 'minibuffer-setup-hook (lambda () (electric-pair-local-mode 0))) ;; Inhibit autopairing in minibuffers

;; theme + font
(add-to-list 'custom-theme-load-path
     (expand-file-name "themes" user-emacs-directory))
(use-package doom-themes)
(load-theme 'doom-dark+ t)
;; (setq frame-background-mode 'dark)
(custom-set-faces
 '(default ((t (:background "#101010")))))
(add-hook 'after-load-theme-hook
          (lambda ()
            (set-face-attribute 'default nil :background "#101010")))
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
(setq lazy-highlight-initial-delay 0
      isearch-lazy-highlight-initial-delay 0)
;; (setq mouse-wheel-follow-mouse t
;;       mouse-wheel-progressive-speed nil
;;       mouse-wheel-scroll-amount '(1 ((shift) . 3) ((control) . 6)))

(pixel-scroll-precision-mode 1)

;;; Editing defaults
(setq-default indent-tabs-mode nil
      tab-width 4)

(file-name-shadow-mode 1)

;;; Buffer placement rules
(setq display-buffer-alist
      '(("\\*\\(compilation\\|Warnings\\|Help\\|Messages\\|xref\\|eldoc\\|Apropos\\)\\*"
         (display-buffer-reuse-window display-buffer-at-bottom)
         (window-height . 0.25))))

;;; Dired tweaks
(setq delete-by-moving-to-trash t) ;; use trash instead of deleting permanently
(setq dired-listing-switches "-alhtv"
      dired-create-destination-dirs 'ask
      dired-dwim-target t
      trash-directory "~/.local/share/Trash/files"
      wdired-allow-to-change-permissions t)
(put 'dired-find-alternate-file 'disabled nil)
(with-eval-after-load 'dired
      (define-key dired-mode-map (kbd "RET") #'dired-find-alternate-file))

;;; Evil
;; (setq evil-search-module 'isearch) ;; use emacs' built-in search functionality.
;; must be set BEFORE evil loads
(setq evil-want-keybinding nil      ; required for evil-collection
      evil-want-symbol-word t       ; treat symbols as words
      evil-want-minibuffer t        ; enable evil in minibuffer
      evil-want-integration t
      evil-want-C-u-scroll t
      evil-want-C-u-delete t
      evil-symbol-word-search t
      evil-ex-visual-char-range t
      evil-kill-on-visual-paste nil
      evil-undo-system 'undo-redo
      evil-ex-complete-emacs-commands t ; TODO: check
      evil-search-module 'evil-search)

;; Candidate evil settings (from compare), kept commented for now:
;; (setq evil-start-of-line t
;;       evil-toggle-key ""
;;       evil-insert-state-modes '(comint-mode)
;;       evil-motion-state-modes ()
;;       evil-emacs-state-modes '(debugger-mode))
;; (defun reset-curswant (&rest _)
;;   (when (eq temporary-goal-column most-positive-fixnum)
;;     (setq temporary-goal-column 0)))
;; (advice-add #'evil-next-visual-line :before #'reset-curswant)
;; (advice-add #'evil-previous-visual-line :before #'reset-curswant)

(use-package evil
     :init
     (evil-mode 1))

(use-package evil-collection
     :after evil
     :config
     (evil-collection-init))

;; Vim style number inc/dec
(use-package evil-numbers
     :after evil
     :commands (evil-numbers/inc-at-pt
                     evil-numbers/dec-at-pt))

;; Search behaviour
(setq isearch-lazy-count t
      search-upper-case t
      isearch-case-fold-search nil)

;; visual * searches selected text
(define-advice evil-ex-start-word-search
        (:around (oldfun unbounded direction count &optional symbol))
        (if (or (not (evil-visual-state-p)) unbounded)
            (funcall oldfun unbounded direction count symbol)
          (setq deactivate-mark t)
          (cl-letf (((symbol-function #'evil-find-thing)
                     (lambda (&rest _)
                       (buffer-substring-no-properties
                               (goto-char evil-visual-beginning) evil-visual-end))))
              (funcall oldfun t direction count))))


;; Remove highlight, keyboard-quit (reuse C-g)
(defun my/evil-double-escape-nohl ()
       (interactive)
       (evil-ex-nohighlight)
       (keyboard-quit))

(define-key evil-normal-state-map (kbd "C-g")
        #'my/evil-double-escape-nohl)

;; Move selected lines
(defun my/evil-move-visual-lines (direction)
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

(defun my/evil-move-visual-down ()
       (interactive)
       (my/evil-move-visual-lines 1))

(defun my/evil-move-visual-up ()
       (interactive)
       (my/evil-move-visual-lines -1))

(defun my/split-vertical ()
       (interactive)
       (split-window-vertically)
       (other-window 1))

(defun my/split-horizontal ()
       (interactive)
       (split-window-horizontally)
       (other-window 1))

;; Common key tweaks
(with-eval-after-load 'evil
      ;; gcc / gc comments using built-in functions
      (evil-define-key 'normal 'global (kbd "gcc") #'comment-line)
      (evil-define-key 'visual 'global (kbd "gc") #'comment-or-uncomment-region)
      (evil-define-key 'normal 'global (kbd "g+") #'evil-numbers/inc-at-pt)
      (evil-define-key 'normal 'global (kbd "g-") #'evil-numbers/dec-at-pt)


      ;; center after search like vim nzzzv
      (advice-add 'evil-ex-search-next :after
              (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))
      (advice-add 'evil-ex-search-previous :after
              (lambda (&rest x) (evil-scroll-line-to-center (line-number-at-pos))))
      
      ;; visual paste without replacing register
      (evil-define-key 'visual 'global
            (kbd "SPC p") #'evil-paste-before)

      ;; diagnostics navigation
      (evil-define-key 'normal 'global
            (kbd "]d") #'flymake-goto-next-error
            (kbd "[d") #'flymake-goto-prev-error
            (kbd "]q") #'next-error
            (kbd "[q") #'previous-error)


      (define-key evil-normal-state-map (kbd "C-w s") #'my/split-vertical)
      (define-key evil-normal-state-map (kbd "C-w v") #'my/split-horizontal)
      (define-key evil-visual-state-map (kbd "J") #'my/evil-move-visual-down)
      (define-key evil-visual-state-map (kbd "K") #'my/evil-move-visual-up)
      (define-key evil-normal-state-map (kbd "C-c c") #'compile)
      (define-key evil-normal-state-map (kbd "C-c r") #'recompile)
      (define-key evil-normal-state-map (kbd "-") #'dired-jump))

;; comment-aware join line for evil J
(defun my/comment-join-line (beg end)
       (comment-normalize-vars t)
       (let ((prefix (when fill-prefix (regexp-quote fill-prefix)))
             (erei (comment-padleft
                            (comment-string-reverse (or comment-continue comment-start)) 're))
             next-linec-pt)
         (save-restriction
               (narrow-to-region
                       (progn (goto-char beg) (or (comment-beginning) beg))
                       (progn (goto-char (max (1- end) beg))
                              (end-of-line (when (<= (pos-bol) beg) 2)) (point)))
               (insert ?\n)
               (goto-char (point-min))
               (while-let ((spt (comment-search-forward (point-max) t)))
                      (let ((npt (pos-bol 2)) (iept (point-max)))
                        (if (when (progn (goto-char spt) (comment-forward))
                              (setq iept (save-excursion (comment-enter-backward) (point)))
                              (= (point) npt))
                            (progn
                              (when (eql spt next-linec-pt) (uncomment-region spt (point)))
                              (setq next-linec-pt (progn (skip-chars-forward " \t") (point))))
                          (save-excursion
                                (goto-char (max beg spt))
                                (while (progn (forward-line) (< (point) iept))
                                  (when (looking-at erei)
                                    (setq iept (- iept (- (match-end 0) (match-beginning 0))))
                                    (replace-match "" t t)))))))
               (goto-char beg)
               (setq end nil)
               (while (progn (forward-line) (not (eobp)))
                 (delete-region
                         (setq end (1- (point)))
                         (progn (and prefix (looking-at prefix) (goto-char (match-end 0)))
                                (skip-chars-forward " \t") (point)))
                 (or (memq (following-char) '(0 ?\n ?\)))
                     (memq (preceding-char) '(0 ?\n ?\t ?\s))
                     (insert ?\s))))
         (delete-char -1)
         (goto-char (or end (signal 'end-of-buffer nil)))))

(advice-add #'evil-join :override #'my/comment-join-line)

;; Syntax tweaks
(defun my/prog-syntax-setup ()
       ;; treat _ as part of words in code
       (modify-syntax-entry ?_ "w")
       (modify-syntax-entry ?- "."))

(add-hook 'prog-mode-hook #'my/prog-syntax-setup)

(require 'project)

(defun my/format-buffer () ;; run ruff for python files as basedpyright doesn't support formatting
       (interactive)
       (cond
        ((eq major-mode 'python-mode)
         (when buffer-file-name
               (save-buffer)
               (call-process "ruff" nil "*ruff*" nil
                     "format" buffer-file-name)
               (revert-buffer t t t)))
        ((eglot-current-server)
         (eglot-format))))

;; Leader key
(use-package general
     :after evil
     :config
     (general-create-definer my/leader
              :states '(normal visual)
              :keymaps 'override
              :prefix "SPC")

      (my/leader
        "p" project-prefix-map
        "SPC" 'recentf
        "s f" 'find-file
        "b b" 'consult-buffer
        "b d" 'kill-current-buffer
        "g s" 'magit-status
        "g g" 'magit-dispatch
        "g D" 'eglot-find-declaration
        "g i" 'eglot-find-implementation
        "g r" 'xref-find-references
        "r n" 'eglot-rename
        "c a" 'eglot-code-actions
        "f d" #'my/format-buffer
        "t h" 'eglot-inlay-hints-mode
        "t d" 'eglot-find-typeDefinition
        "x q" 'flymake-show-buffer-diagnostics
        "v d" 'my/show-line-diagnostics))
      ;; evil-collection already binds gd/gr to xref-find-definitions/references
      ;; (and gd to xref-find-definitions)

(use-package which-key
     :defer 1
     :init
     (which-key-mode 1))

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
            completion-ignore-case t
            orderless-smart-case nil
            read-buffer-completion-ignore-case t
            read-file-name-completion-ignore-case t))

(use-package marginalia
     :init
     (marginalia-mode 1))

;; can use M-Ret in vertico to accept input as is
;; (add-hook 'minibuffer-setup-hook
;;       (lambda ()
;;         (when (memq this-command '(dired-do-rename
;;                                    dired-create-directory
;;                                    dired-create-empty-file))
;;           (my/dired-disable-completion)))) ;; regex matching in completion so say rename key_bin to key.bin doesn't work as key.bin just matches key_bin and you rename same file

(use-package consult
     :after vertico
     :config
     ;; consult used for xref results
     (setq xref-show-xrefs-function #'consult-xref
           xref-show-definitions-function #'consult-xref))

(use-package consult-dir
     :after (consult vertico)
     :bind
     (("C-x C-d" . consult-dir)
      :map vertico-map
      ("C-x C-d" . consult-dir)))

;;; Xref fallback
(setq xref-search-program 'ripgrep) ;; use ripgrep for xref searches when available
(define-advice etags--xref-backend (:before-while ())
        (or tags-table-list tags-file-name))

(use-package dumb-jump
  :custom
  (dumb-jump-prefer-searcher 'rg)
  (xref-show-definitions-function #'consult-xref)
  :config
  (add-hook 'xref-backend-functions #'dumb-jump-xref-activate))

;; grep using ripgrep defaults
(setq grep-save-buffers nil)
(with-eval-after-load 'grep
      (when (executable-find "rg")
        (grep-compute-defaults)
        (setcdr (assq 'localhost grep-host-defaults-alist)
                '((grep-command "rg --no-heading -nH ")
                  (grep-use-null-device nil)
                  (grep-highlight-matches t)))))
(evil-ex-define-cmd "gr[ep]" #'grep)

;;; In-buffer completion
(use-package corfu
     :custom
     (corfu-quit-at-boundary t)
     (corfu-quit-no-match t)
     (corfu-auto t)
     (corfu-auto-prefix 2)
     (corfu-auto-delay 0.05)
     (corfu-preview-current nil)
     (corfu-preselect nil)
     (completion-cycle-threshold 3)
     :config
     (global-corfu-mode 1)
     (corfu-history-mode 1)
     ;; TAB completes
     (define-key corfu-map (kbd "TAB") #'corfu-complete)

    ;; RET should insert newline, not complete
    (define-key corfu-map (kbd "RET") #'corfu-quit)

    ;; ESC closes only popup
    (define-key corfu-map (kbd "<escape>") #'corfu-quit)

     ;; manual completion trigger
    (global-set-key (kbd "C-<tab>") #'completion-at-point))

(add-to-list 'savehist-additional-variables 'corfu-history)

;;; documentation popup
(with-eval-after-load 'corfu
      (require 'corfu-popupinfo)
      (corfu-popupinfo-mode 1)
      (setq corfu-popupinfo-delay 0.2))

;;; Extra completion sources
(use-package cape
     :init
     ;; global fallback completion (keep file CAPF separate so path
     ;; boundaries are preserved during insertion)
     (add-hook 'completion-at-point-functions #'cape-file t)
     (add-hook 'completion-at-point-functions #'cape-dabbrev t))

;;; Snippets
(use-package yasnippet
     :config
     (yas-global-mode 1))
(use-package yasnippet-snippets)

(defun my/yasnippet-capf ()
       (when (and (bound-and-true-p yas-minor-mode)
                  (not (bound-and-true-p yas--active-field-overlay)))
         (when-let ((bounds (bounds-of-thing-at-point 'symbol)))
           (list (car bounds)
                 (cdr bounds)
                 (completion-table-dynamic (lambda (_) (yas-active-keys)))
                 :exclusive 'no
                 :annotation-function (lambda (_) " Snippet")
                 :company-kind (lambda (_) 'snippet)
                 :exit-function
                 (lambda (_candidate status)
                   (when (memq status '(finished sole exact))
                     (yas-expand)))))))

(add-hook 'completion-at-point-functions #'my/yasnippet-capf t)

(defun my/eglot-capf ()
       (funcall (cape-capf-buster #'eglot-completion-at-point)))

(defun my/eglot-capf-setup ()
       (setq-local completion-at-point-functions
             (list #'my/eglot-capf
                   #'my/yasnippet-capf
                   #'cape-file
                   #'cape-dabbrev)))

(add-hook 'eglot-managed-mode-hook #'my/eglot-capf-setup)

;;; Tree-sitter
(setq treesit-language-source-alist
      '((c "https://github.com/tree-sitter/tree-sitter-c")
        (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
        (go "https://github.com/tree-sitter/tree-sitter-go")
        (python "https://github.com/tree-sitter/tree-sitter-python")))

(when (treesit-available-p)
  (add-to-list 'major-mode-remap-alist '(go-mode . go-ts-mode))
  (add-to-list 'major-mode-remap-alist '(python-mode . python-ts-mode))
  ;;   (add-to-list 'major-mode-remap-alist '(c-mode . c-ts-mode))
  ;;   (add-to-list 'major-mode-remap-alist '(c++-mode . c++-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.go\\'" . go-ts-mode))
  (add-to-list 'auto-mode-alist '("\\.py\\'" . python-ts-mode)))

(add-hook 'c-mode-hook  ;; c-ts-mode not working rightnow
     (lambda ()
       (setq c-ts-mode-indent-offset 4
             c-basic-offset 4
             c-ts-mode-indent-style 'k&r)))

(add-hook 'c-ts-mode-hook
     (lambda ()
       (setq c-ts-mode-indent-offset 4
             c-basic-offset 4
             c-ts-mode-indent-style 'k&r)))

(add-hook 'go-ts-mode-hook
     (lambda ()
       (setq-local tab-width 4)
       (setq-local go-ts-mode-indent-offset 4)
       (setq-local indent-tabs-mode t)))

(setq treesit-font-lock-level 2)

;;; Eglot (LSP client)
(use-package eglot
     :ensure nil
     :hook
     ((c-ts-mode . eglot-ensure)
      (c-mode . eglot-ensure)
      (c++-mode . eglot-ensure)
      (c++-ts-mode . eglot-ensure)
      (go-ts-mode . eglot-ensure)
      (go-mode . eglot-ensure)
      (python-mode . eglot-ensure)
      (python-ts-mode . eglot-ensure))
     :custom
     (eglot-autoshutdown t)         ;; kill servers when last buffer closes
     (eglot-sync-connect nil)
     (eglot-events-buffer-size 0)   ;; disable noisy event buffer
     (eglot-confirm-server-initiated-edits nil)
     (eglot-send-changes-idle-time 0.1)
     (eglot-extend-to-xref t) ;; reuse servers when jump to definition in library

     :config
     ;; clangd configuration
     (add-to-list 'eglot-server-programs
          '((c-ts-mode c++-ts-mode)
            . ("clangd"
               "--background-index"
               "--clang-tidy"
               "--completion-style=detailed"
               "--pch-storage=memory"
               "--all-scopes-completion"
               "--header-insertion=iwyu"
               "--suggest-missing-includes")))
     (add-to-list 'eglot-server-programs
           '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio")))

     (setq-default eglot-workspace-configuration
           `(:clangd (:clangdFileStatus t
                       :usePlaceholders t
                       :completeUnimported t)
              :gopls (:staticcheck t
                       :analyses (:unusedparams t
                                   :unusedwrite t
                                   :nilness t
                                   :shadow t
                                   :printf t)
                       :hints (:assignVariableTypes t
                               :parameterNames t
                               :rangeVariableTypes t
                               :constantValues t)
                       :codelenses (:generate t
                                   :test t
                                   :tidy t)
                       :gofumpt t
                       :semanticTokens t
                       :usePlaceholders t
                       :directoryFilters ["-.git" "-.vscode" "-.idea" "-.vscode-test" "-node_modules"]
                       :completeUnimported t)
              :python (:analysis (:typeCheckingMode "basic"
                                  :diagnosticMode "openFilesOnly"
                                  :autoSearchPaths ,json-false
                                  :useLibraryCodeForTypes ,json-false
                                  :autoImportCompletions t
                                  :reportMissingTypeStubs ,json-false
                                  :reportUnknownMemberType ,json-false
                                  :reportUnknownVariableType ,json-false
                                  :exclude ["**/.git"
                                            "**/__pycache__"
                                            "**/.mypy_cache"
                                            "**/.pytest_cache"
                                            "**/.ruff_cache"
                                            "**/venv"
                                            "**/.venv"])))))

(add-hook 'eglot-managed-mode-hook
     (lambda ()
       (eglot-inlay-hints-mode -1))) ; disable inlay hints by default
                                        ; signature help in insert mode

;;; Flymake diagnostics
(use-package flymake
     :ensure nil
     :hook (eglot-managed-mode . flymake-mode)
     :custom
     (flymake-show-diagnostics-at-end-of-line nil) ;; no inline text
     (flymake-indicator-type 'margins))

(defun my/show-line-diagnostics ()
       "Show flymake diagnostics for current line in echo area."
       (interactive)
       (let* ((diag (flymake-diagnostics (point) (point))))
         (if diag
             (message "%s" (string-join (mapcar #'flymake-diagnostic-text diag) " | "))
           (message "No diagnostics on this line"))))

(use-package eldoc
     :ensure nil
     :config
     (global-eldoc-mode 1)
     :custom
     (eldoc-echo-area-use-multiline-p t)
     (eldoc-documentation-strategy
            'eldoc-documentation-compose)
     (eldoc-display-functions
            '(eldoc-display-in-buffer)))

(use-package eldoc-box
     :after eglot
     :custom
     (eldoc-box-clear-with-C-g t))

(defun my/eldoc-box-hover ()
       (interactive)
       (eldoc)
       (run-with-idle-timer
            0.05 nil #'eldoc-box-help-at-point)) ;; refresh contents

(add-hook 'eglot-managed-mode-hook
     (lambda ()
       (evil-local-set-key
             'normal (kbd "K")
             #'my/eldoc-box-hover)
       (evil-local-set-key
             'normal (kbd "M-n")
             'eldoc-box-scroll-up)
       (evil-local-set-key
             'normal (kbd "M-p")
             'eldoc-box-scroll-down)))


;;; Magit
(use-package magit
     :commands (magit-status magit-dispatch)
     :custom
     (magit-display-buffer-function
            #'magit-display-buffer-same-window-except-diff-v1))

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

(use-package magit-todos
  :after magit
  :config (magit-todos-mode 1))

     
(use-package markdown-mode)
(use-package grip-mode) ;; install grip/go-grip on system as well

(use-package pdf-tools
     :mode ("\\.pdf\\'" . pdf-view-mode)
     :config
     (pdf-tools-install)               ;; builds and enables
     (setq-default pdf-view-display-size 'fit-page)
     ;; faster continuous scroll
     (setq pdf-view-continuous t
           pdf-view-resize-factor 1.1)
     ;; automatically revert when file changes
     (add-hook 'pdf-view-mode-hook (lambda () (display-line-numbers-mode -1)))
     (add-hook 'pdf-view-mode-hook 'auto-revert-mode))

(add-hook 'emacs-startup-hook
     (lambda ()
       (setq gc-cons-threshold (* 100 1024 1024)
             gc-cons-percentage 0.1)))

(use-package vterm
     :config
     (add-hook 'vterm-mode-hook (lambda () (display-line-numbers-mode -1))))

(setq eshell-history-file-name "~/.zsh_history")

;; Extras
(add-to-list 'load-path "~/.emacs.d/extra")
(load "~/.emacs.d/extra/llvm-mode.el")

;;; Local PATH additions
(dolist (p '("~/go/bin" "~/opt/gf" "~/.local/bin/"))
  (let ((dir (expand-file-name p)))
    (when (and (file-directory-p dir)
               (not (member dir exec-path)))
      (add-to-list 'exec-path dir)
      (setenv "PATH"
              (concat dir path-separator (getenv "PATH"))))))

;; Tramp
(setq tramp-verbose 1)
(setq tramp-completion-reread-directory-timeout 50)
(setq tramp-backup-directory-alist backup-directory-alist)

;; make a TRAMP sudo filename for FILE
(defun my/sudo-file-name (file)
       (concat
        (if-let (remote-id (copy-sequence (file-remote-p file)))
          (progn (aset remote-id (1- (length remote-id)) ?|)
                 remote-id)
         "/")
        "sudo::" (or (file-remote-p file 'localname) file)))

;; e.g. (find-file (my/sudo-file-name buffer-file-name))

;; FIX:
;; read-process-output-max
;; evil-ex-substitute-case 'sensitive do i need this
;; devdocs package devdocs.io
;; undo tree
;; completion does not insert () on function completion (needs LSP snippets)
;; G scrolls to 1 line after the end
;; Mouse scrolling jumps a lot when scrolling too fast, sometimes jumps and doesnt actually scroll
;; on opening man pages they dont come to focus
;; Exit minibuffer when in normal mode not working, can only exit in insert mode
;; Sticky scroll (see function, if, loop context)
;; evil search show how many, same for visual mode show how many lines/columns selected

;; NOTE: i think fixed
;; n too nzzzv
;; J to join lines aware of comments? remove the ;;; when joining 2 comment line
;; enter in c-mode (atleast) gives two space after you write the line it indents properly (electric indent?)
;; completion not perfect doesnt show all symbols
;; evil-numbers doesnt work
;; completion not perfect doesnt show all snippets, snippets
;; Eglot check if it recognizes shebang (#!/usr/bin/env python3 should start python lsp) lsp-mode does, kinda save kill and reopen file
;; Press K to open doc at point, press K to go into the doc at point but how to move the cursor back from popup, M-n, M-p to scroll
