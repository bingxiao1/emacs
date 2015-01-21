;; Add MELPA to package archive list
(when (> emacs-major-version 23)
    (require 'package)
    (package-initialize)
    (add-to-list 'package-archives 
                 '("melpa" . "http://melpa.milkbox.net/packages/")
                 'APPEND))


(defun reload ()
  (interactive)
  (load-file "~/.emacs"))

;;; Cache password for tramp remote sessions
(setq password-cache-expiry nil)

;;; Turn on tramp debugging
(setq tramp-verbose 10)

(defun prev-window ()
   (interactive)
   (other-window -1))

(define-key global-map (kbd "C-x p") 'prev-window)

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

(global-set-key [f3] 'eshell)

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

(defalias 'cpx 'copy-to-x-clipboard)
(defalias 'rb 'revert-buffer)

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

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.github.com/dimitri/el-get/master/el-get-install.el")
    (let (el-get-master-branch)
      (goto-char (point-max))
      (eval-print-last-sexp))))
(el-get 'sync)


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
 '(jira-url "https://jira.corp.skytap.com/rpc/xmlrpc")
 '(menu-bar-mode nil)
 '(python-remove-cwd-from-path nil)
 '(safe-local-variable-values (quote ((prompt-to-byte-compile))))
 '(uniquify-buffer-name-style (quote forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; To allow mysql mode to accept blank password
(setq sql-user "root")
(setq sql-password nil)


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

(define-key python-mode-map (kbd "<f5>") 'python-insert-breakpoint)

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

(defun python-interactive ()
    "Enter the interactive Python environment"
    (interactive)
    (progn
      (insert "!import code; code.interact(local=vars())")
      (move-end-of-line 1)
      (comint-send-input)))
  
  (global-set-key (kbd "C-c i") 'python-interactive)

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

;; C-M-% is impossible for me
(defalias 'qrr 'query-replace-regexp)

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


(require 'hide-lines)

(add-to-list 'load-path "~/.emacs.d/shell-command/")
(require 'shell-command)
(shell-command-completion-mode)

;;; ------------------------------
;;; Enable bash completion in shell mode (depends on shell-command.el)
;;; BX: Does not appear to be working 
;;; ------------------------------
;; (ignore-errors (add-to-list 'load-path "~/.emacs.d/emacs-bash-completion/"))
;; (ignore-errors (require 'bash-completion))
;; (ignore-errors (bash-completion-setup))
(add-to-list 'load-path "~/.emacs.d/emacs-bash-completion/")
(require 'bash-completion)
(bash-completion-setup)


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
(defun remote-term (new-buffer-name cmd &rest switches)
  (print switches)
    (setq term-ansi-buffer-name (concat "*" new-buffer-name "*"))
    (setq term-ansi-buffer-name (generate-new-buffer-name term-ansi-buffer-name))
    (setq term-ansi-buffer-name (apply 'make-term term-ansi-buffer-name cmd nil switches))
    (set-buffer term-ansi-buffer-name)
    (term-mode)
    (term-char-mode)
    (term-set-escape-char ?\C-x)
    (switch-to-buffer term-ansi-buffer-name))

(defun term-bxiao-puppetmaster (buffer-name)
  "Shell of bxiao cloud puppetmaster"
    (interactive "sBuffer name: bxiao-cloud-puppetmaster-")  
    (remote-term (format "bxiao-cloud-puppetmaster-%s" buffer-name) "ssh" "root@puppetmaster.bxiao.dev.skytap.com"))

(defun term-bxiao-mysql (buffer-name)
  "Shell of bxiao cloud mysql"
    (interactive "sBuffer name: bxiao-cloud-mysql-")  
    (remote-term (format "bxiao-cloud-mysql-%s" buffer-name) "ssh" "root@mysql.bxiao.dev.skytap.com"))

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
    (remote-term (format "bxiao-cloud-jenkins-%s" buffer-name) "ssh" "root@jenkins.bxiao.dev.skytap.com"))

(defun shell-bxiao-jenkins (buffer-name)
  "Shell of bxiao cloud jenkins"
    (interactive "sBuffer name: bxiao-cloud-jenkins-")  
    (eshell-command (format "pushd . & cd /ssh:root@jenkins.bxiao.dev.skytap.com:/highland/jenkins/jobs/hosting_platform/workspace & shell bxiao-jenkins-%s & popd" buffer-name)))

(defun shell-integ (buffer-name)
  "Shell of integ"
    (interactive "sBuffer name: integ-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@sea5m1logger1.mgt.integ.skytap.com: & shell integ-%s & popd" buffer-name)))

(defun term-integ (buffer-name)
  "Term of integ"
    (interactive "sBuffer name: integ-")  
    (remote-term (format "integ-%s" buffer-name) "ssh" "bxiao@sea5m1logger1.mgt.integ.skytap.com"))

(defun shell-integ-puppetmaster()
  "Shell of integ puppetmaster"
    (interactive)  
    (eshell-command "pushd . & /ssh:bxiao@puppetmaster.mgt.integ.skytap.com: & shell integ-puppetmaster & popd"))

(defun shell-integ-mysql()
  "Shell of integ my sql"
    (interactive)  
    (eshell-command "pushd . & /ssh:bxiao@sea5m1mysql5.mgt.integ.skytap.com: & shell integ-mysql & popd"))

(defun shell-integ-sea5r1 (buffer-name)
  "Shell of integ"
    (interactive "sBuffer name: integ-sea5r1-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@sea5r1logger1.mgt.integ.skytap.com: & shell integ-sea5r1-%s & popd" buffer-name)))

(defun term-integ-sea5r1 (buffer-name)
  "Term of integ"
    (interactive "sBuffer name: integ-sea5r1-")  
    (remote-term (format "integ-sea5r1-%s" buffer-name) "ssh" "bxiao@sea5r1logger1.mgt.integ.skytap.com"))

(defun shell-integ-sea5r1-mysql (buffer-name)
  "Shell of integ"
    (interactive "sBuffer name: integ-sea5r1-mysql-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@sea5r1mysqlmm1.mgt.integ.skytap.com: & shell integ-sea5r1-mysql-%s & popd" buffer-name)))

(defun shell-integ-tuk5r1 (buffer-name)
  "Shell of integ"
    (interactive "sBuffer name: integ-tuk5r1-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@tuk5r1logger1.mgt.integ.skytap.com: & shell integ-tuk5r1-%s & popd" buffer-name)))

(defun term-integ-tuk5r1 (buffer-name)
  "Term of integ"
    (interactive "sBuffer name: integ-tuk5r1")  
    (remote-term (format "integ-tuk5r1-%s" buffer-name) "ssh" "bxiao@tuk5r1logger1.mgt.integ.skytap.com"))

(defun shell-integ-tuk5r1-mysql (buffer-name)
  "Shell of integ"
    (interactive "sBuffer name: integ-tuk5r1-mysql-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@tuk5r1mysqlmm1.mgt.integ.skytap.com: & shell integ-tuk5r1-mysql-%s & popd" buffer-name)))

(defun shell-integ-jenkins (buffer-name)
  "Shell of integ"
    (interactive "sBuffer name: integ-jenkins-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@integ.ci.skytap.com:/ & shell integ-jenkins-%s & popd" buffer-name)))

(defun shell-test (buffer-name)
  "Shell of test"
    (interactive "sBuffer name: test-")  
    (eshell-command (format "pushd . & cd /ssh:root@tuk6m1logger1.mgt.test.skytap.com: & shell test-%s & popd" buffer-name)))

(defun shell-test-mysql()
  "Shell of integ my sql"
    (interactive)  
    (eshell-command "pushd . & cd /ssh:root@tuk6m1mysqlplvip1.mgt.test.skytap.com: & shell test-mysql & popd"))

(defun term-puppetmaster (buffer-name)
  "Shell of bxiao cloud puppetmaster"
    (interactive "sBuffer name: puppetmaster-")  
    (remote-term (format "puppetmaster-%s" buffer-name) "ssh" "highland@puppetmaster"))

(defun shell-puppetmaster (buffer-name)
  "Shell of puppermaster"
    (interactive "sBuffer name: puppetmaster-")  
    (eshell-command (format "pushd . & cd /ssh:highland@puppetmaster: & shell puppetmaster-%s & popd" buffer-name)))

(defun shell-mq (buffer-name)
  "Shell of mq"
    (interactive "sBuffer name: mq-")  
    (eshell-command (format "pushd . & cd /ssh:highland@mq1: & shell mq-%s & popd" buffer-name)))

(defun shell-jenkins (buffer-name)
  "Shell of jenkins"
    (interactive "sBuffer name: jenkins-")  
    (eshell-command (format "pushd . & cd /ssh:highland@jenkins:/highland/jenkins/jobs/hosting_platform/workspace & shell jenkins-%s & popd" buffer-name)))

(defun term-bxiao-jenkins (buffer-name)
  "Term of bxiao cloud jenkins"
    (interactive "sBuffer name: bxiao-jenkins-")  
    (remote-term (format "bxiao-jenkins-%s" buffer-name) "ssh" "root@jenkins"))

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
    (remote-term (format "dev2-%s" buffer-name) "ssh" "highland@dev2"))

(defun shell-svn (buffer-name)
  "Shell of svn"
    (interactive "sBuffer name: svn-")  
    (eshell-command (format "pushd . & cd /ssh:bxiao@svn.internal.illumita.com: & shell svn-%s & popd" buffer-name)))


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
	(completing-read "Service name: " '("charon"))
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
	(completing-read "Service name: " '("charon"))
	(completing-read "Action: " '("destroy_rsync_source_endpoint"))
	(read-string "Payload: ")
	(completing-read "region: " '("integ/tuk5r1"))
       )
    )
  (insert (format "context.mq.wait_for_reply_message(service_name='%s', action='%s',payload=%s, region='%s', pre_write_callback=None, timeout=None)" service_name action payload region)))

(defun mq-brokertool ()
  (interactive)
  (insert "/opt/skytap/bin/skytap-cmd mqbrokertool"))

(defun mq-trace ()
  (interactive)
  (insert "/opt/skytap/bin/skytap-cmd mqtrace"))

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

(fset 'hg-pull-all
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -u -R /highland/configshg pull -u -R /highland/hosting_platformhg pull -u -R /highland/packageshg pull -u -R /highland/service_controlhg pull -u -R /highland/skytap-supporthg pull -u -R /highland/statsdhg pull -u -R /highland/docs" 0 "%d")) arg)))

(fset 'hg-pull-all-bxiao
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -u -R /highland/configs bxiaohg pull -u -R /highland/hosting_platform bxiaohg pull -u -R /highland/packages bxiaohg pull -u -R /highland/service_control bxiaohg pull -u -R /highland/skytap-support bxiaohg pull -u -R /highland/statsd bxiaohg pull -u -R /highland/docs bxiao" 0 "%d")) arg)))

(fset 'hg-pull-all-next
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -u -R /highland/configs r_nexthg pull -u -R /highland/hosting_platform r_nexthg pull -u -R /highland/packages r_nexthg pull -u -R /highland/service_control r_nexthg pull -u -R /highland/skytap-support r_nexthg pull -u -R /highland/statsd r_nexthg pull -u -R /highland/docs r_next" 0 "%d")) arg)))

(fset 'hg-pull-all-integ
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("hg pull -u -R /highland/configs integhg pull -u -R /highland/hosting_platform integhg pull -u -R /highland/packages integhg pull -u -R /highland/service_control integhg pull -u -R /highland/skytap-support integhg pull -u -R /highland/statsd integhg pull -u -R /highland/docs integ" 0 "%d")) arg)))

(defun hg-clone-all (release)
  (interactive "nRelease: r")
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/configs\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/hosting_platform\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/service_control\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/skytap-support\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/statsd\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/ui_layer\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/ui_nodejs\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/web\n" release))
  (insert (format "hg clone ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/docs\n" release)))

(defun hg-pull-all-r (release)
  (interactive "nRelease: r")
  (insert (format "hg pull -u -R /highland/configs ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/configs\n" release))
  (insert (format "hg pull -u -R /highland/hosting_platform ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/hosting_platform\n" release))
  (insert (format "hg pull -u -R /highland/packages ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/packages\n" release))
  (insert (format "hg pull -u -R /highland/service_control ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/service_control\n" release))
  (insert (format "hg pull -u -R /highland/skytap-support ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/skytap-support\n" release))
  (insert (format "hg pull -u -R /highland/statsd ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/statsd\n" release))
  (insert (format "hg pull -u -R /highland/statsd ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/docs\n" release)))

(defun hg-push-r (release repo)
    (interactive
       (list
        (read-number "Release: r")
	(completing-read "Repo: " '("configs" "hosting_platform" "packages" "service_control" "skytap_support"))))
    (insert (format "hg push ssh://bxiao@sea9repo1.corp.skytap.com//hg/r%d/%s\n" release repo)))


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

(defun cmcmd-cm (host)
  "Get configuration manager service in cmcmd"
  (interactive "sHost:")
  (insert (format "api=get_api('%s', 30000)\n" host))
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

(defun strgcmd-remove-all-node-affinity (host)
  "Remove all node affinities"
  (interactive "sHost:")
  (insert (format "skytap-cmd strgcmd remnodeaffinity %s" host)))

(defun strgcmd-add-affinity (affinity)
  "Add affinity"
    (interactive
       (list
	(completing-read "affinity: " '("root_depots" "scratch" "asset" "userupload"))))
  (insert (format "skytap-cmd strgcmd addaffinity %s '%s depots'" affinity affinity)))

(defun strgcmd-set-node-affinity (affinity host)
  "Set node affinity"
    (interactive
       (list
	(completing-read "affinity: " '("root_depots" "scratch" "asset" "userupload"))
        (read-string "host: ")))
  (insert (format "skytap-cmd strgcmd setnodeaffinity %s %s" affinity host)))

(defun strgcmd-create (name affinity)
  "Create depot"
    (interactive
       "sName:\nsAddinity:\nnAllocation:")
  (insert (format "skytap-cmd strgcmd create test %s %s 0 0" name affinity)))

(defun strgcmd-mountctx (guid)
  "Mount a depot"
    (interactive
       "sGUID:")
  (insert (format "skytap-cmd strgcmd mountctx %s" guid)))

(defun hmcmd-list-esx ()
  "List ESX nodes"
  (interactive)
  (insert (format "skytap-cmd hmcmd esx list")))


;;;---------------------
;;; Linux commands
;;;--------------------
(fset 'check-disk
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("dmesg | grep \"EXT4-fs\"" 0 "%d")) arg)))

(defun du (pattern)
  "Sort du output"
  (interactive "sFile pattern: ")
  (insert (format "du -s %s 2>/dev/null| sort -nr | cut -f2- | xargs du -hs 2>/dev/null" pattern)))

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

(defun log-get-api-times (file-pattern api-name count)
    (interactive
       (list
        (read-string "Log file pattern: ")
	(completing-read "api name: " '("get_configuration_specification"))
        (read-number "Count: ")))
    (insert (format "for f in %s ; do zcat $f | awk '/%s RETURN/{print $11, $0}' | sort -k 1 -nr | awk 'NR<=%d{print}'; done | sort -k 1 -nr | awk 'NR<=%d{print}'" file-pattern api-name count count)))
(put 'scroll-left 'disabled nil)
