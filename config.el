;;; config.el -*- lexical-binding: t; -*-

;; このファイルにプライベートな設定を記述します。
;; このファイルを変更した後に 'doom sync' を実行する必要はありません。


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. パッケージごとの詳細設定 (Package-specific Configurations)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Org Mode & Org-roam
;;----------------------------------------------------------------------------
;; Org関連ファイルのディレクトリ設定
(setq org-directory (file-truename "/Users/rinichimrt/Library/CloudStorage/Box-Box/chri22024/Org/"))
(setq org-roam-directory (file-truename (expand-file-name "Roam/" org-directory)))

;; Org Agendaが検索するファイルを指定 (org-directory以下の全.orgファイル)
(setq org-agenda-files (directory-files-recursively org-directory "\\.org$'"))

;; org-roamのリンクの見た目をカスタマイズ
(defface org-roam-link '((t (:inherit org-link)))
  "Face for org-roam links."
  :group 'org-roam)

(after! org-roam
  ;; リンクの表示テキストに接頭辞を追加 (例: 📝 タイトル)
  (setq org-roam-node-display-template "📝 ${title}")
  ;; リンクの色とスタイルを変更
  (set-face-attribute 'org-roam-link nil
                      :foreground "LightSkyBlue"
                      :weight 'semi-bold
                      :underline nil))

;; Org-roamのキーバインド設定 (SPC n <key>)
(after! org-roam
  (map! :leader
        :prefix "n"
        "f" #'org-roam-node-find        ; SPC n f でノード検索/作成
        "i" #'org-roam-node-insert      ; SPC n i でリンク挿入
        "b" #'org-roam-buffer-toggle    ; SPC n b でバックリンクバッファをトグル
        "r" #'org-roam-db-sync          ; SPC n r でDBを同期
        "t" #'org-roam-tag-find         ; SPC n t でタグ検索
        "g" #'org-roam-ui-open
        ))

;; Org-roam UI の設定
(after! org-roam-ui
  (map! :leader
        :prefix "n"
        "g" #'org-roam-ui-open) ; SPC n g でOrg-roam UIを開く
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


(use-package mini-frame
  :config
  (mini-frame-mode 1))

(setq x-gtk-resize-child-frames 'resize-mode)
(custom-set-variables
 '(mini-frame-show-parameters
   '((top . 0.5)
     (width . 0.8)
     (left . 0.5)
     (height . 15))))
