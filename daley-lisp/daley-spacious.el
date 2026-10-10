;; -*- lexical-binding: t; -*-

(use-package spacious-padding
:ensure t
:config
(setq spacious-padding-widths
      (cond
       ((eq system-type 'darwin)
        '( :internal-border-width 24
           :header-line-width 4
           :mode-line-width 6
           :tab-width 4
           :right-divider-width 24
           :fringe-width 24))
       ((eq system-type 'gnu/linux)
        '( :internal-border-width 14
           :header-line-width 4
           :mode-line-width 4
           :tab-width 4
           :right-divider-width 14
           :fringe-width 14))
       (t
        '( :internal-border-width 15
           :header-line-width 4
           :mode-line-width 4
           :tab-width 4
           :right-divider-width 15
           :fringe-width 15))))
(setq spacious-padding-subtle-frame-lines t)
(spacious-padding-mode 1))

(provide 'daley-spacious)
