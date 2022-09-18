;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; (setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")

(setq doom-font (font-spec :family "Iosevka" :size 20 :weight 'medium))

(setq doom-theme 'modus-vivendi)

(setq display-line-numbers-type t)

(setq org-directory "~/org/")
(setq org-roam-directory (file-truename "~/org/roam"))

(add-to-list 'initial-frame-alist '(fullscreen . maximized))

(add-hook! 'elfeed-search-mode-hook #'elfeed-update)

; org stuff
(after! org
 (add-to-list 'org-modules 'org-habit)
 (setq org-checkbox-hierarchical-statistics nil)
 (setq org-todo-keywords
        '((sequence
           "TODO(t)"
           "PROJ(p)"
           "LOOP(r)"
           "WAIT(w)"
           "SORT(s)"
           "DATE(D)"
           "|"
           "DONE(d)"
           "DPROJ(P)"
           "CANC(c)"))
        org-todo-keyword-faces
        '(("PROJ" . +org-todo-project)
          ("WAIT" . +org-todo-onhold)
          ("SORT" . +org-todo-onhold)
          ("CANC" . +org-todo-cancel)))

 (setq org-agenda-files '("~/org/inbox.org"
                          "~/org/gtd.org"
                         "~/org/tickler.org"))

 (setq org-capture-templates '(("i" "[inbox]" entry
                               (file "~/org/inbox.org")
                               "* SORT %i%?")
                              ("t" "[tickler]" entry
                               (file "~/org/tickler.org")
                               "* DATE %i%? \n%^t")))

 (setq org-refile-targets '(("~/org/gtd.org" :maxlevel . 3)
                           ("~/org/someday.org" :level . 1)
                           ("~/org/tickler.org" :maxlevel . 2)))

 (setq-default bookmark-set-fringe-mark nil)
 (setq org-log-done 'time)
 (setq org-archive-location "~/org/archive/archive.org::datetree/")
 (setq org-archive-save-context-info '(olpath itags ltags))
 (setq org-startup-folded t)
 (setq org-todo-repeat-to-state t)
 (setq org-stuck-projects '("+LEVEL=1/PROJ" ("TODO" "WAIT")))

 (defun my-org-agenda-skip-all-siblings-but-first ()
   "Skip all but the first non-done entry."
   (let (should-skip-entry)
     (unless (org-current-is-todo)
       (setq should-skip-entry t))
     (save-excursion
       (while (and (not should-skip-entry) (org-goto-sibling t))
         (when (and (org-current-is-todo) (not (org-has-tag-single)))
           (setq should-skip-entry t))))
     (when should-skip-entry
       (or (outline-next-heading)
           (goto-char (point-max))))))

 (defun org-current-is-todo ()
   (string= "TODO" (org-get-todo-state)))

 (defun org-has-tag-single ()
   (member "single" (org-get-tags)))

 (setq org-agenda-custom-commands
      '(("g" "GTD agenda"
         ((agenda ""
                ((org-agenda-span 'day)
                 (org-agenda-start-day "")
                 (org-agenda-prefix-format " %?-12t%s")
                 (org-agenda-current-time-string "> now <")
                 (org-agenda-skip-scheduled-if-done t)
                 (org-agenda-skip-deadline-if-done t)))
          (todo "TODO"
                ((org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)
                 (org-agenda-overriding-header "\nNext actions:")
                 (org-agenda-prefix-format " %?b%? e")))
          (todo "SORT"
                ((org-agenda-overriding-header "\nInbox:")
                 (org-agenda-prefix-format " %?-12t")))
          (stuck ""
                ((org-agenda-overriding-header "\nStuck Projects:")
                 (org-agenda-prefix-format " ")))
          (todo "WAIT"
                ((org-agenda-overriding-header "\nWaiting list:")
                 (org-agenda-prefix-format " ")))
          (tags "CLOSED>=\"<today>\""
                ((org-agenda-overriding-header "\nCompleted today:")
                 (org-agenda-prefix-format " "))))
         ((org-agenda-compact-blocks t)))))

 (setq org-tags-column 0)
 (setq org-agenda-breadcrumbs-separator ": ")
 (setq org-agenda-dim-blocked-tasks nil))

(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

; for uni
(setq compile-command "gcc -Wall -pedantic -o ")
