;;; Evan Bowman 2016
;;;
;;; Some elisp functions for modifying indentation style for
;;; potentially large collections of files.
;;;
;;; For large projects, ie > 10000 lines, tabify/untabify-dir
;;; can take a minute or two to run.
;;;

(defun refactor--process-file (file-name policy)
  (find-file file-name)
  (funcall policy (point-min) (point-max))
  (save-buffer))

(defun refactor--process-files (dir-name policy)
  (setq dir-files (directory-files dir-name))
  (dolist (element dir-files)
    (unless (or (string= "." element)
		(string= ".." element)
		(file-directory-p element))
      (find-file element)
      (funcall policy (point-min) (point-max))
      (save-buffer))))

(defun tabify-file ()
  "Tabify the contents of a single file"
  (interactive)
  (let ((file-name (read-file-name "Enter file name:")))
    (refactor--process-file file-name 'tabify)))

(defun untabify-file ()
  "Untabify the contents of a single file"
  (interactive)
  (let ((file-name (read-file-name "Enter file name: ")))
    (refactor--process-file file-name 'untabify)))

(defun tabify-dir ()
  "Tabify the contents of a folder"
  (interactive)
  (let ((dir-name (read-directory-name "Enter directory name: ")))
    (refactor--process-files dir-name 'tabify)))

(defun untabify-dir ()
  "Untabify the contents of a folder"
  (interactive)
  (let ((dir-name (read-directory-name "Enter directory name: ")))
    (refactor--process-files dir-name 'untabify)))
