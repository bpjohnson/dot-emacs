;;Welcome to my Emacs.

;;Always start new frames maximized (not fullboth)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Require Emacs' package functionality
(require 'package)

;; Add org-mode repo to package sources

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;; Add the Melpa repository to the list of package sources
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
;; And marmalade
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Initialise the package system.
(package-initialize)

;; Make sure use-package is installed
(unless (package-installed-p 'use-package)
  (message "%s" "Refreshing package db...")
  (package-refresh-contents)
  (message "%s" " done.")
  (message "%s" "Installing use-package...")
  (package-install 'use-package)
  )

(require 'use-package)
(setq use-package-always-ensure t) ;; always install packages using package.el
                                   ;; this means local packages need ":ensure nil"

(use-package settings ;; Non-package global settings. Also customize settings
  :load-path "lisp/"
  :ensure nil)


(use-package osx-customizations
  :load-path "lisp/"
  :ensure nil
  :if (eq system-type 'darwin)
  )

(use-package win-customizations
  :load-path "lisp/"
  :ensure nil
  :if (eq system-type 'windows-nt)
  )

(load-theme 'material t)

;;; Emacs Stuff
;; Complete everything but M-x
(use-package ido 
  ;:disabled t
  :init
  (progn
  (ido-mode t)
  (setq ido-enable-flex-matching t
      ido-use-virtual-buffers t)
  (setq ido-default-buffer-method 'selected-window)
  (add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
  (add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
  (require 'ido-hacks)
  (defun ido-sort-mtime ()
    (setq ido-temp-list
          (sort ido-temp-list
                (lambda (a b)
                  (let ((ta (nth 5 (file-attributes (concat ido-current-directory a))))
                        (tb (nth 5 (file-attributes (concat ido-current-directory b)))))
                    (if (= (nth 0 ta) (nth 0 tb))
                        (> (nth 1 ta) (nth 1 tb))
                      (> (nth 0 ta) (nth 0 tb)))))))
    (ido-to-end  ;; move . files to end (again)
     (delq nil (mapcar
                (lambda (x) (if (string-equal (substring x 0 1) ".") x))
                ido-temp-list))))))

;; Complete M-x
(use-package smex
  :bind (
         ("M-x" . smex)
         ("M-X" . smex-major-mode-commands)
         ("C-c C-c M-x" . execute-extended-command)
         )
  )

(use-package smooth-scrolling)

;;Emacs 25 only
(save-place-mode 1)

;; More sane replacements for common emacs stuff
(global-set-key (kbd "C-x C-b") 'ibuffer)

(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

;;; Programmer Stuff

;;Tern - http://ternjs.net/doc/manual.html#editor
;;(add-to-list 'load-path "~/.emacs.d/tern/emacs")
;;(autoload 'tern-mode "tern.el" nil t)
(use-package tern
  :load-path "tern/emacs"
  :ensure nil
)

(use-package js2-mode
  :mode "\\.js$"
  :diminish "js2"
  :init
  (progn
    (add-hook 'js2-mode-hook '(lambda () (tern-mode t)))
    )
)


;;; M-. Jump to definition
;;; M-, Jump back from definition
;;; M-? Jump to references


(use-package xref-js2
  :init
  (progn
    (add-hook 'js2-mode-hook (lambda ()
			       (define-key js2-mode-map (kbd "M-.") nil)
			       (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))
    )
  )

(use-package web-beautify
  :init
  (progn
    (eval-after-load 'js2-mode
      '(define-key js2-mode-map (kbd "C-c b") 'web-beautify-js))
    (eval-after-load 'json-mode
      '(define-key json-mode-map (kbd "C-c b") 'web-beautify-js))
    (eval-after-load 'web-mode
      '(define-key web-mode-map (kbd "C-c b") 'web-beautify-html))
    (eval-after-load 'css-mode
      '(define-key css-mode-map (kbd "C-c b") 'web-beautify-css))
    )
)

(use-package company
  :defer nil
  :diminish company-mode
  :init (progn
	  (add-hook 'after-init-hook (lambda ()
				       (global-company-mode)
				       (use-package company-tern
					 :defer nil
					 :init (progn
						 (add-to-list 'company-backends 'company-tern)
						 )
					 )
				       (use-package company-web
					 :defer nil
					 :init (progn
						 (add-to-list 'company-backends 'company-web-html)
						 )
					 )
				       (use-package company-php
					 :defer nil
					 :init (progn
						 (add-to-list 'company-backends 'company-ac-php-backend)
						 )
					 )
				       )
		    
		    )
	  )
  )


(use-package php-mode
  :init (progn
	   (add-hook 'php-mode-hook (lambda ()
				      (subword-mode 1)
				      (php-enable-wordpress-coding-style)
				      )
	   )
))

(use-package web-mode
  :mode (
	 ("\\.php\\'" . web-mode)
	 ("\\.ihtml\\'" . web-mode)
	 ("\\.inc\\'" . web-mode)
	 ("\\.html?\\'" . web-mode)
	 ("\\.scss\\'" . web-mode)
	 ("\\.css\\'" . web-mode)
	 ("\\.jsx\\'" . web-mode)
	 )
  :init (progn
	  (setq web-mode-engines-alist
	  '(
	    ("php" . "\\.inc")
	    ("php" . "\\.ihtml")
	    ("meteor" . "\\.html\\'")
	    )
	  )
	  (add-hook 'web-mode-hook (lambda ()
				     (setq web-mode-markup-indent-offset 2)
				     (setq web-mode-code-indent-offset 2)
				     (setq web-mode-css-indent-offset 2)		     
				     (setq indent-tabs-mode nil)
				     (setq web-mode-enable-auto-pairing t)
				     (setq web-mode-enable-part-face nil)
				     (setq web-mode-enable-block-face nil)
				     (setq web-mode-enable-css-colorization t)
				     ;(set (make-local-variable 'company-backends) '(company-web-html))
				     ))

	   )
)




(defun toggle-php-flavor-mode ()
  (interactive)
  "Toggle mode between PHP & Web-Mode Helper modes"
  (cond ((string= mode-name "PHP/w")
         (web-mode))
        ((string= mode-name "Web")
         (php-mode))))

(global-set-key [f5] 'toggle-php-flavor-mode)

;;;Automatically highlight TODO: and FIXME
(defun font-lock-comment-annotations ()
  "Highlight a bunch of well known comment annotations.
This functions should be added to the hooks of major modes for programming."
  (font-lock-add-keywords
   nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|OPTIMIZE\\|HACK\\|REFACTOR\\):?"
          1 font-lock-warning-face t))))

(add-hook 'prog-mode-hook 'font-lock-comment-annotations)

;;;Rainbow Mode shows hexcodes as colors
(use-package rainbow-mode)

(use-package rainbow-delimiters
  :init
  (progn
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
    )
  )

;;editorconfig https://github.com/editorconfig/editorconfig-emacs#readme
(use-package editorconfig
  ;;  :disabled t
  :demand t
  )
