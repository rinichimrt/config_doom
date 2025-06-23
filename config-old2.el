;;; config.el -*- lexical-binding: t; -*-

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; このファイルにプライベートな設定を記述します。
;; このファイルを変更した後に 'doom sync' を実行する必要はありません。

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 1. 基本情報・設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; GPG設定、メール、スニペットなどで使用される個人情報を設定します (任意)
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")


(add-to-list 'default-frame-alist '(alpha . (0.95 0.95)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 2. 外観とUI (Appearance and UI)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; フォント設定
;; ----------------------------------------------------------------
;; Doom Emacsが使用する基本フォントとサイズを設定します。
(setq doom-font (font-spec :size 16))


;;; テーマ設定
;; ----------------------------------------------------------------
;; Doom Emacsが使用するテーマを設定します。
(setq doom-theme 'doom-tokyo-night)


;;; UI要素の調整
;; ----------------------------------------------------------------
;; 行番号の表示スタイルを設定します。(t は絶対行番号、'relative' は相対行番号)
(setq display-line-numbers-type t)

;; macOSのGUIで表示される上部のツールバーを非表示にします。
(tool-bar-mode 0)
;; macOSのGUIで表示される上部のメニューバーを非表示にします。
(menu-bar-mode 0)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 3. キーバインド (Keybindings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C-h/j/k/l でウィンドウ間を移動できるようにキーを設定します。(ノーマル、ビジュアル、挿入モードで有効)
(map! :nvi "C-h" #'evil-window-left
      :nvi "C-j" #'evil-window-down
      :nvi "C-k" #'evil-window-up
      :nvi "C-l" #'evil-window-right)

;; C-c r で query-replace (対話的置換) を呼び出せるようにします。
(map! :map global-map
      "C-c r" #'query-replace)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 4. パッケージごとの詳細設定 (Package-specific Configurations)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Org Mode の設定
;; ----------------------------------------------------------------
;; org-mode関連のファイルが保存されるデフォルトディレクトリを設定します。
;; この設定はorgモジュールの読み込み前に評価される必要があります。
(setq org-directory "~/org/")
;; 別のBox上のディレクトリを指定していた設定例。必要に応じてこちらを有効化してください。
;; (setq org-directory "~/Library/CloudStorage/Box-Box/chri22024/Tasks/2025-Tasks/")

;; `org` モジュールが読み込まれた後に実行される設定をここにまとめます。
(after! org
  ;; --- Org Capture ---
  ;; キャプチャテンプレートを設定します。
  (setq org-capture-templates
        '(("d" "Weekdays TODO" entry
           (file+headline (format "%s/tasks.org" org-directory) "Daily Tasks")
           "%[~/.doom.d/assets/org-templates/weekdays-todo.org]" :prepend t)
          ("w" "Weekends TODO" entry
           (file+headline (format "%s/tasks.org" org-directory) "Daily Tasks")
           "%[~/.doom.d/assets/org-templates/weekends-todo.org]" :prepend t)))

  ;; --- Org Pomodoro ---
  ;; ポモドーロタイマーのリーダーキーを設定します (SPC o p)
  (map! :leader
        :desc "Start Pomodoro" "o p" #'org-pomodoro)

  ;; ポモドーロの各種通知音を無効化します。
  (setq org-pomodoro-finished-sound nil
        org-pomodoro-short-break-sound nil
        org-pomodoro-long-break-sound nil)

  ;; macOSのterminal-notifierを使ってデスクトップ通知を出すための関数を定義します。
  (defun rinichi/org-pomodoro-notify (msg)
    "Use terminal-notifier to show MSG as a notification."
    (start-process "org-pomodoro-notify" nil "terminal-notifier"
                   "-title" "Org Pomodoro"
                   "-message" msg))

  ;; ポモドーロの各イベント（作業終了、短い休憩、長い休憩）で上記の通知関数を呼び出します。
  (setq org-pomodoro-finished-hook
        (lambda () (rinichi/org-pomodoro-notify "Pomodoro finished! Take a break.")))
  (setq org-pomodoro-short-break-hook
        (lambda () (rinichi/org-pomodoro-notify "Short break time!")))
  (setq org-pomodoro-long-break-hook
        (lambda () (rinichi/org-pomodoro-notify "Long break time!")))


  ;; --- Org Appearance ---
  ;; Orgファイル内の強調表示マーカー（*, /, _, +など）を非表示にして見た目をスッキリさせます。
  (setq org-hide-emphasis-markers t)

  ;; 見出しレベルごとに文字の高さを調整します。
  (set-face-attribute 'org-level-1 nil :height 1.3)
  (set-face-attribute 'org-level-2 nil :height 1.1)
  (set-face-attribute 'org-level-3 nil :height 1.05)
  ;; (set-face-attribute 'org-level-4 nil :height 1.0)
  )


;;; Vterm (ターミナルエミュレータ) の設定
;; ----------------------------------------------------------------
(after! vterm
  ;; vterm利用時に、一行ずつ処理するモード(term-line-mode)ではなく、
  ;; 文字単位で処理するモード(char-mode)をデフォルトにします。
  (add-hook 'vterm-mode-hook (lambda () (term-line-mode -1))))


;;; TRAMP (リモートファイル編集) の設定
;; ----------------------------------------------------------------
(with-eval-after-load 'tramp
  ;; TRAMP利用時にバージョン管理機能(vc-mode)を無効化し、動作を高速化します。
  (add-hook 'tramp-pre-connection-hook
            (lambda (_method _user _host)
              (setq-default vc-ignore-dir-regexp tramp-file-name-regexp)))

  ;; TRAMPでの自動保存を無効にし、入力中のカクつきを減らします。
  (setq tramp-auto-save-directory nil)

  ;; リモートディレクトリのファイル一覧表示のもたつきを軽減するため、タイムアウトを延長します。
  (setq tramp-completion-reread-directory-timeout 30))
(with-eval-after-load 'tramp
  (message "TRAMP performance tuning loaded.")

  ;; 1. [最重要] バージョン管理(Git等)の自動チェックを抑制する
  ;;    ファイルを開いたり保存したりする際の `git` コマンド実行を止めます。
  ;;    これが体感速度に最も効く場合があります。
  (setq vc-ignore-dir-regexp tramp-file-name-regexp
        tramp-version-control nil)

  ;; 2. ファイルの自動保存と変更チェックを無効化する
  ;;    入力中のカクつきの原因となりうる、定期的な書き込みや確認を止めます。
  (setq tramp-auto-save-directory nil
        tramp-check-for-file-transfer-verdicts nil)

  ;; 3. ファイル名補完時のディレクトリ再読み込みを減らす
  ;;    C-x C-f でディレクトリを閲覧する際、毎回 `ls` を実行するのを防ぎます。
  (setq tramp-completion-reread-directory-timeout 30) ; 30秒間キャッシュする
  )

;; TRAMPで開いたバッファにのみ適用される設定
(add-hook 'tramp-mode-hook
          (lambda ()
            ;; 4. [効果大] モードラインを極限までシンプルにする
            ;;    ステータスバー表示のための不要な処理をなくし、入力中のラグを軽減します。
            (setq-local mode-line-format
                        '("%e" ; エラー表示
                          mode-line-front-space
                          "[TRAMP] " ; TRAMP接続中であることを示す
                          "%f"       ; ファイル名
                          " "
                          mode-line-modified
                          mode-line-end-spaces))

            ;; 5. リアルタイム構文チェックを無効化する
            (flycheck-mode -1)
            ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 5. Emacsの基本動作とその他 (Basic Emacs Behavior & Miscellaneous)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ファイルを削除する際に、直接削除せずmacOSのゴミ箱へ移動するようにします。
(setq delete-by-moving-to-trash t)

;; テキストモードで自動的に改行（折り返し）する機能を無効にします。
(setq text-mode-hook 'turn-off-auto-fill)

;; ネイティブコンパイルを非同期で行うなどの設定です。
(setq comp-deferred-compilation t)
(setq native-comp-async-report-warnings-errors nil)





;; Orgファイルのルートディレクトリを設定（例: ~/org/ 以下にまとめる）
(setq org-directory "/Users/rinichimrt/Library/CloudStorage/Box-Box/chri22024/Org/")

;; Org Agendaが検索するファイルを指定
;; ここでは ~/org/ 以下の全ての.orgファイルとサブディレクトリを対象にする
(setq org-agenda-files (list org-directory))




;; ;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; ;; Org-roamファイルを保存するディレクトリを設定
;; ;; Org-roam v2からは、~/.doom.d/org-roam/ がデフォルトディレクトリになりますが、
;; ;; 既存のノートがある場合は、そのディレクトリを指定します。
(setq org-roam-directory (file-truename "/Users/rinichimrt/Library/CloudStorage/Box-Box/chri22024/Org/Roam/"))
(setq find-file-visit-truename t)
;; （オプション）新規ノード作成時にタイトル入力を促す
(setq org-roam-node-display-templates
      '((title . "Node : ${title}")
        (file . "Node : ${file}")))


(setq org-roam-link-display-templates
      '((id . "Node : ${title}")))

;; Org-roam UIの自動起動設定（+roam-ui フラグを有効にした場合）
;; ;; Doom Emacsではuse-packageの:configセクションなどで設定するのが一般的ですが、
;; ;; +roam-ui フラグを使う場合、多くはDoomが自動で設定してくれます。
;; ;; もし起動しない場合は以下の設定を試してみてください。
;; (after! org-roam-ui
;;   (setq org-roam-ui-open-on-start t))
(use-package! websocket
    :after org-roam)

(use-package! org-roam-ui
    :after org-roam ;; or :after org
;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
;;         a hookable mode anymore, you're advised to pick something yourself
;;         if you don't care about startup time, use
;;  :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
