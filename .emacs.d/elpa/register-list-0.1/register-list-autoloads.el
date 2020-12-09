;;; register-list-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "register-list" "register-list.el" (0 0 0 0))
;;; Generated autoloads from register-list.el

(autoload 'register-list "register-list" "\
Display a list of registers.
An optional argument TYPE defines a regexp to restrict the
register menu to.  A second optional argument FONTIFICATION
decides if the display preserves original fontification for
values.

The default types are defined in `register-list-default-types',
which see.

The list is displayed in a buffer named `*Register List*' in
`register-list-mode', which see.

\(fn &optional TYPE FONTIFY)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "register-list" '("register-list-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; register-list-autoloads.el ends here
