;; -*- lexical-binding: t; -*-

(add-to-list 'load-path "/opt/homebrew/share/emacs/site-lisp/mu4e")
(add-to-list 'load-path "/usr/share/emacs/site-lisp/mu4e")
(require 'mu4e)

(require 'smtpmail)

;; Core SMTP Server Settings for Hostinger
(setq message-send-mail-function 'smtpmail-send-it
      smtpmail-smtp-server "smtp.hostinger.com"
      smtpmail-smtp-service 465
      smtpmail-stream-type 'ssl)

(setq mu4e-maildir "~/Maildir"
      ;; Tells mu4e to sync both channels simultaneously
      mu4e-get-mail-command "mbsync hostinger"
      mu4e-update-interval 300)

(setq mu4e-contexts
      (list
       ;; CONTEXT 1: hullo@dalepalmares.com
       (make-mu4e-context
        :name "hullo"
        :match-func (lambda (msg)
                      (when msg
                        (string-prefix-p "/hullo" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address  . "hullo@dalepalmares.com")
                (user-full-name     . "Dale Palmares")
		(smtpmail-smtp-user . "hullo@dalepalmares.com")
		(smtpmail-local-domain   . "dalepalmares.com")
		(mu4e-drafts-folder . "/hullo/Drafts")
                (mu4e-sent-folder   . "/hullo/Sent")
                (mu4e-trash-folder  . "/hullo/Trash")
                (mu4e-refile-folder . "/hullo/Archive")))

       ;; CONTEXT 2: me@dalepalmares.com
       (make-mu4e-context
        :name "me"
        :match-func (lambda (msg)
                      (when msg
                        (string-prefix-p "/me" (mu4e-message-field msg :maildir))))
        :vars '((user-mail-address  . "me@dalepalmares.com")
                (user-full-name     . "Dale Palmares")
		(smtpmail-smtp-user . "me@dalepalmares.com")
		(smtpmail-local-domain   . "dalepalmares.com")
		(mu4e-drafts-folder . "/me/Drafts")
                (mu4e-sent-folder   . "/me/Sent")
                (mu4e-trash-folder  . "/me/Trash")
                (mu4e-refile-folder . "/me/Archive")))))

(provide 'daley-emacs-email)
