;; My Settings

;; Don't show the startup screen
(setq inhibit-startup-message t)
;; Make initial scratch buffer empty
(setq initial-scratch-message nil)
;; "y or n" instead of "yes or no"
(fset 'yes-or-no-p 'y-or-n-p)
;; Highlight regions and add special behaviors to regions.
;; "C-h d transient" for more info
(setq transient-mark-mode t)
;; Explicitly show the end of a buffer
(set-default 'indicate-empty-lines t)
;; Syntax hilight
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
;; Highlight the current line. Always.
(global-hl-line-mode +1)
;; Show column numbers
(setq column-number-mode t)
;; Show matching paren when point is on a paren
(show-paren-mode 1)
;; UTF
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
;; Auto refresh buffers
(global-auto-revert-mode 1)
;; Also auto refresh dired, but be quiet about it
(setq global-auto-revert-non-file-buffers t)
(setq auto-revert-verbose nil)

;; store all backup and autosave files a backup dir
(setq backup-directory-alist '(("" . "~/.emacs.d/backups")))
(setq make-backup-files nil) ; stop creating backup~ files
(setq auto-save-default t)
(setq backup-inhibited t)

;; Kill temp files (maybe?)
(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; Newlines always indent
(global-set-key (kbd "RET") 'newline-and-indent)

;; Don't use electric indent. Ever.
(add-hook 'after-change-major-mode-hook (lambda() (electric-indent-mode -1)))

;; Autosave actual buffers instead of making backups
(defun save-buffer-if-visiting-file (&optional args)
  "Save the current buffer only if it is visiting a file"
  (interactive)
  (if (not (active-minibuffer-window)) ;;If we have an active minibuffer window, we can wait.
      (if (buffer-file-name)
	  (save-buffer args)
	)
    )
  )

;; This causes files that I'm editing to be saved automatically by the
;; emacs auto-save functionality.  I'm hoping to break myself of the
;; c-x c-s twitch.
(add-hook 'auto-save-hook 'save-buffer-if-visiting-file)

;; save every 200 characters typed 
(setq auto-save-interval 200)

;; save after 10 seconds of idle time (default is 30)
(setq auto-save-timeout 10)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)


(defvar bj/dropbox-directory ""
  "Base Dropbox Directory, set per machine.")


(setq custom-file "~/.emacs.d/lisp/custom.el")
(load custom-file)

(provide 'settings)
