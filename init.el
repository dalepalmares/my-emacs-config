;;; init.el --- Description -*- lexical-binding: t; -*-

(setq user-full-name  "daley"
    user-mail-address "dalepalmares@gmail.com")

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(elpaca-wait)

(setq use-package-always-defer t
      use-package-always-ensure t
      ;; Testing for package timing
      ;; use-package-compute-statistics t
      use-package-expand-minimally t)

(use-package no-littering
  :demand tq
  :config
  (require 'no-littering))

(use-package recentf
  :ensure nil
  :after no-littering
  :config
(recentf-mode 1))

(elpaca-wait)

(add-to-list 'load-path "~/.emacs.d/lisp/nano-emacs")

(require 'nano-faces)

(require 'nano-theme)
(require 'nano-theme-dark)
(require 'nano-theme-light)
(nano-theme-set-dark)

(setq nano-font-family-monospaced "Maple Mono NF")
(setq nano-font-family-proportional "Atkinson Hyperlegible")
(setq nano-font-size 24)

(nano-refresh-theme)

(require 'nano-modeline)
(nano-modeline)

(require 'nano-layout)

(add-to-list 'default-frame-alist '(undecorated-round . t))
  (add-to-list 'default-frame-alist '(ns-background-blur . 40))
  (add-to-list 'default-frame-alist '(ns-alpha-elements ns-alpha-all))

(dolist (frame (frame-list))
  (set-frame-parameter frame 'undecorated-round t)
  (set-frame-parameter frame 'ns-alpha-elements 'ns-alpha-all)
  (set-frame-parameter frame 'ns-background-blur 40))

(menu-bar-mode 0)
(tool-bar-mode 0)
(scroll-bar-mode 0)

(use-package dashboard
  :elpaca t
  :config
  (add-hook 'elpaca-after-init-hook #'dashboard-insert-startupify-lists)
  (add-hook 'elpaca-after-init-hook #'dashboard-initialize)
  (dashboard-setup-startup-hook))

  (setq initial-buffer-choice 'dashboard-open)

  (setq dashboard-display-icons-p t)     ; display icons on both GUI and terminal
  (setq dashboard-icon-type 'nerd-icons) ; use `nerd-icons' package

  (setq dashboard-startup-banner "~/.emacs.d/etc/marcus no bg.png")
  (setq dashboard-image-banner-max-width 500)    ; narrower
  (setq dashboard-image-banner-max-height 500)   ; shorter
  (setq dashboard-banner-logo-title "If it's endurable, then endure it. \n Stop complaining.")
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)

  ;; show ONLY the image + welcome text:
  (setq dashboard-startupify-list
        '(dashboard-insert-banner
          dashboard-insert-newline
          dashboard-insert-banner-title
          dashboard-insert-newline))
  (setq dashboard-items nil)
  (setq dashboard-set-footer nil)
  (setq dashboard-show-shortcuts nil)

(defun my/dashboard-hide-header-line ()
  "Hide nano's header-line modeline on the dashboard buffer."
  (when (derived-mode-p 'dashboard-mode)
    (setq-local mode-line-format nil)
    (set-window-parameter nil 'mode-line-format nil)
    (setq-local header-line-format nil)))

(add-hook 'dashboard-mode-hook #'my/dashboard-hide-header-line)
(add-hook 'dashboard-after-initialize-hook #'my/dashboard-hide-header-line)

;; change shape so it's that fat rectangle
(setq cursor-type 'bar)

;; beacon mode, to light the way and help you find your cursor
(use-package beacon
:demand t
:config
(beacon-mode 1))

(use-package nerd-icons
  :demand t)
(use-package nerd-icons-completion
  :demand t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))
(use-package nerd-icons-corfu
  :demand t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))
(use-package nerd-icons-dired
  :demand t
  :hook
  (dired-mode . nerd-icons-dired-mode))

(add-to-list 'display-buffer-alist
           '("\\`\\*\\(Warnings\\|Compile-Log\\)\\*\\'"
             (display-buffer-no-window)
             (allow-no-window . t)))

(use-package delsel
:ensure nil ; no need to install it as it is built-in
:hook (after-init . delete-selection-mode))

(defun prot/keyboard-quit-dwim ()
(interactive)
(cond
 ((region-active-p)
  (keyboard-quit))
 ((derived-mode-p 'completion-list-mode)
  (delete-completion-window))
 ((> (minibuffer-depth) 0)
  (abort-recursive-edit))
 (t
  (keyboard-quit))))
(define-key global-map (kbd "C-g") #'prot/keyboard-quit-dwim)

(use-package vertico
  :ensure t
  :init
  (vertico-mode 1)
  :custom
  (vertico-cycle t))

(use-package marginalia
 :ensure t
 :init
 (marginalia-mode 1))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package savehist
 :ensure nil
 :config
 (setq history-length 1000
       history-delete-duplicates t
       savehist-save-minibuffer-history t)
 (dolist (var '(extended-command-history
                search-ring
                regexp-search-ring
                consult--buffer-history
                recentf-list))
   (add-to-list 'savehist-additional-variables var)))

(elpaca-wait)

(use-package corfu
:ensure t
:custom
(corfu-auto        t)
(corfu-auto-delay  0)
(corfu-preview-current t)
(corfu-auto-prefix 1)
(corfu-cycle       t)
(corfu-quit-no-match t)
:config
(corfu-popupinfo-mode)
:init
(global-corfu-mode))

(setq org-directory "~/notes/org/")

(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars nil)
  (org-modern-table nil)
  (org-modern-list '((?* . "•") (?+ . "‣")))
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(setq org-modern-star '("◉" "○" "✸" "✿" "✤" "✜"))

(use-package org-modern-indent
  :ensure (:host github :repo "jdtsmith/org-modern-indent")
  :init
  (setq org-startup-indented t) ; Required: Enables org-indent-mode by default
  :config
  ;; Add late to the hook (priority 90) as recommended by the developer
  (add-hook 'org-mode-hook #'org-modern-indent-mode 90))

(global-org-modern-mode)

(use-package org-roam
:ensure t
:custom
;; Define your primary notes directory (change this path)
(org-roam-directory (file-truename "~/notes/roam"))
:bind (("C-c n f" . org-roam-node-find)
       ("C-c n i" . org-roam-node-insert)
       ("C-c n c" . org-roam-capture)
       ;; Optional: Keybindings for UI and database sync
       ("C-c n l" . org-roam-buffer-toggle)
       ("C-c n g" . org-roam-graph)
       ("C-c n db" . org-roam-db-sync))
:config
;; Initialize the database and background synchronization
(org-roam-db-autosync-mode))
