;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "Iosevka" :size 20 :weight 'medium))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'modus-vivendi)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-roam-directory (file-truename "~/org/roam"))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; my own stuff starts here (theme and font above)
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
                              ("t" "tickler" entry
                               (file "~/org/tickler.org")
                               "* DATE %i%? %^t")))
 (setq org-refile-targets '(("~/org/gtd.org" :maxlevel . 3)
                           ("~/org/someday.org" :level . 1)
                           ("~/org/tickler.org" :maxlevel . 2)))
 (setq-default bookmark-set-fringe-mark nil)
 (setq org-log-done 'time)
 (setq org-archive-location "~/org/archive/archive.org::datetree/")
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
         ((agenda "" ((org-agenda-span 'day) (org-agenda-start-day "") (org-agenda-prefix-format "  %?-12t%s") (org-agenda-current-time-string "> now <")))
          (todo "SORT" ((org-agenda-overriding-header "\nInbox:") (org-agenda-prefix-format "  %?-12t")))
          (todo "TODO" ((org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first) (org-agenda-overriding-header "\nNext actions:") (org-agenda-prefix-format "  %-60b%? e")))
          (stuck "" ((org-agenda-overriding-header "\nStuck Projects:") (org-agenda-prefix-format "  ")))
          (todo "WAIT" ((org-agenda-overriding-header "\nWaiting list:") (org-agenda-prefix-format "  ")))
          (tags "CLOSED>=\"<today>\"" ((org-agenda-overriding-header "\nCompleted today:") (org-agenda-prefix-format "  "))))
         ((org-agenda-compact-blocks t)))))
 (setq org-tags-column 0)
 (setq org-agenda-breadcrumbs-separator ":"))


(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

