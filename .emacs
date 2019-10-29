;; fix https://debbugs.gnu.org/cgi/bugreport.cgi?bug=34341 (fixed in 26.3)
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; fix https://debbugs.gnu.org/cgi/bugreport.cgi?bug=33825 (fixed in 26.3)
(setq package-check-signature nil)

(require 'whitespace)

;; (add-hook 'python-mode-hook
;;       (lambda ()
;;         (setq indent-tabs-mode t)
;;         (setq tab-width 4)
;;         (setq python-indent 4)))

;; Add MELPA to package archive list

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; (when (> emacs-major-version 23)
;;     (require 'package)
;;     (package-initialize)
;;     (add-to-list 'package-archives 
;;                  '("melpa" . "http://melpa.milkbox.net/packages/")
;;                  'APPEND))


(defun reload ()
  (interactive)
  (load-file "~/.emacs"))

(defun generate-buffer ()
  (interactive)
  (switch-to-buffer (make-temp-name "scratch")))

;;; Cache password for tramp remote sessions
(setq password-cache-expiry nil)

;;; Turn on tramp debugging
(setq tramp-verbose 10)

(defun prev-window ()
   (interactive)
   (other-window -1))

(define-key global-map (kbd "C-x p") 'prev-window)
(global-set-key (kbd "M-[ A") (kbd "<up>"))
(global-set-key (kbd "M-[ B") (kbd "<down>"))
(global-set-key (kbd "M-[ C") (kbd "<right>"))
(global-set-key (kbd "M-[ D") (kbd "<left>"))
(global-set-key (kbd "M-[ a") (kbd "S-<up>"))
(global-set-key (kbd "M-[ b") (kbd "S-<down>"))
(global-set-key (kbd "M-[ c") (kbd "S-<right>"))
(global-set-key (kbd "M-[ d") (kbd "S-<left>"))
(global-set-key (kbd "M-O a") (kbd "C-<up>"))
(global-set-key (kbd "M-O b") (kbd "C-<down>"))
(global-set-key (kbd "M-O c") (kbd "C-<right>"))
(global-set-key (kbd "M-O d") (kbd "C-<left>"))
(global-set-key (kbd "ESC M-[ A") (kbd "M-<up>"))
(global-set-key (kbd "ESC M-[ B") (kbd "M-<down>"))
(global-set-key (kbd "ESC M-[ C") (kbd "M-<right>"))
(global-set-key (kbd "ESC M-[ D") (kbd "M-<left>"))

;; Use ALT-<arrow keys> for window navigation. Before that we need to do the following to set up
;; input decode map
;;
;; On my emacs (running in console mode with "-nw"), M-<UP> generates "<ESC> <ESC> O A" event sequence
;; (verified with "C-h l"), and M-<DOWN> generates "<ESC> <ESC> O B". In additional, MacOS Terminal app maps
;; M-<left> to M-B(word backward), and M-<right> to M-F(word forward). As an emacs user I've accustomed to
;; use M-B and M-F, no longer need the M-<left> and M-<right> mapper. So I just removed the mapping
;; from the Terminal app. 
(define-key input-decode-map "\e\eOA" [(meta up)])
(define-key input-decode-map "\e\eOB" [(meta down)])
(define-key input-decode-map "\e\eOC" [(meta right)])
(define-key input-decode-map "\e\eOD" [(meta left)])

;; Wind Move: use Shift and arrow keys to move point from window to window
;; The ‘fbound’ test is for those XEmacs installations that don’t have the windmove package available.
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings 'meta))

;; Since M-<LEFT> and M-<RIGHT> are already bound to backward-word and forward-word, so we will not use 
;; (windmove-default-keybindings 'meta) to do all-directional window navigation. Instead, just rebind
;; prev-window and next-window
;; (define-key global-map (kbd "M-<up>") 'prev-window)
;; (define-key global-map (kbd "M-<down>") 'other-window)

;; 
;;; Wind Move: use Shift and arrow keys to move point from window to window
;;; The ‘fbound’ test is for those XEmacs installations that don’t have the windmove package available.
;; (when (fboundp 'windmove-default-keybindings)
;; ;;   (global-set-key (vector (list 'meta 'meta ?\o ?\a))    'windmove-up))
;;    (global-set-key [('esc 'up)]    'windmove-up))
;;   ;; (windmove-default-keybindings 'meta))
;;   ;; (global-set-key (vector (list 'alt 'left))  'windmove-left)
;;   ;; (global-set-key (vector (list 'alt 'right)) 'windmove-right)
;;   ;; (global-set-key (vector (list 'alt 'up))    'windmove-up)
;;   ;; (global-set-key (vector (list 'alt 'down))  'windmove-down))

(global-set-key [f5] 'eshell)
(global-set-key [f6] 'ido-switch-buffer)
(global-set-key [f7] 'rgrep)

;;; ffap
;;;
(require 'ffap)                      ; load the package
(ffap-bindings)                      ; do default key bindings
(setq ffap-require-prefix t)         ; require prefix with ffap bindings so that ffap binding won't interfere with ido

(defun kill-other-buffers ()
      "Kill all other buffers."
      (interactive)
      (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun kill-dired-buffers ()
    (interactive)
     (mapc (lambda (buffer) 
           (when (eq 'dired-mode (buffer-local-value 'major-mode buffer)) 
             (kill-buffer buffer))) 
         (buffer-list)))

;; ===== Enable mouse support ====
                                       
(require 'xt-mouse)                   
(xterm-mouse-mode)

;;; Copy-paste to/from emacs
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(defun copy-to-x-clipboard ()
  (interactive)
  (if (region-active-p)
    (progn
     ; my clipboard manager only intercept CLIPBOARD
      (shell-command-on-region (region-beginning) (region-end)
        (cond
         ((eq system-type 'cygwin) "putclip")
         ((eq system-type 'darwin) "pbcopy")
         (t "xsel -ib")
         )
        )
      (message "Yanked region to clipboard!")
      (deactivate-mark))
    (message "No region active; can't yank to clipboard!")))


(defun paste-from-x-clipboard()
  (interactive)
  (shell-command
   (cond
    ((eq system-type 'cygwin) "getclip")
    ((eq system-type 'darwin) "pbpaste")
    (t "xsel -ob")
    )
   1)
  )

;;;------------------------------------------------------------------------   
;;; Provide a version of Emacs 24's 'string-prefix-p in older emacs
;;;------------------------------------------------------------------------   
;; (unless (fboundp 'string-prefix-p)                                            
;;   (defun string-prefix-p (shorter longer)                                     
;;     (let ((n (mismatch shorter longer))                                       
;;          (l (length shorter)))                                                
;;       (if (or (not n) (= n l)) l nil))))                                      
                                                                              
;;; Fix junk characters in shell-mode
(add-hook 'shell-mode-hook 
          'ansi-color-for-comint-mode-on)

;;; Use iswitchb to switch buffers
;;; (iswitchb-mode 1)

;;; Use ido to switch buffers
(setq ido-enable-flex-matching t)
  (setq ido-everywhere t)
  (ido-mode 1)

;;; Automatically save session when quit
(desktop-save-mode 1)

;; (defun file-name-base (&optional filename)
;;   "Return the base name of the FILENAME: no directory, no extension.
;; FILENAME defaults to `buffer-file-name'."
;;   (file-name-sans-extension
;;    (file-name-nondirectory (or filename (buffer-file-name)))))

(let ((default-directory  "~/.emacs.d/el-get/"))
  (normal-top-level-add-subdirs-to-load-path))
;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;; (el-get 'sync)

;; ;; (add-to-list 'load-path "~/.emacs.d/el-get/el-get")
;; ;; (unless (require 'el-get nil 'noerror)
;; ;;   (with-current-buffer
;; ;;       (url-retrieve-synchronously
;; ;;        "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
;; ;;     (let (el-get-master-branch)
;; ;;       (goto-char (point-max))
;; ;;       (eval-print-last-sexp))))
;; ;; (el-get 'sync)


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(ignore-errors (when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize)))


(require 'python)

(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)                      ; optional
(setq jedi:complete-on-dot t)                 ; optional

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(async-shell-command-buffer (quote confirm-kill-process))
 '(eshell-aliases-file "/highland/.emacs.d/eshell/alias")
 '(indent-tabs-mode nil)
 '(jira-url "https://jira.corp.skytap.com/rpc/xmlrpc")
 '(menu-bar-mode nil)
 '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "https://melpa.org/packages/"))))
 '(python-remove-cwd-from-path nil)
 '(safe-local-variable-values (quote ((eval ignore-errors "Write-contents-functions is a buffer-local alternative to before-save-hook" (add-hook (quote write-contents-functions) (lambda nil (delete-trailing-whitespace) nil)) (require (quote whitespace)) "Sometimes the mode needs to be toggled off and on." (whitespace-mode 0) (whitespace-mode 1)) (whitespace-line-column . 80) (whitespace-style face tabs trailing lines-tail) (require-final-newline . t) (prompt-to-byte-compile))))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; To allow mysql mode to accept blank password
(setq sql-user "root")
(setq sql-password nil)

;; (defun prod-mysql()
;;   (interactive)
;;   (let ((sql-user "soup") (sql-password "I5_bo1onki") (sql-server "tuk1bmetricsdb1.mgt.prod.skytap.com"))
;;     (sql-mysql "prod-mysql")
;;   )
;; )

(defun prod-mysql (local-user-name)
  "Mysql replicate in prod"
    (interactive
     (list
      (completing-read "Macbook user name: " '("bxiao (office)" "bingxiao (home)"))))
    ;; (eshell-command "pushd . & cd /ssh:bxiao@tuk1linjump4.prod.skytap.com: & async-shell-command \"mysql -h tuk1bi2.prod.skytap.com -p --ssl-ca /etc/ldap/cacert/skytap-ca.pem --enable-cleartext-plugin\" \"prod-mysql\" & popd"))
    (let ((my-macbook-ip (car (split-string (shell-command-to-string "who | cut -d\"(\" -f2 |cut -d\":\" -f1"))))
          (my-macbook-user-name (car (split-string local-user-name " "))))
      (eshell-command "pushd . & cd (format \"/ssh:%s@%s:\" my-macbook-user-name my-macbook-ip) & async-shell-command \"ssh bxiao@tuk1linjump4.prod.skytap.com\" \"prod-mysql\" & popd"))
    (switch-to-buffer "prod-mysql")
    (insert "mysql -h tuk1bi2.prod.skytap.com -p --ssl-ca /etc/ldap/cacert/skytap-ca.pem --enable-cleartext-plugin")
    ;; (comint-send-input nil t)
)

(defun tuk1m1control (local-user-name)
  "Mysql replicate in prod"
    (interactive
     (list
      (completing-read "Macbook user name: " '("bxiao (office)" "bingxiao (home)"))))
    (let ((my-macbook-ip (car (split-string (shell-command-to-string "who | cut -d\"(\" -f2 |cut -d\":\" -f1"))))
          (my-macbook-user-name (car (split-string local-user-name " "))))
      (eshell-command "pushd . & cd (format \"/ssh:%s@%s:\" my-macbook-user-name my-macbook-ip) & async-shell-command \"ssh bxiao@tuk1linjump4.prod.skytap.com\" \"tuk1m1control\" & popd"))
    (switch-to-buffer "tuk1m1control")
    (insert "ssh tuk1m1control")

    ;; (comint-send-input nil t)
)

(defun linjump (local-user-name)
    (interactive
     (list
      (completing-read "Macbook user name: " '("bxiao (office)" "bingxiao (home)"))))
    (let ((my-macbook-ip (car (split-string (shell-command-to-string "who | cut -d\"(\" -f2 |cut -d\":\" -f1"))))
          (my-macbook-user-name (car (split-string local-user-name " "))))
    (eshell-command "pushd . & cd (format \"/ssh:%s@%s:\" my-macbook-user-name my-macbook-ip) & async-shell-command \"ssh bxiao@tuk1linjump4.prod.skytap.com\" \"linjump\" & popd"))
)

(defun test-mysql ()
  "Mysql replicate in test"
    (interactive)
    (eshell-command "pushd . & cd /ssh:bxiao@tuk6bi1.mgt.test.skytap.com: & async-shell-command \"mysql -u root -p --protocol TCP\" \"test-mysql\" & popd"))

;;; To show full file path in in emacs window
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))

;;; Copy full file name to kill ring
(defun copy-buffer-file-name ()
  "Copy the full file path of the current buffer to the kill ring."
  (interactive)
  (let ((fn buffer-file-name))
    (message fn)
    (if fn
	(progn (message fn) (kill-new (file-truename fn))
	)
      (message "There is no file associated with the current buffer")))
)

(defun rename-file-and-buffer ()
  "Rename the current buffer and file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (message "Buffer is not visiting a file!")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)))))))


(defun revert-all-buffers ()
          "Refreshes all open buffers from their respective files"
          (interactive)
          (let* ((list (buffer-list))
                 (buffer (car list)))
            (while buffer
              (when (and (buffer-file-name buffer) 
                         (not (buffer-modified-p buffer)))
                (set-buffer buffer)
                (revert-buffer t t t))
              (setq list (cdr list))
              (setq buffer (car list))))
          (message "Refreshed open files"))

;;;--------------------------
;;; Python related
;;;-------------------------
;; (when (load "flymake" t) 
;;          (defun flymake-pyflakes-init () 
;;            (let* ((temp-file (flymake-init-create-temp-buffer-copy 
;;                               'flymake-create-temp-inplace)) 
;;               (local-file (file-relative-name 
;;                            temp-file 
;;                            (file-name-directory buffer-file-name)))) 
;;              (list "pyflakes" (list local-file)))) 

;;          (add-to-list 'flymake-allowed-file-name-masks 
;;                   '("\\.py\\'" flymake-pyflakes-init))) 

;;    (add-hook 'find-file-hook 'flymake-find-file-hook)

(defun python--add-debug-highlight ()
  "Adds a highlighter for use by `python--pdb-breakpoint-string'"
  (highlight-lines-matching-regexp "## DEBUG ##\\s-*$" 'hi-red-b))
 
(add-hook 'python-mode-hook 'python--add-debug-highlight)
 
(defvar python--pdb-breakpoint-string "import pdb; pdb.set_trace() ## DEBUG ##"
  "Python breakpoint string used by `python-insert-breakpoint'")
 
(defvar python--pdb-postmortem-string "import pdb; pdb.post_mortem(sys.exc_info()[2]) ## DEBUG ##"
  "Python breakpoint string used by `python-insert-postmortem'")

(defun python-insert-breakpoint ()
  "Inserts a python breakpoint using `pdb'"
  (interactive)
  (back-to-indentation)
  ;; this preserves the correct indentation in case the line above
  ;; point is a nested block
  (split-line)
  (insert python--pdb-breakpoint-string))

(defun python-insert-postmortem ()
  "Inserts a python postmortem using `pdb'"
  (interactive)
  (back-to-indentation)
  ;; this preserves the correct indentation in case the line above
  ;; point is a nested block
  (split-line)
  (insert python--pdb-postmortem-string))

(define-key python-mode-map (kbd "<f9>") 'python-insert-breakpoint)

(defun python-insert-pause ()  
      "add a pause in Python program"  
    (interactive)  
    (insert "print 'press [ENTER] to continue:', sys.stdin.readline(); print"))

(defun python-insert-sql-echo ()  
      "add SQL echo to SQL alchemy "  
    (interactive)  
    (insert "sql_echo=True"))

(defun python-insert-import-transaction ()  
      "import transaction "  
    (interactive)  
    (insert "from hosting_platform.db import transaction"))

(defun python-get-package-location ()  
      "import transaction "  
    (interactive)  
    (insert "import site; site.getsitepackages()"))

(defun python-interactive ()
    "Enter the interactive Python environment"
    (interactive)
    (progn
      (insert "!import code; code.interact(local=vars())")
      (move-end-of-line 1)
      (comint-send-input)))
  
  (global-set-key (kbd "C-c i") 'python-interactive)

(defun python-disable-pager ()
  "Disable IPython pager'"
    (interactive)  
    (insert "from __future__ import print_function;from IPython.core import page;page.page = print"))

(defun dbg-get-configuration-specification (configuration_key)  
      "get configuration specification during debugging "  
    (interactive "sConfiguration Key: ")  
    (insert "from hosting_platform.services.configuration_manager.operations import GetConfigurationSpecificationOperation\n")
    (insert "from pprint import pprint\n")
    (insert "from hosting_platform.common.logs import initialize_logger\n")
    (insert (format "__spec = GetConfigurationSpecificationOperation({'%s': None}, logger=initialize_logger(\"get-configuration-specification\")).get_api_return_value()\n" configuration_key))
    (insert "pprint(__spec)\n"))

(defun python-outline()
  "Display class and function definitions"
  (interactive)
  (occur "^\\(\\s-*def\\s-+\\)\\|\\(\\s-*class\\s-*\\)"))

;; Load mercurial.el
;; (add-to-list 'load-path "~/.emacs.d/mercurial/")
;; (require 'mercurial "mercurial.el")

;; Display column number
(setq column-number-mode t)

; (require 'jira)

;;;;org-mode configuration
;; Enable org-mode
(require 'org)
;; Make org-mode work with files ending in .org
;; (add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
;; The above is the default in recent emacsen

;;; org-jira mode
;; commented out as I get error "Debugger entered--Lisp error: (file-error "Cannot open load file" "soap-client")"
;; (add-to-list 'load-path "~/.emacs.d/org-jira/")
;; (setq jiralib-url "https://jira.corp.skytap.com") 
;; (require 'org-jira) 

;;; Make S-tab for org-mode works over terminal
(define-key function-key-map "\e[Z" [backtab])

;;; Set back up file location
(setq backup-directory-alist '(("." . "~/.emacs.d/backup"))
  backup-by-copying t    ; Don't delink hardlinks
  version-control t      ; Use version numbers on backups
  delete-old-versions t  ; Automatically delete excess backups
  kept-new-versions 20   ; how many of the newest versions to keep
  kept-old-versions 5    ; and how many of the old
  )

(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "python -m json.tool" (buffer-name) t)
    )
)
(put 'downcase-region 'disabled nil)

;;; Show unique buffer name
(require 'uniquify)

(require 'register-list)

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun semnav-up (arg)
  (interactive "p")
  (when (nth 3 (syntax-ppss))
    (if (> arg 0)
        (progn
          (skip-syntax-forward "^\"")
          (goto-char (1+ (point)))
          (decf arg))
      (skip-syntax-backward "^\"")
      (goto-char (1- (point)))
      (incf arg)))
  (up-list arg))

;; by Nikolaj Schumacher, 2008-10-20. Released under GPL.
(defun extend-selection (arg &optional incremental)
  "Select the current word.
Subsequent calls expands the selection to larger semantic unit."
  (interactive (list (prefix-numeric-value current-prefix-arg)
                     (or (region-active-p)
                         (eq last-command this-command))))
  (if incremental
      (progn
        (semnav-up (- arg))
        (forward-sexp)
        (mark-sexp -1))
    (if (> arg 1)
        (extend-selection (1- arg) t)
      (if (looking-at "\\=\\(\\s_\\|\\sw\\)*\\_>")
          (goto-char (match-end 0))
        (unless (memq (char-before) '(?\) ?\"))
          (forward-sexp)))
      (mark-sexp -1))))

(global-set-key (kbd "M-8") 'extend-selection)


(add-to-list 'load-path "~/.emacs.d/hide-lines")
(require 'hide-lines)

(ignore-errors (add-to-list 'load-path "~/.emacs.d/shell-command/"))
(ignore-errors (require 'shell-command))
(ignore-errors (shell-command-completion-mode))

;;; ------------------------------
;;; Enable bash completion in shell mode (depends on shell-command.el)
;;; BX: Does not appear to be working 
;;; ------------------------------
(ignore-errors (add-to-list 'load-path "~/.emacs.d/emacs-bash-completion/"))
(ignore-errors (require 'bash-completion))
(ignore-errors (bash-completion-setup))
;; (add-to-list 'load-path "~/.emacs.d/emacs-bash-completion/")
;; (require 'bash-completion)
;; (bash-completion-setup)


;;; ------------------------------
;;; skycap shortcuts
;;; ------------------------------
(defun skycap-service-action (svc action)  
      "Insert command to start skytap services"  
    (interactive
       (list
   	(completing-read "Service name: " '("control_host" "mysqld" "greenbox" "configuration_manager" "accounting_service" "storage_service" "storage_node_service" "charon_service" "name_service" "syslog_ng"))
	(completing-read "Action: " '("upgrade" "start" "stop" "status" "puppetize" "update_config" "update_config_restart" "update_code"))
       ))
    (insert (format "skycap svc:%s:%s" svc action)))

(defun skycap-service-group-action (svcgrp action)  
      "Insert command to start skytap services"  
    (interactive
       (list
   	(completing-read "Service group name: " '("web_services"))
	(completing-read "Action: " '("sequenced_upgrade"))
       ))
    (insert (format "skycap svc_grp:%s:%s" svcgrp action)))

(defun skycap-db-migrate (database)  
      "Insert command to migrate database"  
    (interactive
       (list
	(completing-read "Database: " '("greenbox" "configuration" "accounting" "storage" "charon"))))
    (insert (format "skycap db:%s:migrate" database)))

(defun skycap-cron-action (svc action)  
      "Insert command to check the status of cron job"  
    (interactive
       (list
	(completing-read "Service name: " '("system_test" "system_test_cleanup" "system_test_performance"))
	(completing-read "Action: " '("cron_status" "install_cron" "remove_cron"))
       ))
    (insert (format "skycap svc:%s:%s" svc action)))

(defun skycap-cron-status (svc)  
      "Insert command to check the status of cron job"  
    (interactive
       (list
	(completing-read "Service name: " '("system_test" "system_test_cleanup" "system_test_performance"))))
    (insert (format "skycap svc:%s:cron_status" svc)))

(defun skycap-cron-install (svc)  
      "Insert command to install cron job"  
    (interactive
       (list
	(completing-read "Service name: " '("system_test" "system_test_cleanup" "system_test_performance"))))
    (insert (format "skycap svc:%s:install_cron" svc)))

(defun skycap-cron-remove (svc)  
      "Insert command to remove cron job"  
    (interactive
       (list
	(completing-read "Service name: " '("system_test" "system_test_cleanup" "system_test_performance"))))
    (insert (format "skycap svc:%s:remove_cron" svc)))

(defun skycap-mq-start ()  
      "Insert command to start message queue service"
    (interactive)
    (insert "skycap svc_grp:message_queue_service:start"))

(defun skycap-mq-stop ()  
      "Insert command to stop message queue service"  
    (interactive)
    (insert "skycap svc_grp:message_queue_service:stop"))

(defun skycap-mq-status ()  
      "Insert command to stop message queue service"  
    (interactive)
    (insert (format "skycap svc:rabbitmq:status")))

(defun skycap-mq-initialize ()
      "Insert command to show status of MQ"  
    (interactive)  
    (insert "skycap svc_grp:message_queue_service:mq_initialize"))

(defun skycap-code-update-all ()
      "Insert command to update all code"  
    (interactive)  
    (insert (format "skycap code_update:all")))

(defun skycap-upgrade ()
      "Insert command to upgrade all services except mysql and syslog"  
    (interactive)  
    (insert (format "skycap upgrade")))

(defun skycap-full-stop ()
      "Insert command to stop all services"  
    (interactive)  
    (insert (format "skycap full-stop")))

(defun skycap-start ()
      "Insert command to start all services"  
    (interactive)  
    (insert (format "skycap start")))

;;; -----------------------------
;;; MySQL queries
;;; -----------------------------
(ignore-errors (add-to-list 'load-path "~/.emacs.d/mysql/"))
(ignore-errors (add-to-list 'load-path "~/.emacs.d/sql-completion/"))
(require 'sql-completion)
;; (setq sql-interactive-mode-hook
;;       (lambda ()
;;         (define-key sql-interactive-mode-map "\t" 'comint-dynamic-complete)
;;         (sql-mysql-completion-init)))

(defun mysql-admin-create-db (host user database)  
      "Insert command to create database"  
    (interactive
       (list
	(read-string "host (default: localhost): " nil nil "localhost" nil)
	(read-string "user (default: root): " nil nil "root" nil)
	(read-string "database: ")))
    (insert (format "mysqladmin -u %s -h %s --protocol TCP create %s" user host database)))

(defun mysql-query-account-resources (account-id)  
      "Insert command that queries all resource ids allocated to an account"  
    (interactive "sAccount ID(quota pool id): ")  
    (insert (format "select r.object_key from accounting.resources as r, accounting.quota_pool_charge_tag_map as q where q.quota_pool_id='%s' and r.charge_tag = q.charge_tag;" account-id)))

(defun mysql-query-account-datacenters (account-id)  
      "Insert command that queries all datacenters created for an account"  
    (interactive "sAccount ID: ")  
    (insert (format "select * from greenbox.datacenters natural left join greenbox.resources where account_key = '%s'\\G;" account-id)))

(defun mysql-query-greenbox-messages ()  
      "Insert command that queries pending greenbox messages"  
    (interactive)  
    (insert "select request_reply_seed, action, sent_time, reply_time from greenbox.messages order by message_id desc limit 10\\G;"))

(defun mysql-query-greenbox-configuration-vms (configuration-resource-id)  
      "Insert command that queries vms in a configuratiion"  
    (interactive "nConfiguration resource ID(Number without 'configuration-' prefix): ")  
    (insert (format "select * from greenbox.vms natural left join greenbox.resources where configuration_resource_id=%d \\G;" configuration-resource-id)))

(defun mysql-find-column (database column)
  "Insert command that find column in a database"
  (interactive "sDatabase:\nsColumn:")
  (insert (format "select distinct table_name from information_schema.columns where column_name like '%s' and table_schema='%s';" column database)))

(defun mysql-show-relations ()
  (interactive)
  (insert "select table_schema, table_name, column_name, referenced_table_schema, referenced_table_name, referenced_column_name 
from information_schema.key_column_usage 
where table_schema = schema() -- Detect current scheme in use 
and referenced_table_name is not null -- Only tables with foreign keys 
;")
)

;;;------------------------------
;;; Puppet
;;;------------------------------
(defun puppet-apply-dotfiles ()
  (interactive)
  (insert "puppet apply --modulepath=$HOME/.puppet/modules $HOME/.puppet/manifests/default.pp")
)

;;; -----------------------------
;;; Shells
;;;
;;; Differences between ansi-term and shell mode:
;;;   - shell mode uses dumb terminal. Pager won't work
;;;   - shell mode has built-in tramp support. .bash_profile need to be be modified for remote ansi-term to support tramp.
;;;
;;; so it seems that it's better to use ansi-term to access hosts that I have full control, and to use shell to access hosts
;;; that I don't have full control of.
;;; -----------------------------
;; Use this for remote so I can specify command line arguments
(setq tramp-user-hosts 
      '("mq.container-prototype.bxiao.dev.skytap.com:root:" 
        "agent-manager.container-prototype.bxiao.dev.skytap.com:root:"
        "web-backend.container-prototype.bxiao.dev.skytap.com:root:"
        "container-host.container-prototype.bxiao.dev.skytap.com:skytap:"
        "docker:highland:"
        "puppetmaster:highland:"
        "mq1:highland:"
        "jenga:root:"
        "source.corp.skytap.com:bxiao:"
        "tuk5m1control.mgt.integ.skytap.com:bxiao:"
        "tuk5m1logger2.mgt.integ.skytap.com:bxiao:"
        "puppetmaster.mgt.integ.skytap.com:bxiao:"
        "tuk5m1mysqlcmvip1.mgt.integ.skytap.com:bxiao:"
        "tuk5m1mysqlplvip1.mgt.integ.skytap.com:bxiao:"
        "tuk5r1control.mgt.integ.skytap.com:bxiao:"
        "tuk5r1logger2.mgt.integ.skytap.com:bxiao:"
        "tuk5r1mysqlmm1.mgt.integ.skytap.com:bxiao:"
        "integ.ci.skytap.com:bxiao:"
        "tuk6m1control.mgt.test.skytap.com:bxiao:"
        "tuk6m1logger1.mgt.test.skytap.com:bxiao:"
        "tuk6m1mysqlcmvip1.mgt.test.skytap.com:bxiao:"
        "tuk6m1mysqlhpvip1.mgt.test.skytap.com:bxiao:"
        "tuk6m1mqvip1.mgt.test.skytap.com:bxiao:"
        "tuk6m1logger1.mgt.test.skytap.com:bxiao:"
        "tuk6r1control.mgt.test.skytap.com:bxiao:"
        "tuk6r1logger1.mgt.test.skytap.com:bxiao:"
        "tuk6r1mysqlplvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r1mysqlisvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r1mysqlnsvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r1mqvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r2logger1.mgt.test.skytap.com:bxiao:"
        "tuk6r2mysqlplvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r2mysqlisvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r2mysqlnsvip1.mgt.test.skytap.com:bxiao:"
        "tuk6r2mqvip1.mgt.test.skytap.com:bxiao:"
        "tuk6bi1.mgt.test.skytap.com:bxiao:"
        "lon6r1logger1.mgt.test.skytap.com:bxiao:"
        "lon6r1mysqlplvip1.mgt.test.skytap.com:bxiao:"
        "lon6r1mysqlisvip1.mgt.test.skytap.com:bxiao:"
        "lon6r1mqvip1.mgt.test.skytap.com:bxiao:"
        "puppet.mgt.test.skytap.com:bxiao:"
        "tuk1linjump4.prod.skytap.com:bxiao:"
        "tuk1linjump3.prod.skytap.com:bxiao:"
        "tuk1grits1.prod.skytap.com:bxiao:"
        "tuk1loga1.prod.skytap.com:bxiao:/mnt/logger1archive:"
        ;; "linjump.prod.skytap.com:bxiao:"
        ;; "grits.prod.skytap.com:bxiao:"
        ))

(setq my-commands 
      '("jenga-skip-provisioning\tjenga --base-configuration 6613976 --skip-individual-node-provisioning" 
        "puppet-hosts\tsudo puppetd -ov --no-daemonize --show_diff --tags hosts"
        "docker-remove-all-containers\tdocker rm $(docker ps -a -q)"
        "docker-stop-all-containers\tdocker stop $(docker ps -a -q)"
        "docker-remove-all-images\tdocker rmi $(docker images -q)"
        "docker-build-cm\tdocker build -t cm -f /highland/hosting_platform/dockers/configuration_manager/Dockerfile /highland/hosting_platform/"
        "docker-test-cm\tdocker run -v /highland/configs:/highland/configs -e HIGHLAND_ENV='jenkins-central/unit-tests' -it cm test"
        "docker-debug-cm\tdocker run -v /highland/configs:/highland/configs -v /highland/hosting_platform:/highland/hosting_platform -e HIGHLAND_ENV='jenkins-central/unit-tests' -it cm debug"
        "docker-build-grafana\tdocker build -t grafana -f /highland/grafana/dockers/grafana/Dockerfile /highland/grafana/"
        "docker-test-grafana\tdocker run -v /highland/configs:/highland/configs -e HIGHLAND_ENV='jenkins-central/unit-tests' -it grafana test"
        ))

(setq my-skytap-commands 
      '("mq brokertool\tskytap-cmd mqbrokertool" 
        "mq trace\tskytap-cmd mqtrace"
        "esx list\tskytap-cmd hmcmd esx list"
        "vgr status\tskytap-cmd netcmd vgr status all"
        "cmcmd\tdocker_wrapper.py cmcmd --vcs-tag=tip"
        ))

(defun remote-term-internal (new-buffer-name cmd &rest switches)
  (print switches)
    (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
    (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
    (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
    (set-buffer term-ansi-buffer-name)
    (term-mode)
    (term-char-mode)
    (term-set-escape-char ?\C-c)
    (switch-to-buffer term-ansi-buffer-name))

(defun term-bxiao-puppetmaster (buffer-name)
  "Shell of bxiao cloud puppetmaster"
    (interactive "sBuffer name: bxiao-cloud-puppetmaster-")  
    (remote-term-internal (format "bxiao-cloud-puppetmaster-%s" buffer-name) "ssh" "root@puppetmaster.bxiao.dev.skytap.com"))

(defun remote-shell (user-host)
    (interactive
       (list
   	(completing-read "host user: " tramp-user-hosts)
       ))
    (let ((host (car (split-string user-host ":"))) (user (car (cdr (split-string user-host ":")))) (directory (car (cdr (cdr (split-string user-host ":"))))))
      (eshell-command (format "pushd . & cd /ssh:%s@%s:%s & shell %s & popd" user host directory host))))

(setq tramp-jenga-user-hosts 
      '("puppetmaster root"
        "m1logger1 root"
        "m1control1 root"
        "m1cm1 root"
        "m1wfe1 root"
        "m1mysqlpl1 root"
        "m1mysqlcm1 root"
        "r1control1 root"
        "r1logger1 root"
        "r1nsvc1 root"
        "r1esx1 root"
        "r1mysqlpl1 root"
        "kube-jenkins root"
        "r1nsxmgr1 admin"
        "r1nsxsvc1 admin"
        "r1nsxcontrol1 admin"
        "r1nsxcontrol2 admin"
        "r1nsxcontrol3 admin"
        "m1mq1 root"
        "r1mq1 root"
        "m1influxdb1 root"
        "dev root"
        "m1influxdb1 root"
        ))

(defun remote-shell-jenga (user-host)
    (interactive
       (list
   	(completing-read "host: " tramp-jenga-user-hosts)
       ))
  (let ((host (car (split-string user-host " "))) (user (car (cdr (split-string user-host " ")))))
    (let ((ssh-info (split-string (substring (shell-command-to-string (format "python /highland/projects/skytap/get_jenga_connect_info.py -u %s %s" user host)) 0 -1) ", ")))
      (let ((ip-address (nth 1 ssh-info)))
        (eshell-command (format "pushd . & cd /ssh:%s@%s: & shell jenga-%s & popd" "root" ip-address host))))))

(defun my-shell-command (alias-command)
  "Command shell commands"
    (interactive
       (list
   	(completing-read "alias command: " my-commands)
       ))
    (let ((alias (car (split-string alias-command "\t"))) (command (car (cdr (split-string alias-command "\t")))))
      (insert command)))

(defun my-skytap-command (alias-command)
  "Skytap commands"
    (interactive
       (list
   	(completing-read "alias command: " my-skytap-commands)
       ))
    (let ((alias (car (split-string alias-command "\t"))) (command (car (cdr (split-string alias-command "\t")))))
      (insert command)))


;; (defun shell-docker (buffer-name)
;;   "Shell of docker"
;;     (interactive "sBuffer name: docker-")  
;;     (eshell-command (format "pushd . & cd /ssh:highland@docker: & shell docker-%s & popd" buffer-name)))

(defun remote-term (user-host)
    (interactive
       (list
   	(completing-read "host user: " tramp-user-hosts)
       ))
    (let ((host (car (split-string user-host ":"))) (user (car (cdr (split-string user-host ":")))))
      (remote-term-internal host  "ssh" (format "%s@%s" user host))))

;; (defun remote-term (host)
;;     (interactive
;;        (list
;;    	(completing-read "host: " '("mq.container-prototype.bxiao.dev.skytap.com" "agent-manager.container-prototype.bxiao.dev.skytap.com"))
;;        ))
;;     (let ((user (car (split-string user-host "@"))) (host (car (cdr (split-string user-host "@")))))
;;       (remote-term-internal host  "ssh" (format "%s@%s" user host))))

(defun term-bxiao-mysql (buffer-name)
  "Shell of bxiao cloud mysql"
    (interactive "sBuffer name: bxiao-cloud-mysql-")  
    (remote-term-internal (format "bxiao-cloud-mysql-%s" buffer-name) "ssh" "root@mysql.bxiao.dev.skytap.com"))

(defun shell-bxiao-puppetmaster (buffer-name)
  "Shell of bxiao cloud puppetmaster"
    (interactive "sBuffer name: bxiao-cloud-puppetmaster-")  
    (eshell-command (format "pushd . & cd /ssh:root@puppetmaster.bxiao.dev.skytap.com: & shell bxiao-cloud-puppetmaster-%s & popd" buffer-name)))

(defun shell-bxiao-app (buffer-name)
  "Shell of bxiao cloud app"
    (interactive "sBuffer name: bxiao-cloud-app-")  
    (eshell-command (format "pushd . & cd /ssh:root@app.bxiao.dev.skytap.com: & shell bxiao-cloud-app-%s & popd" buffer-name)))

(defun shell-bxiao-mq (buffer-name)
  "Shell of bxiao cloud mq"
    (interactive "sBuffer name: bxiao-cloud-mq-")  
    (eshell-command (format "pushd . & cd /ssh:root@mq.bxiao.dev.skytap.com: & shell bxiao-cloud-mq-%s & popd" buffer-name)))

(defun shell-bxiao-util1 (buffer-name)
  "Shell of bxiao cloud util1"
    (interactive "sBuffer name: bxiao-cloud-util1-")  
    (eshell-command (format "pushd . & cd /ssh:root@util1.bxiao.dev.skytap.com: & shell bxiao-cloud-util1-%s & popd" buffer-name)))

(defun shell-bxiao-util2 (buffer-name)
  "Shell of bxiao cloud util2"
    (interactive "sBuffer name: bxiao-cloud-util2-")  
    (eshell-command (format "pushd . & cd /ssh:root@util2.bxiao.dev.skytap.com: & shell bxiao-cloud-util2-%s & popd" buffer-name)))

(defun shell-bxiao-sn1 (buffer-name)
  "Shell of bxiao cloud sn"
    (interactive "sBuffer name: bxiao-cloud-sn1-")  
    (eshell-command (format "pushd . & cd /ssh:root@sn.bxiao.dev.skytap.com: & shell bxiao-cloud-sn1-%s & popd" buffer-name)))

(defun shell-bxiao-sn2 (buffer-name)
  "Shell of bxiao cloud sn2"
    (interactive "sBuffer name: bxiao-cloud-sn2-")  
    (eshell-command (format "pushd . & cd /ssh:root@sn2.bxiao.dev.skytap.com: & shell bxiao-cloud-sn2-%s & popd" buffer-name)))

(defun shell-bxiao-mysql (buffer-name)
  "Shell of bxiao cloud mysql"
    (interactive "sBuffer name: bxiao-cloud-mysql-")  
    (eshell-command (format "pushd . & cd /ssh:root@mysql.bxiao.dev.skytap.com: & shell bxiao-cloud-mysql-%s & popd" buffer-name)))

(defun shell-bxiao-mysqlr1 (buffer-name)
  "Shell of bxiao cloud mysqlr1"
    (interactive "sBuffer name: bxiao-cloud-mysqlr1-")  
    (eshell-command (format "pushd . & cd /ssh:root@mysqlr1.bxiao.dev.skytap.com: & shell bxiao-cloud-mysqlr1-%s & popd" buffer-name)))

(defun shell-bxiao-mysqlr2 (buffer-name)
  "Shell of bxiao cloud mysqlr2"
    (interactive "sBuffer name: bxiao-cloud-mysqlr2-")  
    (eshell-command (format "pushd . & cd /ssh:root@mysqlr2.bxiao.dev.skytap.com: & shell bxiao-cloud-mysqlr2-%s & popd" buffer-name)))

(defun term-bxiao-jenkins (buffer-name)
  "Term of bxiao cloud jenkins"
    (interactive "sBuffer name: bxiao-cloud-jenkins-")  
    (remote-term-internal (format "bxiao-cloud-jenkins-%s" buffer-name) "ssh" "root@jenkins.bxiao.dev.skytap.com"))

(defun shell-bxiao-jenkins (buffer-name)
  "Shell of bxiao cloud jenkins"
    (interactive "sBuffer name: bxiao-cloud-jenkins-")  
    (eshell-command (format "pushd . & cd /ssh:root@jenkins.bxiao.dev.skytap.com:/highland/jenkins/jobs/hosting_platform/workspace & shell bxiao-jenkins-%s & popd" buffer-name)))

(defun term-integ-sea5r1 (buffer-name)
  "Term of integ"
    (interactive "sBuffer name: integ-sea5r1-")  
    (remote-term-internal (format "integ-sea5r1-%s" buffer-name) "ssh" "bxiao@sea5r1logger1.mgt.integ.skytap.com"))

(defun term-integ-tuk5r1 (buffer-name)
  "Term of integ"
    (interactive "sBuffer name: integ-tuk5r1")  
    (remote-term-internal (format "integ-tuk5r1-%s" buffer-name) "ssh" "bxiao@tuk5r1logger1.mgt.integ.skytap.com"))

(defun term-puppetmaster (buffer-name)
  "Shell of bxiao cloud puppetmaster"
    (interactive "sBuffer name: puppetmaster-")  
    (remote-term-internal (format "puppetmaster-%s" buffer-name) "ssh" "highland@puppetmaster"))

(defun shell-jenkins (buffer-name)
  "Shell of jenkins"
    (interactive "sBuffer name: jenkins-")  
    (eshell-command (format "pushd . & cd /ssh:highland@jenkins:/highland/jenkins/jobs/hosting_platform/workspace & shell jenkins-%s & popd" buffer-name)))

(defun term-bxiao-jenkins (buffer-name)
  "Term of bxiao cloud jenkins"
    (interactive "sBuffer name: bxiao-jenkins-")  
    (remote-term-internal (format "bxiao-jenkins-%s" buffer-name) "ssh" "root@jenkins"))

(defun shell-jenkins2 (buffer-name)
  "Shell of jenkins2"
    (interactive "sBuffer name: jenkins2-")  
    (eshell-command (format "pushd . & cd /ssh:highland@jenkins2:/highland/jenkins/jobs/hosting_platform_next/workspace & shell jenkins2-%s & popd" buffer-name)))

(defun shell-dev2 (buffer-name)
  "Shell of dev2"
    (interactive "sBuffer name: dev2-")  
    (eshell-command (format "pushd . & cd /ssh:highland@dev2: & shell dev2-%s & popd" buffer-name)))

(defun term-dev2 (buffer-name)
  "Shell of bxiao cloud puppetmaster"
    (interactive "sBuffer name: dev2-")  
    (remote-term-internal (format "dev2-%s" buffer-name) "ssh" "highland@dev2"))

(defun shell-openstack (buffer-name)
  "Shell of openstack"
    (interactive "sBuffer name: openstack-")  
    (eshell-command (format "pushd . & cd /ssh:highland@openstack: & shell openstack-%s & popd" buffer-name)))

(defun accounting-list-account (filter)
  "List accounts that matches given filter"
  (interactive "sFilter:")
  (insert (format "[name for name in AccountingAPI.list_accounts()['result'] if name.startswith('%s')]" filter)))

(defun accounting-release-resource (resource-key resource-type)
  "Release leaked resources allocated to an account"
    (interactive
       (list
        (read-string "Resource key: ")
	(completing-read "Resource type: " '("svms" "vms" "storage_size" "networks" "public_ips"))))
  (insert (format "AccountingAPI.release_resources({'%s': {'resource_types': ['%s']}})" resource-key resource-type)))

(fset 'accounting-create-account
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("AccountingAPI.create_account(account_name='bx-account', environment='bxiao-dev', quotas={'svms.concurrent': 'unlimited', 'svms.cumulative': 'unlimited', 'storage_size.concurrent': 'unlimited', 'networks.concurrent': 'unlimited', 'vms.concurrent': 'unlimited', 'public_ips.concurrent': 'unlimited'})" 0 "%d")) arg)))

(fset 'accounting-delete-account
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("AccountingAPI.delete_account(account_name='bx-account')" 0 "%d")) arg)))

(fset 'accounting-create-charge-tag
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("AccountingAPI.create_charge_tag('bx-account', 'bx-chargetag')" 0 "%d")) arg)))

(fset 'greenbox-create-datacenter
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.create_datacenter('bx-datacenter', 'ConfigurationManager', 'bxiao-dev', 'bx-account')" 0 "%d")) arg)))

(fset 'greenbox-delete-datacenter
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.delete_datacenter('bx-datacenter')" 0 "%d")) arg)))

(defun greenbox-list-datacenters (account)
  "List datacenter of an account"
  (interactive "sAccount:")
  (insert (format "GreenboxAPI.list_datacenters(['%s'])" account)))

(fset 'greenbox-create-depot
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.create_depot('bx-chargetag', 'bx-datacenter', 0, 'scratch', 0)" 0 "%d")) arg)))

(fset 'greenbox-delete-depot
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.delete_depot('account_depot-')" 0 "%d")) arg)))

(fset 'greenbox-merge-configuration
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.merge('bx-chargetag', 'bx-datacenter', 'configuration-11456', [], [], None, 'account_depot-', False, True, target_has_internet_disabled_flag=False)" 0 "%d")) arg)))

(fset 'greenbox-delete-configuration
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.delete_configuration('configuration-')" 0 "%d")) arg)))

(fset 'greenbox-merge-vm
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("GreenboxAPI.merge('bx-chargetag', 'bx-datacenter', 'configuration-', ['configuration-39700'], [], None, 'account_depot-', False, True, target_has_internet_disabled_flag=False)" 0 "%d")) arg)))

(defun mq-write-request-message (service_name action payload region)
  "Send mq request message"
    (interactive
       (list
	(completing-read "Service name: " '("greenbox" "configurationManager" "accounting_service" "charon"))
	(completing-read "Action: " '("destroy_rsync_source_endpoint"))
	(read-string "Payload: ")
	(completing-read "region: " '("integ/tuk5r1"))
       )
    )
  (insert (format "context.mq.write_request_message(service_name='%s', action='%s',payload=%s, region='%s', pre_write_callback=None, fire_and_forget=None)" service_name action payload region)))

(defun mq-wait-for-reply-message (service_name action payload region)
  "Send mq request message and wait for reply"
    (interactive
       (list
	(completing-read "Service name: " '("greenbox" "ConfigurationManager" "accounting_service" "charon"))
	(completing-read "Action: " '("destroy_rsync_source_endpoint"))
	(read-string "Payload: ")
	(completing-read "region: " '("integ/tuk5r1"))
       )
    )
  (insert (format "context.mq.wait_for_reply_message(service_name='%s', action='%s',payload=%s, region='%s', pre_write_callback=None, timeout=None)" service_name action payload region)))

(fset 'systemtest-cleanup
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("/opt/skytap/bin/skytap-cmd system_test_cleanup" 0 "%d")) arg)))

(fset 'systemtest-install
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("skycap svc:system_test:install_cron" 0 "%d")) arg)))

(fset 'systemtest-remove
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("skycap svc:system_test:remove_cron" 0 "%d")) arg)))

(fset 'systemtest-status
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("skycap svc:system_test:cron_status" 0 "%d")) arg)))

;;; ------------------------------
;;; hg shortcuts
;;; ------------------------------

(fset 'hg-serve
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg serve -A /highland/logs/hgserve.log -d -E /highland/logs/hgserve.log" 0 "%d")) arg)))

(fset 'hg-pull-all-bxiao
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -R /highland/configs bxiaohg pull -R /highland/hosting_platform bxiaohg pull -R /highland/packages bxiaohg pull -R /highland/service_control bxiaohg pull -R /highland/skytap-support bxiaohg pull -R /highland/statsd bxiaohg pull -R /highland/docs bxiao" 0 "%d")) arg)))

(fset 'prod-skygrep
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("skygrep -U http://10.8.16.135:9210/")) arg)))


(fset 'hg-pull-all-next
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -R /highland/configs r_nexthg pull -R /highland/hosting_platform r_nexthg pull -R /highland/agent_services r_nexthg pull -R /highland/nexus r_nexthg pull -R /highland/packages r_nexthg pull -R /highland/service_control r_nexthg pull -R /highland/skytap-support r_nexthg pull -R /highland/statsd r_nexthg pull -R /highland/docs r_next" 0 "%d")) arg)))

(fset 'hg-pull-all-integ
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -R /highland/configs integhg pull -R /highland/hosting_platform integhg pull -R /highland/agent_services integhg pull -R /highland/nexus integhg pull -R /highland/packages integhg pull -R /highland/service_control integhg pull -R /highland/skytap-support integhg pull -R /highland/statsd integhg pull -R /highland/docs integ" 0 "%d")) arg)))

;; (defun hg-pull-all ()
;;   (interactive)
;;   (insert "for d in *\/; do ")
;;   (insert "hg pull -R \"$d\"; ")
;;   (insert "done")
;;   )

(defun hg-pull-all ()
  (interactive)
  (insert "for d in *\/; do ")
  (insert "if [ $d != \"config/\" ] && [ $d != \"configs/\" ]; then hg pull -R \"$d\"; fi; ")
  (insert "done")
  )
(defun hg-pull-all-r (release)
  (interactive
     (list
      (read-number "Release: r")))
  (insert "for dir in *\/; do ")
  (insert (format "hg pull -R \"$dir\" ssh://bxiao@source.corp.skytap.com//hg/r%d/\"$dir\"; " release))
  (insert "done")
  )
   ;; (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -R /highland/configshg pull -R /highland/hosting_platformhg pull -R /highland/packageshg pull -R /highland/service_controlhg pull -R /highland/skytap-supporthg pull -R /highland/statsdhg pull -R /highland/docs" 0 "%d")) arg)))

(defun hg-clone-all (release)
  (interactive "nRelease: r")
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/configs; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/hosting_platform; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/agent_services; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/nexus; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/service_control; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/skytap-support; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/statsd; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/ui_layer; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/ui_nodejs; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/web; \\\n" release))
  (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/docs; \\\n" release)))

(defun hg-clone-all-puppet ()
  (interactive)
  (insert (format "hg clone ssh://highland@puppetmaster//highland/configs; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/hosting_platform; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/agent_services; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/nexus; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/service_control; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/skytap-support; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/statsd; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/ui_layer; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/ui_nodejs; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/web; \\\n"))
  (insert (format "hg clone ssh://highland@puppetmaster//highland/docs; \\\n")))

(defun hg-clone-r (release repo)
    (interactive
       (list
        (read-number "Release: r")
	(completing-read "Repo: " '("configs" "hosting_platform" "packages" "service_control" "skytap_support"))))
    (insert (format "hg clone ssh://bxiao@source.corp.skytap.com//hg/r%d/%s\n" release repo)))

;; (defun hg-pull-all-r (release root)
;;   (interactive
;;      (list
;;       (read-number "Release: r")
;;       (completing-read "Root: " '("/hg" "/highland"))))
;;   (insert (format "hg pull -R %s/configs ssh://bxiao@source.corp.skytap.com//hg/r%d/configs; \\\n" root release))
;;   (insert (format "hg pull -R %s/hosting_platform ssh://bxiao@source.corp.skytap.com//hg/r%d/hosting_platform; \\\n" root release))
;;   (insert (format "hg pull -R %s/packages ssh://bxiao@source.corp.skytap.com//hg/r%d/packages; \\\n" root release))
;;   (insert (format "hg pull -R %s/service_control ssh://bxiao@source.corp.skytap.com//hg/r%d/service_control; \\\n" root release))
;;   (insert (format "hg pull -R %s/skytap-support ssh://bxiao@source.corp.skytap.com//hg/r%d/skytap-support; \\\n" root release))
;;   (insert (format "hg pull -R %s/statsd ssh://bxiao@source.corp.skytap.com//hg/r%d/statsd; \\\n" root release))
;;   (insert (format "hg pull -R %s/ui_layer ssh://bxiao@source.corp.skytap.com//hg/r%d/ui_layer; \\\n" root release))
;;   (insert (format "hg pull -R %s/ui_nodejs ssh://bxiao@source.corp.skytap.com//hg/r%d/ui_nodejs; \\\n" root release))
;;   (insert (format "hg pull -R %s/web ssh://bxiao@source.corp.skytap.com//hg/r%d/web; \\\n" root release))
;;   (insert (format "hg pull -R %s/statsd ssh://bxiao@source.corp.skytap.com//hg/r%d/docs; \\\n" root release)))

(defun hg-pull-all-containers-project (root)
  (interactive
     (list
      (completing-read "Root: " '("/hg" "/highland"))))
  (insert (format "hg pull -R %s/configs ssh://bxiao@source.corp.skytap.com//hg/containers_project/configs; \\\n" root))
  (insert (format "hg pull -R %s/hosting_platform ssh://bxiao@source.corp.skytap.com//hg/containers_project/hosting_platform; \\\n" root))
  (insert (format "hg pull -R %s/packages ssh://bxiao@source.corp.skytap.com//hg/containers_project/packages; \\\n" root))
  (insert (format "hg pull -R %s/service_control ssh://bxiao@source.corp.skytap.com//hg/containers_project/service_control; \\\n" root))
  (insert (format "hg pull -R %s/skytap-support ssh://bxiao@source.corp.skytap.com//hg/containers_project/skytap-support; \\\n" root))
  (insert (format "hg pull -R %s/statsd ssh://bxiao@source.corp.skytap.com//hg/containers_project/statsd; \\\n" root))
  (insert (format "hg pull -R %s/ui_layer ssh://bxiao@source.corp.skytap.com//hg/containers_project/ui_layer; \\\n" root))
  (insert (format "hg pull -R %s/ui_nodejs ssh://bxiao@source.corp.skytap.com//hg/containers_project/ui_nodejs; \\\n" root))
  (insert (format "hg pull -R %s/web ssh://bxiao@source.corp.skytap.com//hg/containers_project/web; \\\n" root))
  (insert (format "hg pull -R %s/statsd ssh://bxiao@source.corp.skytap.com//hg/containers_project/docs; \\\n" root)))

(defun hg-push-r (release repo)
    (interactive
       (list
        (read-number "Release: r")
	(completing-read "Repo: " '("configs" "hosting_platform" "packages" "service_control" "skytap_support"))))
    (insert (format "hg push ssh://bxiao@source.corp.skytap.com//hg/r%d/%s\n" release repo)))

(defun hg-out-r (release repo)
    (interactive
       (list
        (read-number "Release: r")
	(completing-read "Repo: " '("configs" "hosting_platform" "packages" "service_control" "skytap_support"))))
    (insert (format "hg out ssh://bxiao@source.corp.skytap.com//hg/r%d/%s\n" release repo)))

(defun hg-in-r (release repo)
    (interactive
       (list
        (read-number "Release: r")
	(completing-read "Repo: " '("configs" "hosting_platform" "packages" "service_control" "skytap_support"))))
    (insert (format "hg in ssh://bxiao@source.corp.skytap.com//hg/r%d/%s\n" release repo)))

(defun hg-qtip-to-pending ()
  (interactive)
  (insert "hg qfinish qtip\n")
  (insert "hg strip -k tip\n"))

(defun hg-diff (revision)
  (interactive "nRevision: ")
    (eshell-command (format "async-shell-command \"hg diff --change %s | tee /dev/null \" \"hg diff -change %s\"" revision revision)))

(defun hg-log (args)
  (interactive "sArgs: ")
    (eshell-command (format "async-shell-command \"hg log %s | tee /dev/null \" \"hg log %s\"" args args)))

(defun use-hpl ()
  (interactive)
  (insert (format "cp /highland/bxiao-dev/hosting_platform/hosting_platform/common/monitoring/__hpl_init__.py ~/hosting_platform/hosting_platform/common/monitoring/__init__.py\n"))
  (insert (format "cp /highland/bxiao-dev/hosting_platform/hosting_platform/common/monitoring/unit_tests/__hpl_init__.py ~/hosting_platform/hosting_platform/common/monitoring/unit_tests/__init__.py\n")))

(defun unuse-hpl ()
  (interactive)
  (insert (format "hg revert ~/hosting_platform/hosting_platform/common/monitoring/__init__.py\n"))
  (insert (format "hg revert ~/hosting_platform/hosting_platform/common/monitoring/unit_tests/__init__.py\n")))

(defun skygrep (buffer-name arguments)
  (interactive "sBuffer Name:\nsArguments: ")
    (eshell-command (format "async-shell-command \"skygrep %s \" \"%s\"" arguments buffer-name)))
(global-set-key [f8] 'skygrep)

(defun cmcmd-list-services ()
  "List services registered in cm"
  (interactive)
  (insert (format "cmcmd.list_services()")))

(defun cmcmd-register-storage-service (host region)
  "Register storage service in cmcmd"
  (interactive "sHost:\nsRegion:")
  (insert (format "cmcmd.register('storage_service', '%s', '', 9020, None, '%s')" host region)))

(defun cmcmd-get-storage-service (host)
  "Get storage service in cmcmd"
  (interactive "sHost:")
  (insert (format "get_api('%s', 9020)" host)))

(defun cmcmd-cm (env)
  "Get configuration manager service in cmcmd"
    (interactive
       (list
        (completing-read "env:" '("integ" "localhost"))
        ))
    (cond ((equal env "integ") 
           (setq host "tuk5m1cmvip1") 
           (setq port 9000))
          (t
           (setq host "localhost") 
           (setq port 30000)))
    (insert (format "api=get_api('%s', %d)\n" host port))
    (insert "api.isNodeUp()"))

(defun cmcmd-api-logger (host)
  "Get api logger"
  (interactive)
  (insert "LOGGER = initialize_logger('api')"))

(defun cmcmd-get-operation (operation-model operation-id)
  "Get operation"
    (interactive
       (list
	(completing-read "Operation model: " '("Operation" "ImportOperationModel"))
        (read-string "Operation id: ")))
  (insert "with transaction() as tx:\n")
  (insert (format "    __o__=tx.query(%s).filter(%s.operation_id==%s).one()\n" operation-model operation-model operation-id)))

(defun cmcmd-release-exclusion (keys)
  (interactive "sKeys:")
  (insert (format "keys=%s" keys))
  (insert "api.release_exclusion(keys)"))

(defun cmcmd-release-configuration-vm-exclusion-by-operation (operation reason)
  (interactive "sOperation variable(__o__)\nsReason:")
  (insert "from hosting_platform.common.errors import InternalError\n")
  (insert "with transaction() as tx:\n")
  (insert (format "    tx.add(%s)\n" operation))
  (insert (format "    for configuration in %s.configuration_exclusions:\n" operation))
  (insert (format "        for vm in configuration.vms:\n"))
  (insert (format "            vm.operation = None\n"))
  (insert (format "    configuration.operation = None\n"))
  (insert (format "    %s.error = InternalError('%s').error\n" operation reason)))

(defun cmcmd-release-vms-exclusion-raw (operation vm_keys reason)
  (interactive "sOperation variable(__o__)\nsVM keys:\nsReason:")
  (insert "from hosting_platform.common.errors import InternalError\n")
  (insert "with transaction() as tx:\n")
  (insert (format "    tx.add(%s)\n" operation))
  (insert (format "    vms=VM.lookup_multiple(%s, tx)\n" vm_keys))
  (insert "    for vm in vms:\n")
  (insert (format "        if vm.operation.key==__o__.key:\n" operation))
  (insert (format "            vm.operation = None\n" operation))
  (insert (format "    %s.error = InternalError('%s').error\n" operation reason)))

(defun cmcmd-release-networks-exclusion-raw (operation network_keys reason)
  (interactive "sOperation variable(__o__)\nsNetwork keys:\nsReason:")
  (insert "from hosting_platform.common.errors import InternalError\n")
  (insert "with transaction() as tx:\n")
  (insert (format "    tx.add(%s)\n" operation))
  (insert (format "    networks=Network.lookup_multiple(%s, tx)\n" network_keys))
  (insert "    for network in networks:\n")
  (insert (format "        if network.operation.key==__o__.key:\n" operation))
  (insert (format "            network.operation = None\n" operation))
  (insert (format "    %s.error = InternalError('%s').error\n" operation reason)))


;;;---------------------
;;; Linux commands
;;;--------------------
(fset 'check-disk
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("dmesg | grep \"EXT4-fs\"" 0 "%d")) arg)))

(defun du (pattern)
  "Sort du output"
  (interactive "sFile pattern: ")
  (insert (format "du -s %s 2>/dev/null| sort -nr | cut -f2- | xargs du -hs 2>/dev/null" pattern)))

(defun find-and-delete-old-files (directory pattern days)
  "Find and delete old files"
  (interactive "sDirectory: \nsFile pattern: \nnOlder than (days): ")
  (insert (format "find %s -mtime +%d -name '%s' -exec rm {} \\;" directory days pattern)))

(defun kube-cm-bash (pod)
  "Get bash shell of a kube_cm pod"
  (interactive "sPod: ")
  (insert (format "kubectl.sh --namespace=configuration-manager exec -it %s /bin/bash" pod)))

(defun kube-cm-list-terminating ()
  "List kube_cm pods that are terminating"
  (interactive)
  (insert "kubectl.sh -n configuration-manager get pod -o wide | grep Terminating"))

(defun kube-cm-cpu-usage (pod)
  "Get CPU usage of cm process on a given pod"
  (interactive "sPod: ")
  (insert (format "kubectl.sh --namespace=configuration-manager exec -it %s ps waux | awk '$8 !~ /Ss/ && /[h]osting_platform/ {print $3}' | uniq" pod)))

;;;----------------------
;;; Log analyze commands
;;;---------------------
(defun log-search (file-pattern string-pattern)
  (interactive "sFile pattern: \nsString pattern:")
  (insert (format "for f in %s; do if gunzip -c $f|grep -q %s; then echo $f; fi; done" file-pattern string-pattern)))

(defun log-hide-transaction-started ()
  (interactive)
  (hide-lines-matching "transaction [0123456789]+ started")
)

(defun log-hide-transaction-committed ()
  (interactive)
  (hide-lines-matching "transaction [0123456789]+ committed")
)

(defun log-hide-get-vm-ephemera ()
  (interactive)
  (hide-lines-matching "request.get_vm_ephemera")
  (hide-lines-matching "\"action\": \"get_vm_ephemera\"")
)

(defun log-hide-get-configuration-ephemera ()
  (interactive)
  (hide-lines-matching "request.get_configuration_ephemera")
  (hide-lines-matching "\"action\": \"get_configuration_ephemera\"")
)

(defun log-hide-get-configuration-specification ()
  (interactive)
  (hide-lines-matching "request.get_configuration_specification")
  (hide-lines-matching "\"action\": \"get_configuration_specification\"")
)

(defun log-get-api-times (file-pattern api-name count)
    (interactive
       (list
        (read-string "Log file pattern: ")
	(completing-read "api name: " '("get_configuration_specification"))
        (read-number "Count: ")))
    (insert (format "for f in %s ; do zcat $f | awk '/%s RETURN/{print $11, $0}' | sort -k 1 -nr | awk 'NR<=%d{print}'; done | sort -k 1 -nr | awk 'NR<=%d{print}'" file-pattern api-name count count)))
(put 'scroll-left 'disabled nil)

(defun find-file-skycap-release (release)
  (interactive "nRelease: r")
  (find-file (format "//highland/service_control/service_groups/r%d_release/skycap_file.rb" release)))

;;;Turn tabs into spaces
(setq-default indent-tabs-mode nil)

;;;Alias
(defalias 'cpx 'copy-to-x-clipboard)
(defalias 'rb 'revert-buffer)
(defalias 'rs 'remote-shell)
(defalias 'ffr 'find-file-skycap-release)

;; C-M-% is impossible for me
(defalias 'qrr 'query-replace-regexp)

(setq org-capture-templates
      (quote (
              ("l" "link" plain (file (lambda () (expand-file-name "~/notes/exclusion.org")))
               "%a")
              )))

(require 'docker-tramp)
