;;; config.el -*- lexical-binding: t; -*-
;;;
;;;

;; このファイルにプライベートな設定を記述します。
;; このファイルを変更した後に 'doom sync' を実行する必要はありません。
;;
;;;; ~/.doom.d/config.el に記述

;; ;; SPC f s でファイルを保存する (save-buffer コマンドを実行)
;; (map! :leader
;;       "f s" #'save-buffer)

;; ;; which-keyに説明を表示する便利な書き方
;; ;; SPC o t でターミナルを開く (+term/here コマンドを実行)
;; (map! :leader
;;       :desc "Open terminal here" "o t" #'+term/here)
;; ;;
;; ;;
;; ;; ~/.doom.d/config.el に記述

;; ;; SPC f s でファイルを保存する (save-buffer コマンドを実行)
;; (map! :leader
;;       "f s" #'save-buffer)

;; ;; which-keyに説明を表示する便利な書き方
;; ;; SPC o t でターミナルを開く (+term/here コマンドを実行)
;; (map! :leader
;;       :desc "Open terminal here" "o t" #'+term/here)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. 基本設定 (General Settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; GPG設定、メール、スニペットなどで使用される個人情報を設定します (任意)
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Emacsフレームの透明度を設定 (背景を少し透過させる)
(add-to-list 'default-frame-alist '(alpha . (0.95 0.95)))

;; ファイルを削除する際に、直接削除せずmacOSのゴミ箱へ移動
(setq delete-by-moving-to-trash t)

;; テキストモードで自動的に改行（折り返し）を無効化
(setq text-mode-hook 'turn-off-auto-fill)

;; ネイティブコンパイルを非同期で行うなどの設定
(setq comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. 外観とUI (Appearance and UI)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; フォント設定 (フォント名とサイズ)
(setq doom-font (font-spec :size 16))

;; テーマ設定
(setq doom-theme 'doom-tokyo-night)

;; UI要素の調整
(setq display-line-numbers-type t)   ; 行番号を常時表示
(setq org-hide-emphasis-markers t)   ; Orgファイルの強調表示マーカーを非表示
(tool-bar-mode 0)                   ; ツールバーを非表示
(menu-bar-mode 0)                   ; メニューバーを非表示


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. キーバインド (Keybindings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C-h/j/k/l でウィンドウ間を移動 (Normal, Visual, Insertモード)
(map! :nvi "C-h" #'evil-window-left
      :nvi "C-j" #'evil-window-down
      :nvi "C-k" #'evil-window-up
      :nvi "C-l" #'evil-window-right)



(map! :nvi "C-d" #'evil-window-delete)
;; C-c r で query-replace を呼び出し
(map! :map global-map
      "C-c r" #'query-replace)

(map! :nvi "C-f" #'tab-bar-switch-to-last-tab)




(map! :leader
      :prefix "n"  ; SPC n... というキーグループを作成
      :desc "Org Roam Zoom"
      "h" #'org-roam-ui-node-zoom)

(map! :leader
      :prefix "n"  ; SPC n... というキーグループを作成
      :desc "open roam ui"
      "d" #'org-roam-dailies-capture-date)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. パッケージごとの詳細設定 (Package-specific Configurations)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Org Mode & Org-roam
;;----------------------------------------------------------------------------
;;;### Org Mode & Org Roam ###
;;----------------------------------------------------------------------------
;; Org関連ファイルのディレクトリ設定
(setq org-directory (expand-file-name "~/Library/CloudStorage/GoogleDrive-rinichimrt@gmail.com/マイドライブ/02_Org_Roam/"))

(setq org-roam-directory (expand-file-name "01_Roam/" org-directory))

;; `org-agenda-files` には特定のファイルを指定します。
;; ここではキャプチャテンプレートで使われている tasks.org を指定します。
;; Org Roamのデイリーノートは、下の設定で自動的にアジェンダに追加されます。
(setq org-agenda-files (list (file-name-concat org-directory "tasks.org")))


(after! org
  ;; 見出しレベルごとの文字の高さ調整
  (set-face-attribute 'org-level-1 nil :height 1.3)
  (set-face-attribute 'org-level-2 nil :height 1.1)
  (set-face-attribute 'org-level-3 nil :height 1.05)

  ;; Org Capture テンプレートを設定
  (setq org-capture-templates
        '(("d" "Weekdays TODO" entry
           (file+headline (format "%s/tasks.org" org-directory) "Daily Tasks")
           "%[~/.doom.d/assets/org-templates/weekdays-todo.org]" :prepend t)
          ("w" "Weekends TODO" entry
           (file+headline (format "%s/tasks.org" org-directory) "Daily Tasks")
           "%[~/.doom.d/assets/org-templates/weekends-todo.org]" :prepend t)))

  ;; Org Pomodoro の設定
  (map! :leader
        :desc "Start Pomodoro" "o p" #'org-pomodoro)
  (setq org-pomodoro-finished-sound nil
        org-pomodoro-short-break-sound nil
        org-pomodoro-long-break-sound nil)
  (setq org-pomodoro-finished-hook
        (lambda () (rinichi/org-pomodoro-notify "Pomodoro finished! Take a break.")))
  (setq org-pomodoro-short-break-hook
        (lambda () (rinichi/org-pomodoro-notify "Short break time!")))
  (setq org-pomodoro-long-break-hook
        (lambda () (rinichi/org-pomodoro-notify "Long break time!"))))


(after! org-roam
  ;; リンクの表示テキストと見た目をカスタマイズ
  (setq org-roam-node-display-template "📝 ${title}")
  (set-face-attribute 'org-roam-link nil
                      :foreground "LightSkyBlue"
                      :weight 'semi-bold
                      :underline nil)
  (setq org-roam-agenda-restrict-to-user-files nil)

  ;; Org-roamのキーバインド設定 (SPC n <key>)
  (map! :leader
        :prefix "n"
        "f" #'org-roam-node-find       ; SPC n f でノード検索/作成
        "i" #'org-roam-node-insert     ; SPC n i でリンク挿入
        "b" #'org-roam-buffer-toggle   ; SPC n b でバックリンクバッファをトグル
        "r" #'org-roam-db-sync         ; SPC n r でDBを同期
        "t" #'org-roam-tag-find        ; SPC n t でタグ検索
        "g" #'org-roam-ui-open
        "d" #'org-roam-dailies-capture-date))


(after! org-roam-dailies
  ;; この設定により、Org Roamのデイリーノートが自動でアジェンダ対象になります
  (setq org-roam-dailies-include-in-agenda t))


(after! org-roam-ui
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))


;;; Org Mode の追加設定 (org-capture, org-pomodoroなど)
;;----------------------------------------------------------------------------
(after! org
  ;; 見出しレベルごとの文字の高さ調整
  (set-face-attribute 'org-level-1 nil :height 1.3)
  (set-face-attribute 'org-level-2 nil :height 1.1)
  (set-face-attribute 'org-level-3 nil :height 1.05)

  ;; Org Capture テンプレートを設定
  (setq org-capture-templates
        '(("d" "Weekdays TODO" entry
           (file+headline (format "%s/tasks.org" org-directory) "Daily Tasks")
           "%[~/.doom.d/assets/org-templates/weekdays-todo.org]" :prepend t)
          ("w" "Weekends TODO" entry
           (file+headline (format "%s/tasks.org" org-directory) "Daily Tasks")
           "%[~/.doom.d/assets/org-templates/weekends-todo.org]" :prepend t)))

  ;; Org Pomodoro タイマーのリーダーキーを設定 (SPC o p)
  (map! :leader
        :desc "Start Pomodoro" "o p" #'org-pomodoro)

  ;; ポモドーロの各種通知音を無効化
  (setq org-pomodoro-finished-sound nil
        org-pomodoro-short-break-sound nil
        org-pomodoro-long-break-sound nil)

  ;; macOSのterminal-notifierを使ってデスクトップ通知を出すための関数
  (defun rinichi/org-pomodoro-notify (msg)
    "Use terminal-notifier to show MSG as a notification."
    (start-process "org-pomodoro-notify" nil "terminal-notifier"
                   "-title" "Org Pomodoro"
                   "-message" msg))

  ;; ポモドーロの各イベントで通知関数を呼び出す
  (setq org-pomodoro-finished-hook
        (lambda () (rinichi/org-pomodoro-notify "Pomodoro finished! Take a break.")))
  (setq org-pomodoro-short-break-hook
        (lambda () (rinichi/org-pomodoro-notify "Short break time!")))
  (setq org-pomodoro-long-break-hook
        (lambda () (rinichi/org-pomodoro-notify "Long break time!"))))


;;; Vterm (ターミナルエミュレータ)
;;----------------------------------------------------------------------------
(after! vterm
  (add-hook 'vterm-mode-hook (lambda () (term-line-mode -1))))


;; in ~/.doom.d/config.el

;; vtermがzshをインタラクティブモードで起動するように設定
(setq vterm-shell "zsh"
      vterm-shell-args '("-i"))
;;; TRAMP (リモートファイル編集) のパフォーマンスチューニング
;;----------------------------------------------------------------------------
(with-eval-after-load 'tramp
  ;; 1. バージョン管理(Git等)の自動チェックを抑制
  (setq vc-ignore-dir-regexp tramp-file-name-regexp
        tramp-version-control nil)

  ;; 2. ファイルの自動保存と変更チェックを無効化
  (setq tramp-auto-save-directory nil
        tramp-check-for-file-transfer-verdicts nil)

  ;; 3. ファイル名補完時のディレクトリ再読み込みを減らす
  (setq tramp-completion-reread-directory-timeout 30))

;; TRAMPで開いたバッファにのみ適用される設定
(add-hook 'tramp-mode-hook
          (lambda ()
            ;; 4. モードラインを極限までシンプルにする
            (setq-local mode-line-format
                        '("%e"
                          mode-line-front-space
                          "[TRAMP] "
                          "%f"
                          " "
                          mode-line-modified
                          mode-line-end-spaces))
            ;; 5. リアルタイム構文チェックを無効化
            (flycheck-mode -1)))


(after! dired
  (setq dired-omit-files "^\\.[^.]") ;; .で始まり..でないものを隠す
  (add-hook 'dired-mode-hook #'dired-omit-mode))

(volatile-highlights-mode t)


;; (use-package mini-frame
;;   :config
;;   (mini-frame-mode 1))

(setq x-gtk-resize-child-frames 'resize-mode)
;; (custom-set-variables
;;  '(mini-frame-show-parameters
;;    '((top . 0.5)
;;      (width . 0.8)
;;      (left . 0.5)
;;      (height . 25))))

(after! org-roam
  (setq org-roam-agenda-restrict-to-user-files nil))


(after! org-roam-dailies
  (setq org-roam-dailies-include-in-agenda t))




;; 現在のディレクトリでmacOSのターミナルを開く関数を定義
(defun my/open-macos-terminal-here ()
  "Open the macOS Terminal app in the current buffer's directory."
  (interactive)
  (shell-command (concat "open -a Terminal " (shell-quote-argument default-directory))))

;; 上で定義した関数をキーボードショートカットに割り当てる
(map! :g "C-o" #'my/open-macos-terminal-here)

