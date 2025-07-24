;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
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

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:





;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-tokyo-night)
;; (setq doom-theme 'doom-ephemeral)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


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
;; switch between window with C-hjkl
(map! :nvi "C-h" #'evil-window-left
      :nvi "C-j" #'evil-window-down
      :nvi "C-k" #'evil-window-up
      :nvi "C-l" #'evil-window-right)


;; (use-package company
;;   :config
;;   (global-company-mode))



(setq doom-font (font-spec :size 16))


;; (use-package copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;          ("<tab>" . copilot-accept-completion)
;;          ("C-<tab>" . copilot-accept-completion-by-word)))



(map! :map global-map
      "C-c r" #'query-replace)


(setq comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)



(add-hook 'vterm-mode-hook (lambda () (term-line-mode -1)))
(setq text-mode-hook 'turn-off-auto-fill) ; 改行するかしないか
(map! :leader
      :desc "Start Pomodoro" "o p" #'org-pomodoro)
(setq org-pomodoro-finished-sound nil  ; 作業終了時の音を無効化
      org-pomodoro-short-break-sound nil  ; 短い休憩時の音を無効化
      org-pomodoro-long-break-sound nil)  ; 長い休憩時の音を無効化
(defun rinichi/org-pomodoro-notify (msg)
  "Use terminal-notifier to show MSG as a notification."
(start-process "org-pomodoro-notify" nil "terminal-notifier"
                 "-title" "Org Pomodoro"
                 "-message" msg))

(setq org-pomodoro-finished-hook
      (lambda () (rinichi/org-pomodoro-notify "Pomodoro finished! Take a break.")))

(setq org-pomodoro-short-break-hook
      (lambda () (rinichi/org-pomodoro-notify "Short break time!")))

(setq org-pomodoro-long-break-hook
      (lambda () (rinichi/org-pomodoro-notify "Long break time!")))


;; ファイル削除時にmacOSのゴミ箱へ移動する
(setq delete-by-moving-to-trash t)

;; (use-package org
;;   :init
;;   (setq org-directory "~/"
;;         org-daily-tasks-file (format "%s/tasks.org" org-directory))
;;   :custom
;;   (org-capture-templates
;;     '(("d" "Weekdays TODO" entry (file org-daily-tasks-file) "%[~/.emacs.d/assets/org-templates/weekdays-todo.org]" :prepend t)
;;       ("w" "Weekends TODO" entry (file org-daily-tasks-file) "%[~/.emacs.d/assets/org-templates/weekends-todo.org]" :prepend t))
;;     ))


;; org-computerの設定
(use-package org
  :init
  (setq org-directory "/Users/rinichimrt/Library/CloudStorage/Box-Box/chri22024/Org/")

  (setq org-directory "~~/Library/CloudStorage/Box-Box/chri22024/Tasks/2025-Tasks/test.org"
        org-daily-tasks-file (format "%s/tasks.org" org-directory))
  :custom
  (org-capture-templates
    '(("d" "Weekdays TODO" entry (file org-daily-tasks-file) "%[~/.emacs.d/assets/org-templates/weekdays-todo.org]" :prepend t)
      ("w" "Weekends TODO" entry (file org-daily-tasks-file) "%[~/.emacs.d/assets/org-templates/weekends-todo.org]" :prepend t))
    ))



;; レベル1の見出しを標準の1.4倍のサイズにする
(set-face-attribute 'org-level-1 nil :height 1.3)

;; レベル2の見出しを標準の1.3倍のサイズにする
(set-face-attribute 'org-level-2 nil :height 1.1)

;; レベル3の見出しを標準の1.2倍のサイズにする
(set-face-attribute 'org-level-3 nil :height 1.05)

(after! org
  (setq org-hide-emphasis-markers t))

;; 必要に応じて他のレベルも見出しを設定
;(set-face-attribute 'org-level-5 nil :height 1.05)

;; (use-package! org-modern
;;   :hook (org-mode . org-modern-mode)
;;   :config
;;   (setq org-modern-star ’(“◉” “○” “✸” “✿” “✤” “✜” “◆” )))
(tool-bar-mode 0) ;; macのGUIのツールバーを非表示にする
(menu-bar-mode 0);; macのGUIのメニューバーを非表示にする



;; TRAMP接続時のラグをさらに改善するための設定
(with-eval-after-load 'tramp
  ;; 1. TRAMP利用時にバージョン管理機能(vc-mode)を無効化する
  ;;    これが体感速度に最も効く場合があります。
  (add-hook 'tramp-pre-connection-hook
            (lambda (_method _user _host)
              (setq-default vc-ignore-dir-regexp tramp-file-name-regexp)))

  ;; 2. TRAMPでの自動保存を無効にする
  ;;    入力中のカクつきを減らす効果が期待できます。
  (setq tramp-auto-save-directory nil)

  ;; 3. ファイル名補完時の再読み込みタイムアウトを延長（任意）
  ;;    ディレクトリ内のファイル一覧表示のもたつきを軽減します。
  (setq tramp-completion-reread-directory-timeout 30)
  )
