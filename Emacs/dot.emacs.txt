(defun markdown-preview-file ()
  "use Marked 2 to preview the current file"
  (interactive)
  (shell-command 
   (format "open -a 'Marked 2.app' %s" 
       (shell-quote-argument (buffer-file-name))))
)
(global-set-key "\C-cm" 'markdown-preview-file)
