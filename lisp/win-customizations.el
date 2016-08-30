(setq bj/dropbox-directory "D:/Documents/Dropbox/Notes")

;Set default document directory
(setq-default default-directory (file-name-as-directory bj/dropbox-directory))

(message "Windows Customizations Loaded")
(provide 'win-customizations)
