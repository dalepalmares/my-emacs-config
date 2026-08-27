;; -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :bind (("C-c a" . org-agenda))
  :config
  (setq org-directory "~/Notes/")
  (setq org-agenda-files (list org-directory))

  (setq org-hide-emphasis-markers t)
  (setq org-indent-mode t)
  (setq org-M-RET-may-split-line '((default . nil)))
  (setq org-insert-heading-respect-content t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t)
  (setq org-refile-targets
        '((nil :maxlevel . 3)
	  (org-agenda-files :maxlevel . 3)))
  (setq org-refile-use-outline-path 'file)
  (setq org-outline-path-complete-in-steps nil)

  (setq org-tags-column 0)
  
  ;; disable org-capture & org-refile from generating bookmarks
  (setq org-capture-bookmark nil)
  (setq org-bookmark-names-plist nil)
  
  (setq org-todo-keywords
        '((sequence "TODO(t)" "WAIT(w!)" "|" "CANCEL(c!)" "DONE(d!)"))))

(defun daley-org-agenda-include-priority-no-timestamp ()
  "Return nil if heading has a priority but no timestamp.
    Otherwise, return the buffer position from where the search should
    continue, per `org-agenda-skip-function'."
  (let ((point (point)))
    (if (and (eq (nth 3 (org-heading-components)) ?A)
             (not (org-get-deadline-time point))
             (not (org-get-scheduled-time point)))
        nil
      (line-beginning-position 2))))

(defvar daley-org-custom-daily-agenda
  `((tags-todo "*"
	       ((org-agenda-overriding-header "\n—————————— IMPORTANT TASKS WITHOUT A DATE ——————————\n")
    		(org-agenda-skip-function #'daley-org-agenda-include-priority-no-timestamp)
       		(org-agenda-block-separator nil)))
    (agenda "" ((org-agenda-overriding-header "\n————————————— PENDING SCHEDULED TASKS ——————————————")
       		(org-agenda-block-separator nil)
       		(org-agenda-time-grid nil)
       		(org-agenda-start-on-weekday nil)
       		(org-agenda-span 1)
       		(org-agenda-show-all-dates nil)
       		(org-scheduled-past-days 365)
       		(org-scheduled-delay-days 1)
       		(org-agenda-entry-types '(:scheduled))
       		(org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
       		(org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp "ROUTINE"))
       		(org-agenda-day-face-function (lambda (date) 'org-agenda-date))
       		(org-agenda-format-date "")))
    (agenda "" ((org-agenda-overriding-header "\n—————————————————— TODAY'S AGENDA ——————————————————\n")
       		(org-agenda-block-separator nil)
       		(org-agenda-span 1)
       		(org-deadline-warning-days 0)
       		(org-scheduled-past-days 0)
       		(org-agenda-skip-function '(org-agenda-skip-entry-if 'regexp "ROUTINE"))
       		(org-agenda-day-face-function (lambda (date) 'org-agenda-date))))
    (agenda "" ((org-agenda-overriding-header "\n————————————————— NEXT THREE DAYS ——————————————————\n")
       		(org-agenda-block-separator nil)
       		(org-agenda-start-on-weekday nil)
       		(org-agenda-start-day nil)
       		(org-agenda-start-day "+1d")
       		(org-agenda-span 3)
       		(org-deadline-warning-days 0)
       		(org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))))
    (agenda "" ((org-agenda-overriding-header "\n———————————— UPCOMING DEADLINES (+14D) —————————————\n")
       		(org-agenda-block-separator nil)
       		(org-agenda-time-grid nil)
       		(org-agenda-start-on-weekday nil)
       		(org-agenda-start-day "+4d")
       		(org-agenda-span 14)
       		(org-agenda-show-all-dates nil)
       		(org-agenda-warning-days 0)
       		(org-agenda-entry-types '(:deadline))
       		(org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done)))))
  "Custom agenda for use in `org-agenda-custom-commands'.")

(setq org-agenda-custom-commands
      `(("A" "Daily agenda and top priority tasks"
       	 ,daley-org-custom-daily-agenda)))

; set org agenda headers to be bigger
(custom-set-faces
 '(org-agenda-structure ((t (:family "Aporetic Serif Mono" :height 1.5 :weight bold)))))

; set face for tags to always be fixed-pitch
(custom-set-faces
 '(org-tag ((t (:inherit fixed-pitch :weight bold)))))

(provide 'daley-emacs-org)
