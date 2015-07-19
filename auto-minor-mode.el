;;; auto-minor-mode.el --- Provides an alist variable to allow the automatic
;;               activation of multiple minor modes according to a
;;               filename extension pattern
;;
;; Author: R. Galacho <rgalacho@gmail.com>
;; Created: 19 Jul 2015
;; Version: 1.0
;; Url: https://github.com/RGalacho/auto-minor-mode
;; Keywords: tools
;;
;; Copyright:
;; Original version copyright (c) by R. Galacho 2015 jul
;;
;;; Comment:
;; This file provides the global alist variable `auto-minor-mode-alist' to activate multiple minor modes according to a filename extension pattern.
;;
;; Heavily based and inspiring on Trey Jackson's solution over StackOverflow
;; (see@http://stackoverflow.com/a/13946304)
;;
;;
;;; Instalation:
;; Copy this file into your load-path and add this line to your .emacs
;; configuration file:
;; (load "<load-path>/auto-minor-mode.el")
;;
;;; Usage:
;; You can define more than one minor mode to the same regular expression pattern:
;;  (add-to-list 'auto-minor-mode-alist '(\"\\.js$\" . autopair-mode))
;;  (add-to-list 'auto-minor-mode-alist '(\"\\.js$\" . auto-fill-mode)
;;
;; Or if you like, you can assoc a lambda expression to group all of
;; your desired minor modes:
;;  (add-to-list 'auto-minor-mode-alist
;;             '(\"\\.js$\" . (lambda () 
;;                              (progn
;;                                (autopair-mode 1)
;;                                (auto-fill-mode 1)))))
;;
;;; License:
;; auto-minor-mode is distributed in the hope that it will be useful
;; and is free software; you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version. See the GNU General Public License version 3 for
;; more details (http://opensource.org/licenses/gpl-3.0).
;;
(defvar auto-minor-mode-alist ()
  "Alist of filename extension patterns and minor modes to
activate (see `auto-mode-alist').

All pairs are checked, meaning you can define more than one minor mode to the same regular expression pattern:
 (add-to-list 'auto-minor-mode-alist '(\"\\.js$\" . autopair-mode))
 (add-to-list 'auto-minor-mode-alist '(\"\\.js$\" . auto-fill-mode)

Or if you like, you can assoc a lambda expression to group all of
your desired minor modes:
  (add-to-list 'auto-minor-mode-alist
             '(\"\\.js$\" . (lambda () 
                              (progn
                                (autopair-mode 1)
                                (auto-fill-mode 1)))))")

(defun enable-minor-mode-based-on-extension ()
  "Check filename extension in `auto-minor-mode-alist' to
activate multiple minor modes according to the patterns declared
in the assoc list."
  (when buffer-file-name
    (let ((name buffer-file-name)
          (remote-id (file-remote-p buffer-file-name))
          (alist auto-minor-mode-alist))
      ;; Remove backup-suffixes from file name.
      (setq name (file-name-sans-versions name))
      ;; Remove remote file name identification.
      (when (and (stringp remote-id)
                 (string-match-p (regexp-quote remote-id) name))
        (setq name (substring name (match-end 0))))
      (while (and alist (caar alist) (cdar alist))
        (if (string-match (caar alist) name)
            ;; If cdar is a symbol invoke funcall with activate flag <1>
            ;; otherwise is a lambda expression, invoke funcall without parameters
            (if (symbolp (cdar alist))
              (funcall (cdar alist) 1)
              (funcall (cdar alist))))
        (setq alist (cdr alist))))))

(add-hook 'find-file-hook 'enable-minor-mode-based-on-extension)

(provide 'auto-minor-mode)

;;
;;; auto-minor-mode.el ends here
