;; -*- lexical-binding: t; -*-

 (use-package denote
   :ensure t
   :hook (dired-mode . denote-dired-mode)
   :bind
   (("C-c n n" . denote)
    ("C-c n r" . denote-rename-file)
    ("C-c n l" . denote-link-or-create)
    ("C-c n b" . denote-backlinks)
    ("C-c n d" . denote-dired)
    ("C-c n g" . denote-grep))
   :config
   (setq denote-directory (expand-file-name "~/Notes/"))
   (setq denote-known-keywords '("projects" "areas" "resources" "archives")) ; taken from PARA framework.
   (setq denote-file-type "text")
   (setq denote-sort-keywords nil))

 (add-hook 'text-mode-hook #'denote-fontify-links-mode)

(provide 'daley-denote)
