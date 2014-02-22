;;; ansi-lpr.el --- Print to the local printer of a VT100 or ANSI
;;; terminal

;; Copyright (C) 2005  Free Software Foundation, Inc.

;; Author: Matthias MEULIEN by <address@hidden>
;; Keywords: terminals, wp

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This library allows printing to the local printer of a VT100 or
;; ANSI terminal. The idea is stollen from the C program written by
;; Gary Day.

;; First, you need to set the variable `print-region-function' like
;; the following: 

;; (load-library "ansi-lpr")
;; (setq print-region-function 'ansi-print-region)
;; (setq lpr-command nil
;;       lpr-add-switches nil
;;       lpr-headers-switches nil
;;       lpr-printer-switch nil)

;; Then print using the usual `print-buffer' or `print-region'
;; commands.

;; To do: find the escape sequence to print to a local file

;;; Code:

(provide 'ansi-lpr)

(defvar ansi-printer-on "\e[?5i"
  "Escape sequence saying \"printer on\" to the printer attached to a
VT100 or ANSI terminal.")

(defvar ansi-printer-off "\e[?4i"
  "Escape sequence saying \"printer off\" to the printer attached to a
VT100 or ANSI terminal.")

(defun ansi-print-region (start end nul1 nul2 switches page-headers)
  "Function to print the region using the local printer of a VT100 or
ANSI terminal. See `print-region-function'."
  (let ((string (buffer-substring start end)))
    (with-temp-buffer
      (insert (concat page-headers "\n" string " "))
      (printify-region (point-min) (point-max))
      (goto-char (point-min))
      (while (re-search-forward "[\n]" (point-max) t)
        (insert "
"))
      (send-string-to-terminal 
       (concat ansi-printer-on
               (buffer-substring (point-min) (point-max))
               ansi-printer-off))))
  (redraw-display))

;;; ansi-lpr.el ends here

