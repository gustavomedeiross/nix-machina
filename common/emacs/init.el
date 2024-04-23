;; Activate use-package and the things it needs.
;; use-package is installed by emacs.nix,
;; and the other two libs are bundled with emacs.
(require 'use-package)
(require 'diminish)
(require 'bind-key)
(require 'general)

(setq use-package-always-ensure t)

(use-package emacs
  :config
  ;; Remove welcome screen
  (setq inhibit-startup-message t)
  ;; Disable backup~ files
  (setq make-backup-files nil)
  ;; Disable .#lock files
  (setq create-lockfiles nil)
  ;; Disable beeps
  (setq ring-bell-function 'ignore)
  ;; Disable visible scrollbar
  (scroll-bar-mode -1)
  ;; Disable the toolbar
  (tool-bar-mode -1)
  ;; Disable tooltips
  (tooltip-mode -1)
  ;; Give some breathing room
  (set-fringe-mode 10)
  ;; Disable the menu bar
  (menu-bar-mode -1)
  ;; Disable eldoc
  (global-eldoc-mode -1)

  ;; Tabs
  (setq-default indent-tabs-mode nil)
  (setq-default tab-width 4)
  (setq indent-line-function 'insert-tab)

  ;; Make ESC quit prompts
  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)

  (column-number-mode)
  (global-display-line-numbers-mode t)
  (setq display-line-numbers-type 'relative)

  (set-frame-font "Fira Code 12" nil t)

  ;; Makes emacs frame maximized by default (useful for floating window managers systems)
  (add-to-list 'default-frame-alist '(fullscreen . maximized))

  ;; Move autosave and backup files to ~/.auto-saves
  (defvar user-temporary-file-directory
    (concat temporary-file-directory user-login-name "/"))
  (make-directory user-temporary-file-directory t)
  (setq backup-by-copying t)
  (setq backup-directory-alist
        `(("." . ,user-temporary-file-directory)
          (,tramp-file-name-regexp nil)))
  (setq auto-save-list-file-prefix
        (concat user-temporary-file-directory ".auto-saves-"))
  (setq auto-save-file-name-transforms
        `((".*" ,user-temporary-file-directory t)))

  ;; MacOS
  (setq mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-command-modifier 'meta
        mac-option-modifier 'none)

  (setq custom-file (concat user-emacs-directory "/custom.el"))

  :custom
  (display-buffer-alist
   '(("\\*haskell\\*"
      (display-buffer-in-side-window)
      (window-height . 0.25)
      (side . bottom)
      (slot . -1))))
  :general
  (general-define-key
    :states 'normal
    :keymaps '(normal visual emacs override)
    :prefix "SPC"
      "," '(switch-to-buffer :which-key "Switch to buffer")
      "<" '(ibuffer :which-key "Open iBuffer")
      "." '(find-file :which-key "Find file")
      ">" '(list-bookmarks :which-key "Bookmark list")

      "w h" '(windmove-left :which-key "Move to left window")
      "w j" '(windmove-down :which-key "Move to lower window")
      "w k" '(windmove-up :which-key "Move to upper window")
      "w l" '(windmove-right :which-key "Move to right window")

      "b k" '(kill-buffer :which-key "Kill buffer")
      "b r" '(rename-buffer :which-key "Rename buffer"))
  (general-define-key
   :keymaps '(normal visual)
   "C-/" '(comment-or-uncomment-region :which-key "Comment or uncomment region")))

(use-package dired
  :ensure nil
  ;; Auto-refresh dired
  :hook (dired-mode . auto-revert-mode)
  :config
  ;; Easily copy-paste files with split windows
  (setq dired-dwim-target t))

;; Copy current file path and line number to clipboard
(defun gm/copy-current-line-position-to-clipboard ()
    "Copy current line in file to clipboard as '</path/to/file>:<line-number>'."
    (interactive)
    (let* ((project-path (projectile-project-root))
          (path-with-line-number
           (concat (dired-replace-in-string project-path "" (buffer-file-name)) ":" (number-to-string (line-number-at-pos)))))
      (kill-new path-with-line-number)
      (message (concat path-with-line-number " copied to clipboard"))))

;; Package specifics

(use-package string-inflection)

(use-package multiple-cursors)

(use-package git-link)

(use-package org
  :hook (org-mode . (lambda ()
                      (org-indent-mode)
                      (visual-line-mode 1)))
  :config
  (setq org-ellipsis " ▾")

  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Change the size of org headings.
  (custom-set-faces
   '(org-document-title ((t (:inherit outline-1 :height 1.4))))
   '(org-level-1 ((t (:inherit outline-1 :height 1.4))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.2))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.2))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  ;; TODO keywords.
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "PROG(p)" "INTR(i)" "DONE(d)")))
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/tasks.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")
          ("s" "Slipbox" entry  (file "~/org/slipbox.org")
           "* %?\n")))
  :general
  (general-define-key
    :states 'normal
    :keymaps '(normal visual emacs override)
    :prefix "SPC"
    "o t" '(org-todo :which-key "Org TODO")
    "o a" '(org-agenda :which-key "Org agenda")
    "o c" '(org-capture :which-key "Org capture")
    "o q" '(org-set-tags-command :which-key "Org set tags")
    "o s" '(org-schedule :which-key "Org schedule")
    "o p" '(org-priority :which-key "Org priority")
    "o i" '(org-toggle-inline-images :which-key "Org image show")
    "o o" '(org-open-at-point :which-key "Org open link at point")
    "o b" '(org-cite-insert :which-key "Org biblio cite insert")))

(use-package org-agenda
  :ensure nil
  :after (org evil)
  :bind (:map org-agenda-mode-map
              ("j" . evil-next-line)
              ("k" . evil-previous-line))
  :config
  (setq org-agenda-files '("~/org/tasks.org"))
  ;; Show the daily agenda by default.
  (setq org-agenda-span 'day)
  ;; Hide tasks that are scheduled in the future.
  (setq org-agenda-todo-ignore-scheduled 'future)
  ;; Use "second" instead of "day" for time comparison.
  ;; It hides tasks with a scheduled time like "<2020-11-15 Sun 11:30>"
  (setq org-agenda-todo-ignore-time-comparison-use-seconds t)
  ;; Hide the deadline prewarning prior to scheduled date.
  (setq org-agenda-skip-deadline-prewarning-if-scheduled 'pre-scheduled)
  ;; Customized view for the daily workflow. (Command: "C-c a n")
  (setq org-agenda-custom-commands
        '(("n" "Agenda / INTR / PROG / NEXT"
           ((agenda "" nil)
            (todo "INTR" nil)
            (todo "PROG" nil)
            (todo "NEXT" nil))
           nil))))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(use-package org-roam
  :custom
  (org-roam-directory "~/org/roam")
  :general
  (general-define-key
    :states 'normal
    :keymaps '(normal visual emacs override)
    :prefix "SPC"
    "z l" '(org-roam-buffer-toggle :which-key "Zettel buffer toggle")
    "z f" '(org-roam-node-find :which-key "Find zettel")
    "z i" '(org-roam-node-insert :which-key "Insert zettel at point")
    "z c" '(org-roam-capture :which-key "Zettel capture")
    "z g" '(org-roam-graph :which-key "Zettel graph"))
  :hook
  (org-roam-capture-new-node . gm/tag-new-node-as-draft)
  :config
  (org-roam-db-autosync-mode)
  (org-roam-setup)

  (setq org-roam-capture-templates
        '(("m" "main" plain
           "%?"
           :if-new (file+head "main/${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "reference/${title}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("a" "article" plain "%?"
           :if-new
           (file+head "articles/${title}.org" "#+title: ${title}\n#+filetags: :article:\n")
           :immediate-finish t
           :unnarrowed t)))

  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE."
    (condition-case nil
        (file-name-nondirectory
         (directory-file-name
          (file-name-directory
           (file-relative-name (org-roam-node-file node) org-roam-directory))))
      (error "")))

  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:10}" 'face 'org-tag)))

  (defun gm/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft"))))

(use-package citar
  :demand t
  :after (org)
  :custom
  (org-cite-global-bibliography '("~/org/roam/biblio.bib"))
  (citar-bibliography org-cite-global-bibliography)
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar))

(use-package citar-org-roam
  :after citar org-roam
  :demand t
  :custom
  (citar-org-roam-mode t)
  (setq citar-org-roam-note-title-template "${author} - ${title}")
  (setq citar-org-roam-subdir "reference"))

;; From: jethrokuan.github.io/org-roam-guide/
(defun gm/org-roam-node-from-cite (entry-key)
  "Create an Org-Roam node from a bibliography reference."
  (interactive (list (citar-select-ref)))
  (let ((title (citar-format--entry
                "${author editor} - ${title}"
                (citar-get-entry entry-key))))
    (org-roam-capture- :templates
                       `(("r" "reference" plain
                          "%?"
                          :if-new (file+head "reference/${citekey}.org"
                                             ,(concat
                                               ":PROPERTIES:\n"
                                               ":ROAM_REFS: [cite:@${citekey}]\n"
                                               ":END:\n"
                                               "#+title: ${title}\n"))
                          :immediate-finish t
                          :unnarrowed t))
                       :info (list :citekey entry-key)
                       :node (org-roam-node-create :title title)
                       :props '(:finalize find-file))))

(use-package ox-slack)

(defun gm/org-export-slack-to-clipboard ()
  "Exports org-mode text to be pasted in Slack"
  (interactive)
  (org-slack-export-to-clipboard-as-slack))

(use-package tex-site
  :straight (auctex :host github
                    :repo "emacsmirror/auctex"
                    :files (:defaults (:exclude "*.el.in")))
  :defer t
  :config
  (setq TeX-auto-save nil))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 1))

(use-package vertico
  :init
  (vertico-mode)
  ;; Add vim keybindings to vertico
  :general
  (general-define-key
   :keymaps '(vertico-map)
    "C-J"      #'vertico-next-group
    "C-K"      #'vertico-previous-group
    "C-j"      #'vertico-next
    "C-k"      #'vertico-previous))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode))

(use-package general
  :demand t
  :config
  (setq general-evil-setup t)

  (general-create-definer leader-keys
    :states 'normal
    :keymaps '(normal visual emacs override)
    :prefix "SPC"))

;; UI

(use-package dashboard
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-center-content t)
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-display-icons-p t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-page-separator "\n\n")
  (setq dashboard-items '((bookmarks . 5)
                          (projects . 5)))
  (setq dashboard-heading-icons '((recents   . "history")
                                    (bookmarks . "bookmark")
                                    (agenda    . "calendar")
                                    (projects  . "rocket")
                                    (registers . "database")))
  (setq dashboard-projects-switch-function #'projectile-persp-switch-project))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
  :custom
  (all-the-icons-dired-monochrome nil))

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-modal nil)
  (setq doom-modeline-battery t)
  (setq doom-modeline-buffer-encoding nil)
  (setq doom-modeline-lsp nil)
  (setq doom-modeline-checker-simple-format t))

(use-package doom-themes
  :config
  (load-theme 'doom-gruvbox t))

(use-package zoom
  :config
  (zoom-mode t)
  :custom
  (zoom-size '(0.618 . 0.618)))

;; Evil Mode

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  (setq evil-insert-state-cursor 'box)

  (defun gm/split-window-vertically-with-focus ()
    (interactive)
    (evil-window-vsplit)
    (other-window 1))
  (defun gm/split-window-horizontally-with-focus ()
    (interactive)
    (evil-window-split)
    (other-window 1))

  :general
  (general-define-key
    :states 'normal
    :keymaps '(normal visual emacs override)
    :prefix "SPC"
    "w s" '(evil-window-split :which-key "Horizontal split")
    "w S" '(gm/split-window-horizontally-with-focus :which-key "Horizontal split with focus")
    "w v" '(evil-window-vsplit :which-key "Vertical split")
    "w V" '(gm/split-window-vertically-with-focus :which-key "Vertical split with focus")
    "w q" '(evil-quit :which-key "Quit window")))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-escape
  :init
  (setq-default evil-escape-key-sequence "jk")
  :config
  (evil-escape-mode))

;; Undo

(use-package undo-fu
  :commands (undo-fu-only-undo)
  :defer nil)

(use-package undo-fu-session
  :init (undo-fu-session-global-mode))

;; Shell

(use-package eshell
  :hook
  (eshell-mode . (lambda ()
                   (display-line-numbers-mode 0)
                   (setenv "TERM" "xterm-256color")))
  ;; Truncate buffer for performance
  (eshell-output-filter-functions . eshell-truncate-buffer)
  ;; Save command history when commands are entered
  (eshell-pre-command-hook . eshell-save-some-history)
  :config
  (setq eshell-history-size 10000
	eshell-buffer-maximum-lines 10000
	eshell-hist-ignoredups t
	eshell-scroll-to-bottom-on-input t)
  (evil-normalize-keymaps))

(defun spawn-eshell (name)
  "Create a new named eshell buffer"
  (interactive "MName: ")
  (setq name (concat "$" name))
  (eshell)
  (rename-buffer name))

(use-package exec-path-from-shell
  :init
  (exec-path-from-shell-initialize)
  :config
  (exec-path-from-shell-copy-envs '("PATH")))

(use-package eat
  :straight
  (:type git
         :host codeberg
         :repo "akib/emacs-eat"
         :files ("*.el" ("term" "term/*.el") "*.texi"
                 "*.ti" ("terminfo/e" "terminfo/e/*")
                 ("terminfo/65" "terminfo/65/*")
                 ("integration" "integration/*")
                 (:exclude ".dir-locals.el" "*-tests.el"))))

(use-package vterm
  :config
  (setq vterm-max-scrollback 10000))

;; Magit

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :general
  (general-define-key
   :states 'normal
   :keymaps '(normal visual emacs override)
   :prefix "SPC"
   "g g" '(magit-status :which-key "Magit status"))
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  :config
  (general-define-key
   :keymaps 'transient-base-map
   "<escape>" 'transient-quit-one))

(use-package forge
  :after magit
  :general
  (general-define-key
   :states 'normal
   :keymaps '(normal visual emacs override)
   :prefix "SPC"
   "f o p" '(forge-browse-pullreqs :which-key "Forge open pull requests"))
  :config
  (setq auth-sources '("~/.authinfo")))

;; Perspectives + Projectile

(use-package perspective
  :init (persp-mode)
  :custom
  (persp-suppress-no-prefix-key-warning t)
  :general
  (general-define-key
   :states 'normal
   :keymaps '(normal visual emacs override)
   :prefix "SPC"
    "TAB ," '(persp-switch :which-key "Switch to a workspace")
    "TAB r" '(persp-rename :which-key "Rename workspace")
    "TAB d" '(persp-kill :which-key "Delete workspace")
    "TAB k" '(persp-kill :which-key "Delete workspace")
    "TAB q" '(persp-kill :which-key "Delete workspace")))

(use-package projectile
  :diminish projectile-mode
  :init
  ;; When switching to a new project, magit-status if the project is a git repo, otherwise dired
  (setq projectile-switch-project-action #'magit-status)
  (setq projectile-track-known-projects-automatically nil)
  :config (projectile-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps '(normal visual emacs override)
   :prefix "SPC"
   "p f" '(consult-find :which-key "Run a fuzzy find against project files")
   "p s" '(consult-ripgrep :which-key "Run ripgrep against project files")
   "p p" '(projectile-persp-switch-project :which-key "Switch to project in a new perspective")
   "p e" '(project-eshell :which-key "Open a new eshell instance in the project directory")
   "p c" '(projectile-add-known-project :which-key "Creates a new project")))

(use-package persp-projectile
    :straight (persp-projectile
               :host github
               :repo "bbatsov/persp-projectile")
    :commands (projectile-persp-switch-project))

;; LSP & Auto-completion

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :config
  (lsp-enable-which-key-integration t)
  (setq lsp-enable-file-watchers t)
  (setq lsp-file-watch-threshold nil)
  :general
  (general-define-key
    :states 'normal
    :keymaps '(normal override)
    "g r" '(lsp-find-references :which-key "Find usages of code")))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-enable nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-ui-sideline-enable nil)
  (lsp-modeline-code-actions-enable nil)
  (lsp-eldoc-enable-hover nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-signature-auto-activate nil)
  (lsp-signature-render-documentation nil)
  :general
  (general-define-key
    :states 'normal
    :keymaps '(normal override)
    "K" '(lsp-ui-doc-glance :which-key "Show module docs")))

(use-package company
  :after lsp-mode
  :hook (prog-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0)
  :general
  (general-define-key
    :keymaps '(insert normal)
    "C-SPC" '(company-complete :which-key "Trigger completion at point")))

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package flycheck
  :config
  (global-flycheck-mode))

(use-package flycheck-posframe
  :after flycheck
  :config
  (add-hook 'flycheck-mode-hook #'flycheck-posframe-mode))

(use-package direnv
 :config
 (direnv-mode))

(use-package json-mode)

(use-package yaml-mode)

;; Nix

(use-package nix-mode
  :mode "\\.nix\\'")

;; OCaml
(use-package tuareg
  :hook (tuareg-mode . lsp-deferred)
  :config
  (lsp-register-client
    (make-lsp-client
     :new-connection (lsp-stdio-connection '("opam" "exec" "--" "ocamllsp"))
     :major-modes '(tuareg-mode)
     :server-id 'ocamlmerlin-lsp)))

;; Haskell
(use-package lsp-haskell)
(use-package haskell-mode
  :init
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-literate-mode-hook #'lsp))

;; Elixir
(use-package elixir-mode
  :hook (elixir-mode . lsp-deferred))

;; Rust
(use-package rust-mode
  :hook (rust-mode . lsp-deferred))

;; TypeScript
(use-package typescript-mode
  :mode "\\.ts\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; Lilypond
(use-package lilypond-mode
  ;; :straight (:host github :repo "lilypond/lilypond" :files ("elisp" "*.el"))
  :straight nil
  :load-path "~/.emacs.d/site-lisp"
  :mode ("\\.ly\\'" . LilyPond-mode))

;; Copilot
(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("dist" "*.el"))
  ;; Disable copilot-mode by default for now
  ;; :init
  ;; (add-hook 'prog-mode-hook 'copilot-mode)
  :config
  (define-key copilot-completion-map (kbd "C-<return>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "C-RET") 'copilot-accept-completion))
