;; -*- lexical-binding: t; -*-

(defvar-local daley-modeline-misc-info
  '(:eval
    (when (mode-line-window-selected-p)
      mode-line-misc-info)))

(put 'daley-modeline-misc-info 'risky-local-variable t)

(setq-default mode-line-format
	      '("%e"
		" %* | %b | %m mode " ; this is the info shown on the left hand side of the modeline
		mode-line-format-right-align ; push all items below this line to the most right hand side of the modeline
		daley-modeline-misc-info)) ; show date & time (which is pushed to the farthest right as a result of the line directly above)

(provide 'daley-emacs-modeline)
