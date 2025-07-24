;;; config.el -*- lexical-binding: t; -*-

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 1. 基本設定 (General Settings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; GPG設定、メール、スニペットなどで使用される個人情報を設定します (任意)
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Emacsフレームの透明度を設定 (0.0=完全透明, 1.0=不透明)
(add-to-list 'default-frame-alist '(alpha . (0.95 0.95)))

;; ファイルを直接削除せずmacOSのゴミ箱へ移動
(setq delete-by-moving-to-trash t)

;; テキストモードでの自動折り返しを無効化（正しい方法に修正済み）
(add-hook 'text-mode-hook (lambda () (auto-fill-mode -1)))

;; ネイティブコンパイルを非同期で行い、警告を抑制
(setq comp-deferred-compilation t
      native-comp-async-report-warnings-errors nil)

;; 揮発的なハイライト表示を有効化
(volatile-highlights-mode t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 2. 外観とUI (Appearance and UI)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; フォント設定
(setq doom-font (font-spec :size 16))

;; テーマ設定
(setq doom-theme 'doom-tokyo-night)

;; UI要素の調整
(setq display-line-numbers-type t) ; 行番号を常時表示

;; ツールバーとメニューバーを非表示にして画面を広く使う
(tool-bar-mode 0)
(menu-bar-mode 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 3. キーバインド (Keybindings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C-h/j/k/l でウィンドウ間を移動
(map! :nvi "C-h" #'evil-window-left
      :nvi "C-j" #'evil-window-down
      :nvi "C-k" #'evil-window-up
      :nvi "C-l" #'evil-window-right)

;; 現在のウィンドウを閉じる
(map! :nvi "C-d" #'evil-window-delete)

;; 前のタブに切り替え
(map! :nvi "C-f" #'tab-bar-switch-to-last-tab)

;; C-c r で検索・置換 (query-replace) を呼び出し
(map! :map global-map "C-c r" #'query-replace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 4. パッケージごとの詳細設定 (Package-specific Configurations)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;### Org Mode & Org Roam ###
;;----------------------------------------------------------------------------
;; Org関連ファイルのディレクトリ設定（ファイルAのGoogle Driveパスを採用）
(setq org-directory (expand-file-name "~/Library/CloudStorage/GoogleDrive-rinichimrt@gmail.com/マイドライブ/02_Org_Roam/"))
(setq org-roam-directory (expand-file-name "01_Roam/" org-directory))

;; `org-agenda-files` には特定のファイルを指定（ファイルAの正しい方法を採用）
(setq org-agenda-files (list (file-name-concat org-directory "tasks.org")))


  ;; Orgファイル内の強調表示マーカーを非表示にします
  (setq org-hide-emphasis-markers t)

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
           "%[~/.doom.d/assets/org-templates/weekends-todo.org]" :prepend t))))


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
        "g" #'org-roam-ui-open         ; SPC n g でUIを開く
        "d" #'org-roam-dailies-capture-date ; SPC n d でデイリーノート作成
        "h" #'org-roam-ui-node-zoom))   ; SPC n h でUIをズーム


(after! org-roam-dailies
  ;; この設定により、Org Roamのデイリーノートが自動でアジェンダ対象になります
  (setq org-roam-dailies-include-in-agenda t))

;; org-roam-ui の設定（ファイルBの堅牢な方法を採用）
(use-package! websocket :after org-roam)
(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))


;;;### Vterm (ターミナルエミュレータ) ###
;;----------------------------------------------------------------------------
(after! vterm
  (add-hook 'vterm-mode-hook (lambda () (term-line-mode -1))))
;; vtermがzshをインタラクティブモードで起動するように設定
(setq vterm-shell "zsh"
      vterm-shell-args '("-i"))


;;;### Dired (ファイラ) ###
;;----------------------------------------------------------------------------
;; ファイルマネージャでドットファイル (例: .DS_Store) をデフォルトで非表示にする
(after! dired
  (setq dired-omit-files "^\\.[^.]")
  (add-hook 'dired-mode-hook #'dired-omit-mode))


;;;### TRAMP (リモートファイル編集) ###
;;----------------------------------------------------------------------------
;; TRAMPは利用する際にコメントアウトを外してください
;; (with-eval-after-load 'tramp
;;   ;; パフォーマンスチューニング
;;   (setq vc-ignore-dir-regexp tramp-file-name-regexp
;;         tramp-version-control nil
;;         tramp-auto-save-directory nil
;;         tramp-check-for-file-transfer-verdicts nil
;;         tramp-completion-reread-directory-timeout 30))
;;
;; (add-hook 'tramp-mode-hook
;;           (lambda ()
;;             ;; リモート接続中はモードラインをシンプルにし、構文チェックを無効化
;;             (setq-local mode-line-format
;;                         '("%e" mode-line-front-space "[TRAMP] " "%f" " "
;;                           mode-line-modified mode-line-end-spaces))
;;             (flycheck-mode -1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; 5. カスタム関数とキーバインド (Custom Functions & Keybindings)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;### macOSのターミナルを現在位置で開く ###
;;----------------------------------------------------------------------------
(defun my/open-macos-terminal-here ()
  "Open the macOS Terminal app in the current buffer's directory."
  (interactive)
  (shell-command (concat "open -a Terminal " (shell-quote-argument default-directory))))

;; 上で定義した関数を C-c t に割り当て（安全なキーに変更済み）
(map! :g "C-c t" #'my/open-macos-terminal-here)
