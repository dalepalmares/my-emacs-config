;; -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :config
  (setq org-directory "~/Notes/")
  (setq org-agenda-files (list org-directory))
  
  (setq org-indent-mode t)
  (setq org-M-RET-may-split-line '((default . nil)))
  (setq org-insert-heading-respect-content t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-refile-targets
	'((nil :maxlevel . 9)
	  (org-agenda-files :maxlevel . 9)))
  (setq org-refile-use-outline-path t)

  ;; disable org-capture & org-refile from generating bookmarks
  (setq org-capture-bookmark nil)
  (setq org-bookmark-names-plist nil)
  
  (setq org-todo-keywords
	'((sequence "TODO(t)" "|" "CANCEL(c!)" "DONE(d!)"))))

(provide 'daley-emacs-org)
