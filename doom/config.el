;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; (setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")

(setq doom-font (font-spec :family "Iosevka" :size 20 :weight 'medium))

(setq doom-theme 'modus-vivendi)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")
(setq org-roam-directory (file-truename "~/org/roam"))

(add-to-list 'default-frame-alist '(fullscreen . maximized))

(add-hook! 'elfeed-search-mode-hook #'elfeed-update)

; org stuff
(after! org
 (add-to-list 'org-modules 'org-habit)
 (setq org-checkbox-hierarchical-statistics nil)
 (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "NEXT(n)"
           "TICK(T)"
           "|"
           "DONE(d)")))

 (setq org-agenda-files '("~/org/inbox.org"
                          "~/org/gtd.org"
                         "~/org/tickler.org"))

 (setq org-capture-templates '(("i" "[inbox]" entry
                               (file "~/org/inbox.org")
                               "* %?")))

 (setq org-refile-targets '(("~/org/gtd.org" :maxlevel . 3)
                           ("~/org/someday.org" :level . 1)
                           ("~/org/tickler.org" :maxlevel . 2)))

 (setq-default bookmark-set-fringe-mark nil)
 (setq org-log-done 'time)
 (setq org-archive-location "~/org/archive/2023-archive.org::datetree/")
 (setq org-archive-save-context-info '(olpath itags ltags))
 (setq org-startup-folded t)
 (setq org-todo-repeat-to-state t)
 (setq org-stuck-projects '("+LEVEL=1+project/-DONE" ("TODO" "NEXT")))
 (setq org-tags-exclude-from-inheritance '("project"))

 (setq org-agenda-custom-commands
      '(("g" "GTD agenda"
         ((agenda ""
                ((org-agenda-span 'day)
                 (org-agenda-start-day "")
                 (org-agenda-prefix-format "  %s%?b%?-12t")
                 (org-agenda-current-time-string "> now <")
                 (org-agenda-skip-scheduled-if-done t)
                 (org-agenda-skip-deadline-if-done t)))
          (todo "NEXT"
                ((org-agenda-overriding-header "\nNext actions:")
                 (org-agenda-prefix-format "  %?b%? e")))
           (todo "TODO"
                ((org-agenda-overriding-header "\nTasks:")
                 (org-agenda-prefix-format "  %?b%? e")))
         (stuck ""
                ((org-agenda-overriding-header "\nStuck projects:")
                 (org-agenda-prefix-format "  ")))
        (tags "inbox"
              ((org-agenda-overriding-header "\nInbox:")
               (org-agenda-prefix-format "  ")))
         (tags "wait"
              ((org-agenda-overriding-header "\nWaiting list:")
               (org-agenda-prefix-format "  ")))
       (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today:")
                 (org-agenda-prefix-format "  "))))
         ((org-agenda-compact-blocks t)))))

 (setq org-tags-column 0)
 (setq org-agenda-breadcrumbs-separator "/")
 (setq org-agenda-dim-blocked-tasks nil))

(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

; for uni
(setq compile-command "gcc -Wall -std=c99 -pedantic -o ")
