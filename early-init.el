;; -*- lexical-binding: t; -*-

(setq frame-resize-pixelwise t
      frame-inhibit-implied-resize 'force
      frame-title-format '("%b")
      ring-bell-function 'ignore
      use-file-dialog nil
      use-short-answers t
      inhibit-splash-screen t
      inhibit-startup-screen t
      inhibit-x-resources t
      inhibit-startup-echo-area-message t
      inhibit-startup-buffer-menu t)

(defun daley/apply-frame-transparency (&optional frame)
  "Apply macOS transparency parameters to FRAME (defaults to selected frame)."
  (with-selected-frame (or frame (selected-frame))
    (set-frame-parameter nil 'alpha-background 0.7)
    (set-frame-parameter nil 'ns-background-blur 30)
    (set-frame-parameter nil 'ns-alpha-elements '(ns-alpha-all))))

(add-hook 'after-make-frame-functions #'daley/apply-frame-transparency)
(unless (daemonp)
  (add-hook 'window-setup-hook #'daley/apply-frame-transparency))

(when (display-graphic-p)
  (daley/apply-frame-transparency))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

(setq default-frame-alist
      (append (list
	       '(undecorated-round . t)
               '(vertical-scroll-bars . nil))))

;; (setq display-line-numbers-type 'relative)
;; (global-display-line-numbers-mode 1)

;; Temporarily increase the garbage collection threshold.  These
;; changes help shave off about half a second of startup time.  The
;; `most-positive-fixnum' is DANGEROUS AS A PERMANENT VALUE.  See the
;; `emacs-startup-hook' a few lines below for what I actually use.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

;; Same idea as above for the `file-name-handler-alist' and the
;; `vc-handled-backends' with regard to startup speed optimisation.
;; Here I am storing the default value with the intent of restoring it
;; via the `emacs-startup-hook'.
(defvar prot-emacs--file-name-handler-alist file-name-handler-alist)
(defvar prot-emacs--vc-handled-backends vc-handled-backends)

(setq file-name-handler-alist nil
      vc-handled-backends nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 100 8)
                  gc-cons-percentage 0.1
                  file-name-handler-alist prot-emacs--file-name-handler-alist
                  vc-handled-backends prot-emacs--vc-handled-backends)))

(setq package-enable-at-startup t)

(setq user-lisp-directory (locate-user-emacs-file "lisp/"))

(add-hook 'after-init-hook (lambda () (set-frame-name "home")))
