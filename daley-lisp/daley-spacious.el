;; -*- lexical-binding: t; -*-

(use-package spacious-padding
  :ensure t
  :config
  (setq spacious-padding-widths
	'( :internal-border-width 24
	   :header-line-width 4
	   :mode-line-width 6
           :tab-width 4
           :right-divider-width 10
           :fringe-width 24))
  (setq spacious-padding-subtle-frame-lines t))

(spacious-padding-mode 1)

(provide 'daley-spacious)
