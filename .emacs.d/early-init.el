;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

;; suppress the standard startup screens/messages early
(setq inhibit-startup-screen t
      inhibit-startup-message t
      use-dialog-box nil             ; no popup dialogs
      ring-bell-function 'ignore)     ; disable bell

;; load custom-set-variables from a separate file (prevents clutter in init.el)
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;; performance: defer garbage collections during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; prevent automatic package activation here
;;(setq package-enable-at-startup nil)  ;; stops package.el from activating before init.el

;; stop frame resize flicker during startup
(setq frame-inhibit-implied-resize t)  ;; avoids size/geometry changes after frame is made

(menu-bar-mode -1)  ;; hide menu bar
(tool-bar-mode -1)  ;; hide tool bar
(scroll-bar-mode -1) ;; hide scroll bars

;; default first frame appearance: start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

