(let* ((gc-cons-threshold (* 25 1024 1024))
       (local-elpa-mirror-base "~/share/emacs-elpa")
       (local-elpa-mirror-thin (concat local-elpa-mirror-base "/thin-elpa-mirror"))
       ;; (local-thin-installed nil)
       (local-thin-installed (file-directory-p local-elpa-mirror-thin)))

  (require 'package)
  (setq package-enable-at-startup nil)
  (cond (local-thin-installed
         (message "local thin melpa found: installing...")
         (setq package-archives `(("melpa" . ,(concat local-elpa-mirror-thin))
                                  ("org"   . ,(concat local-elpa-mirror-thin))
                                  ("elpa"   . ,(concat local-elpa-mirror-thin))
				  )))
        (t
         (message "there are no local elpa mirrors. going to the interwebz")
         (setq package-archives `(("melpa" . "https://melpa.org/packages/")
                                  ("org"   . "https://orgmode.org/elpa/")
                                  ("elpa"   . "https://elpa.gnu.org/packages/")))))
  (package-initialize)

  (unless package-archive-contents
    (package-refresh-contents))

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  (require 'use-package)
  (setq use-package-always-ensure t)

  (setq vc-follow-symlinks "t") ; prevent prompt when loading org file
  (use-package diminish :ensure t)
  (use-package org
    :pin org
    :ensure org-plus-contrib
    :defer 7) ;; fetch latest version of `org-mode'

  (org-babel-load-file (expand-file-name "emacs.org" user-emacs-directory))

  (garbage-collect))
