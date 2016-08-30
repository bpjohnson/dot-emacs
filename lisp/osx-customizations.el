;;Bryan's osx customizations

;;Switch option and command so that command is M
(setq mac-option-modifier 'hyper)
(setq mac-command-modifier 'meta)

;;Dropbox location
(setq bj/dropbox-directory "/Users/bryan/Dropbox/Notes")

(use-package exec-path-from-shell
  :init
  (progn
    (when (memq window-system '(mac ns))
      (exec-path-from-shell-initialize))
    )
)


(message "OSX Customizations Loaded")
(provide 'osx-customizations)
