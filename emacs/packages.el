  (use-package haskell-mode
    :ensure t)

  (use-package jupyter
    :ensure t)

  (use-package gnuplot
    :ensure t)

  (use-package gnuplot-mode
    :ensure t)

  (use-package doom-themes
    :ensure t
    :config
    (load-theme 'doom-gruvbox t)
    (doom-themes-visual-bell-config))
  (use-package magit
    :ensure t)
  ;;(set-face-attribute 'default nil :font "Iosevka Nerd Font-18")

  ;;    (set-face-attribute 'default nil :font "JetBrainsMono Nerd Font-22")
  ;;    (set-face-attribute 'default nil :font "DejaVu Sans Mono-28")


  ;;(use-package doom-modeline
  ;;:ensure t
  ;;:hook (after-init . doom-modeline-mode))

  (use-package all-the-icons
    :ensure t)

  (use-package helm
    :ensure t)

  (use-package nix-mode
    :ensure t
    )

  (use-package which-key
    :ensure t
    :config (which-key-mode))

  (use-package org-bullets
    :ensure t
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
    )

  (use-package restclient
    :ensure t
    )

  (use-package org-roam
    :ensure t
    :init
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-directory "~/sync/orgmode/library")
    (setq org-roam-dailies-directory "journal/")
    (org-roam-completion-everywhere t)
    :bind (("C-c n l" . org-roam-buffer-toggle)
           ("C-c n f" . org-roam-node-find)
           ("C-c n i" . org-roam-node-insert)
           :map org-mode-map
           ("C-M-i" . completion-at-point)
           :map org-roam-dailies-map
           ("Y" . org-roam-dailies-capture-yesterday)
           ("T" . org-roam-dailies-capture-tomorrow))
    :bind-keymap
    ("C-c n d" . org-roam-dailies-map)
    :config
    (require 'org-roam-dailies) ;; Ensure the keymap is available
    (org-roam-db-autosync-mode))

  (use-package org-roam-ui
    :ensure t
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))

  ;; use-package with package.el:
  (use-package dashboard
    :ensure t 
    :init
    (setq initial-buffer-choice 'dashboard-open)
    (setq dashboard-center-content nil) ;; set to 't' for centered content
    (setq dashboard-items '((agenda . 5)
                            (recents . 5 ))))
 (use-package protobuf-mode
    :ensure t)

  (use-package fsharp-mode
    :defer t
    :ensure t)

  (use-package go-mode
    :defer t
    :ensure t)
  (add-hook 'go-mode-hook #'eglot-ensure)

  (use-package csharp-mode
    :defer t
    :ensure t)
  (add-hook 'chsarp-mode-hook #'eglot-ensure)
  ;;  (add-to-list 'eglot-server-programs
  ;;               `(csharp-mode . ("OmniSharp" "-lsp")))

  (use-package clojure-mode
    :ensure t)

  (use-package elm-mode
    :ensure t)
  (add-hook 'elm-mode-hook 'elm-format-on-save-mode)

  (use-package csv-mode
    :ensure t
    )

  (use-package markdown-mode
    :ensure t
    :mode ("README\\.md\\'" . gfm-mode)
    :init (setq markdown-command "multimarkdown"))

  (use-package ledger-mode
    :ensure t
    :init
    :config
    (setq ledger-reports
          '(("cashflow" "ledger -f %(ledger-file) --cost -X EUR bal ^Income ^Expenses")
            ("cashflow-rsd" "ledger -f %(ledger-file) --cost -X RSD bal ^Income ^Expenses")
            ("net-worth" "ledger -f %(ledger-file) --cost -X EUR bal ^Assets ^Liabilities")
            ("net-worth-rsd" "ledger -f %(ledger-file) --cost -X RSD bal ^Assets ^Liabilities")
            ("prices" "ledger prices -f %(ledger-file)")
            ("bal" "%(binary) -f %(ledger-file) --cost -X EUR bal")
            ("bal-rsd" "%(binary) -f %(ledger-file) --cost -X RSD bal")
            ("reg" "%(binary) -f %(ledger-file) --cost -X EUR reg")
            ("reg-rsd" "%(binary) -f %(ledger-file) --cost -X RSD reg")
            ("payee" "%(binary) -f %(ledger-file) --cost -X EUR reg @%(payee)")
            ("payee-rsd" "%(binary) -f %(ledger-file) --cost -X RSD reg @%(payee)")
            ("account" "%(binary) -f %(ledger-file) --cost -X EUR reg %(account)")  
            ("account-rsd" "%(binary) -f %(ledger-file) --cost -X RSD reg %(account)")))  
    )



  (custom-set-faces
   ;; custom-set-faces was added by Custom.
   ;; If you edit it by hand, you could mess it up, so be careful.
   ;; Your init file should contain only one such instance.
   ;; If there is more than one, they won't work right.
   )

