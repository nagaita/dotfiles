;;; init.el --- configuration for emacs
;;; Commentary:
;;; Code:

(defun add-to-laod-path (&rest paths)
  "Add PATHS and subdirectory to load path."
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

(add-to-laod-path "public-repos" "site-lisp" "elpa")

;;
;; ローカルなファイルは .emacs.d ではなく .emacs.local に保存する
;;
(defconst my-local-dir "~/.emacs.local")
(defun make-local-dir ()
  "Make directory for local file if my-local-dir does not exist."
  (if (not (file-directory-p my-local-dir))
      (make-directory my-local-dir)))
(add-hook 'emacs-startup-hook 'make-local-dir)

(defun create-local-file-path (path)
  "Create my-local-dir/PATH as local file path."
  (concat my-local-dir "/" path))

;; font size
(when window-system
  (set-face-font
   'default
   "-unknown-Ubuntu Mono-normal-normal-normal-*-22-*-*-*-m-0-iso10646-1"))
;; theme
(load-theme 'misterioso t)
(setq default-frame-alist
      (append (list '(cursor-color . "white")) default-frame-alist))

;;初期メッセージ・*scratch* 非表示
(setq inhibit-startup-message t)

;; emacs 起動時間の短縮
(modify-frame-parameters nil '((wait-for-wm . nil)))

;; ウィンドウの設定
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; モードラインにカーソル位置が何行目かを表示
(line-number-mode t)
;; モードラインにカーソル位置が何文字目かを
(column-number-mode t)
;; モードラインに時刻を表示
(display-time)
;;カーソルを点滅させる
(blink-cursor-mode t)
;;対応する括弧を光らせる
(show-paren-mode t)
;;ウィンドウ内に収まらないとき括弧内も光らせる
(require 'paren)
(setq show-paren-style 'mixed)
;; ファイル保存前に行末の空白を削除 （自動保存と相性が悪い）
;; (add-hook 'before-save-hook 'delete-trailing-whitespace)
;; 行末の余分な空白を強調表示
(setq-default show-trailing-whitespace t)
;; 行番号
(when window-system
  ;;デフォルトで linum-mode を有効にする
  (global-linum-mode t)
  ;;3桁分のスペースを確保
  (setq linum-format "%3d"))

;;ピープ音なし
(setq visible-bell t)
;;画面フラッシュなし
(setq ring-bell-function 'ignore)
;; yes/no の入力を y/n に
(defalias 'yes-or-no-p 'y-or-n-p)
;; キーストロークのエコーを早くする
(setq echo-keystrokes 0.1)
;; バックアップファイルを作らない
(setq backup-inhibited t)
;; 終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)
;; バッファの最後でnewlineで新規行を追加するのを禁止する
(setq next-line-add-newlines nil)
;; 最終行の改行に改行がないとき, 自動的に入れる
(setq require-final-newline t)
;; evalした結果を全部表示
(setq eval-expression-print-length nil)
;; タブを使用しない
(setq-default indent-tabs-mode nil)
;; emacs を閉じてもカーソルの位置を保存しておく
(require 'saveplace)
(setq-default save-place t)
;; 補完時に大文字小文字を区別しない (Non-nilでON, nilでOFF)
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
(setq read-buffer-completion-ignore-case t)
;; ファイルに変更があったらバッファを自動リロード
(global-auto-revert-mode 1)

;;; 部分一致の補完機能を使う (t:ON/nil:OFF)
;;; p-bでprint-bufferとか
;;(partial-completion-mode 1)

;;; 補完可能なものを随時表示 (t:ON/nil:OFF)
;;(icomplete-mode 1)

;;; 履歴数
(setq history-length 10000) ; default 30

;;; ミニバッファの履歴を保存する (t:ON/nil:OFF)
(savehist-mode 1)
(setq savehist-file (create-local-file-path "savehist"))

;;; gzファイルも編集できるようにする
(auto-compression-mode t)

;;; ediffを1ウィンドウで実行
(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;; diffのオプション
(setq diff-switches '("-u" "-p" "-N"))

;;; リージョンの大文字小文字変換を有効にする。
;; C-x C-u -> upcase
;; C-x C-l -> downcase
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;;
;; file browser
;;
(require 'dired-x)
(require 'wdired)
(define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)

;;; 自動改行OFF
;;(add-hook 'text-mode-hook (function (lambda () (auto-fill-mode 1))))
;;(setq fill-column nil)
(setq text-mode-hook 'turn-off-auto-fill)
(setq truncate-lines t)

;;
;; global key bindings
;;______________________________________________________________________________
;; 全角を半角に
(define-key global-map (kbd "、") '(lambda () (interactive) (insert "，")))
(define-key global-map (kbd "。") '(lambda () (interactive) (insert "．")))
(define-key global-map (kbd "　") '(lambda () (interactive) (insert " ")))
(define-key global-map (kbd "？") '(lambda () (interactive) (insert "?")))
(define-key global-map (kbd "０") '(lambda () (interactive) (insert "0")))
(define-key global-map (kbd "１") '(lambda () (interactive) (insert "1")))
(define-key global-map (kbd "２") '(lambda () (interactive) (insert "2")))
(define-key global-map (kbd "３") '(lambda () (interactive) (insert "3")))
(define-key global-map (kbd "４") '(lambda () (interactive) (insert "4")))
(define-key global-map (kbd "５") '(lambda () (interactive) (insert "5")))
(define-key global-map (kbd "６") '(lambda () (interactive) (insert "6")))
(define-key global-map (kbd "７") '(lambda () (interactive) (insert "7")))
(define-key global-map (kbd "８") '(lambda () (interactive) (insert "8")))
(define-key global-map (kbd "９") '(lambda () (interactive) (insert "9")))

;;
;; M-(1文字)
;;
;; コメントアウト
(define-key global-map (kbd "M-;") 'comment-dwim)
;; default:
;;    M-h    mark-paragraph
;;    M-<BS> backward-kill-word
(define-key global-map (kbd "M-h") 'backward-kill-word)

;;
;; M-C-(1文字)
;;
(define-key global-map (kbd "C-M-g") 'grep)
;; フレームの切り替え
(define-key global-map (kbd "C-M-n") 'next-multiframe-window)
(define-key global-map (kbd "C-M-p") 'previous-multiframe-window)

;;
;; C-(1文字) の設定
;;
(global-set-key (kbd "C-h") 'delete-backward-char)
(global-set-key (kbd "C-m") 'newline-and-indent)

(defun other-window-or-split ()
  "Split window horizontally if frame does not has tow windows."
  (interactive)
  (when (one-window-p) (split-window-horizontally))
  (other-window 1))
(global-set-key (kbd "C-t") 'other-window-or-split)
(define-key dired-mode-map (kbd "C-t") 'other-window)

;; 略語展開・補完を行うコマンドをまとめる
(global-set-key (kbd "C-;") 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-complete-file-name-partially      ; ファイル名の一部
	try-complete-file-name                ; ファイル名全体
	try-expand-all-abbrevs                ; 静的展開
	try-expand-dabbrev                    ; 動的展開(カレントバッファ)
	try-expand-dabbrev-all-buffers        ; 動的展開(全バッファ)
	try-expand-dabbrev-from-kill          ; 動的展開(キリング: M-w/C-w の履歴)
	try-complete-lisp-symbol-partially    ; Lispシンボル名の一部
	try-complete-lisp-symbol))            ; Lispシンボル名の全体
(global-set-key (kbd "<hiragana-katakana>") 'my-run-shell)

;;
;; C-c (1文字)
;;
(define-key global-map (kbd "C-c c") 'smart-compile)
(define-key global-map (kbd "C-c h") 'help-for-help)
(define-key global-map (kbd "C-c i") 'indent-region)
(define-key global-map (kbd "C-c m") 'compile)            ; make
(define-key global-map (kbd "C-c n") 'next-error)         ; エラー箇所に移動
(define-key global-map (kbd "C-c p") 'ispell-buffer)      ; スペルチェッカ
(defun my-run-shell ()
  "Move cursor to end of buffer after run eshell."
  (interactive)
  (eshell)
  (goto-char (point-max)))
;;(define-key global-map (kbd "C-c w") 'w3m)                ; emacs-w3m

;;
;; C-c C-(1文字)
;;
(define-key global-map (kbd "C-c C-o") 'fold-dwim-toggle)
(define-key global-map (kbd "C-c C-n") 'fold-dwim-hide-all)
(define-key global-map (kbd "C-c C-k") 'fold-dwim-show-all)

;;; 警告
(require 'warnings)

;;; スペルチェック
(require 'ispell)
(setq-default ispell-program-name "aspell")
(setq ispell-dictionary "american")

;;
;; eshell
;;
(setq eshell-directory-name (create-local-file-path "eshell"))

;;
;; flymake
;;______________________________________________________________________________
(require 'flymake)
(setq flymake-allowed-file-name-masks
      '(("\\.\\(?:c\\(?:pp\\|xx\\|\\+\\+\\)?\\|CC\\)\\'" flymake-simple-make-init)
	("\\.xml\\'" flymake-xml-init)
	("\\.html?\\'" flymake-xml-init)
	("\\.cs\\'" flymake-simple-make-init)
	("\\.p[ml]\\'" flymake-perl-init)
	("\\.php[345]?\\'" flymake-php-init)
	("\\.h\\'" flymake-master-make-header-init flymake-master-cleanup)
	;;("\\.java\\'" flymake-simple-make-java-init flymake-simple-java-cleanup)
	;; use ant instead of make
	("\\.java\\'" flymake-simple-ant-java-init flymake-master-cleanup)
	("[0-9]+\\.tex\\'" flymake-master-tex-init flymake-master-cleanup)
	("\\.tex\\'" flymake-simple-tex-init)
	("\\.idl\\'" flymake-simple-make-init)))

;; fix build.xml pathname error
(defun flymake-get-ant-cmdline (source base-dir)
  (list "ant"
	(list "-buildfile"
	      (concat base-dir "build.xml"))))

;; fix base-dir pathname error
(defun flymake-init-find-buildfile-dir (source-file-name buildfile-name)
  "Find buildfile, store its dir in buffer data and return its dir, if found."
  (let* ((buildfile-dir
          (flymake-find-buildfile buildfile-name
                                  (file-name-directory source-file-name))))
    (if buildfile-dir
        (setq flymake-base-dir (expand-file-name buildfile-dir))
      (flymake-log 1 "no buildfile (%s) for %s" buildfile-name source-file-name)
      (flymake-report-fatal-status
       "NOMK" (format "No buildfile (%s) found for %s"
                      buildfile-name source-file-name)))))

(add-hook 'java-mode-hook
	  '(lambda ()
	     (flymake-mode)))

;; *.sh ファイルの保存時に、自動で実行権限を与える
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;;
;; ファイル名が重複したとき，バッファの表示をわかりやすくする
;;
(require 'uniquify)
;; filename<dir> 形式のバッファ名にする
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; * で囲まれたバッファ名は対外にする
(setq uniquify-ignore-buffers-re "*[^*]+*")

;;
;; 現在位置のファイル/URLを開く
;;
(ffap-bindings)

;;
;; C言語のプリプロセッサを隠す
;;
(require 'hideif)
(add-hook 'c-mode-common-hook 'hide-ifdef-mode)

;;
;; 現在の関数名を表示する
;;
(require 'which-func)
(which-function-mode 1)
;; すべてのメジャーモードに対して which-func-mode を適用する
(setq which-func-mode t)
;; 関数名を画面上部に表示するための設定
(delete (assoc 'which-func-mode mode-line-format) mode-line-format)
(setq-default header-line-format '(which-func-mode ("" which-func-format)))

(autoload 'w3m-region "w3m"
  "Render region in current buffer and replace with result." t)
;; ブラウザは, emacs-w3m.
(setq browse-url-browser-function 'w3m-browse-url)

;; for emacsclient
(require 'server)
(unless (server-running-p)
  (server-start))

(defun auto-elisp-evaluation ()
  "Evaluation elisp file after elisp is saved."
  (interactive)
  (when (string-match "\\.el$" buffer-file-name)
    (eval-buffer)
    (message "auto-elisp-evaluation %s completed"
	     (file-name-nondirectory (buffer-file-name)))))
(add-hook 'after-save-hook 'auto-elisp-evaluation)

;; ediff関連のバッファを1つのフレームにまとめる
(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;
;; gist.el
;;
(require 'gist)

;;
;; auto-async-byte-compile
;;    el ファイルを保存すると elc ファイルを自動生成
;;______________________________________________________________________________
(require 'auto-async-byte-compile)
(setq auto-async-byte-compile-exclude-files-regexp "/junk/")
(add-hook 'emacs-lisp-mode-hook 'enable-auto-async-byte-compile-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;; すぐに表示する
(setq eldoc-idle-delay 0.2)
;; モードラインに eldoc を表示しない
(setq eldoc-minor-mode-string "")
;; find-function を割り当てる
(find-function-setup-keys)

;;== sequential-command.el =================
;; 同じコマンドを連続実行したとき，
;; 気の利いた振る舞いをするようになる
;; (c-a, c-e, m-C, M-U, ...)
;;==========================================
(require 'sequential-command-config)
(sequential-command-setup-keys)

;;== ipa.el ==========================
;; ファイルに直接書きこまずにメモをとる
;;====================================
(require 'ipa)

;;== tempbuf.el ======================
;; 使わなくなったバッファを自動的に消す
;;====================================
(require 'tempbuf)
;; ファイルを開いたら自動的に tmpbuf を有効にする
(add-hook 'find-file-hooks 'turn-on-tempbuf-mode)
;; dired バッファに対して tempbuf を有効にする
(add-hook 'dired-mode-hook 'turn-on-tempbuf-mode)

;;== popwin.el =================
;; バッファをポップアップ表示する
;;==============================
(require 'popwin)
(setq display-buffer-function 'popwin:display-buffer)
;; diredバッファをフレームの上部にポップアップ表示
(push '(dired-mode :position top) popwin:special-display-config)

;;== smart-compile.el =====
;; m-x compile の挙動の改善
;;=========================
(require 'smart-compile)

;;== key-chord.el =====
;; キー同時押しコマンド
;;=====================
(require 'key-chord)
(setq key-chord-two-keys-delay 0.05)
(key-chord-mode 1)
(key-chord-define-global "ui" 'magit-status)

;;== auto-complete ===
;; ideのような入力支援
;;====================
(require 'auto-complete-config)
(ac-config-default)
(setq ac-comphist-file (create-local-file-path "ac-comphist.dat"))

;;== undo-tree =======
;; undo コマンドの改善
;;====================
(require 'undo-tree)
(global-undo-tree-mode)

;;== undohist ==========
;; undo の履歴管理を改善
;;======================
(require 'undohist)
(undohist-initialize)
(setq undohist-directory (create-local-file-path "undohist"))

;;== minor-mode-hack =============
;; マイナーモード衝突問題を解決する
;;================================
(require 'minor-mode-hack)

;;== auto-save-buffers =====
;; ファイルを自動で保存する
;;==========================
(require 'auto-save-buffers)
;; アイドル 0.1 秒で保存 / *.el だけ除外
(run-with-idle-timer 0.5 t 'auto-save-buffers "" "\\.el$")

;;== hideshow.el =======
;; ブロックを折りたたむ
;;======================
(require 'hideshow)
(require 'fold-dwim)
(add-hook 'c-mode-common-hook 'hs-minor-mode)

;;
;; hatena daily
;;______________________________________________________________________________
(cond ((locate-library "hatena-diary-mode")
       "hatena-diary-mode.elが存在する"
       (autoload 'hatena "hatena-diary-mode" nil t)
       (eval-after-load "hatena-diary-mode"
	 '(progn
	    (message "load file hatena-diary-mode.el.")
            (setq hatena-usrid "taczge")
	    (setq hatena-twitter-flag t))))
      (t
       "hatena-diary-mode.elが存在しない"
       (message "cannot find file hatena-diary-mode.el.")))
(add-hook 'hatena-diary-mode-hook 'hatenahelper-mode)

;;
;; hatenahelper-mode
;;______________________________________________________________________________
(autoload 'hatenahelper-mode "hatenahelper-mode" nil t)

;;== html-helper-mode ==
;; html記法の入力支援
;;======================
(autoload 'html-helper-mode "html-helper-mode" nil t)

;;== open-junk-file.el =====
;; 試行錯誤用ファイルを開く
;;==========================
(require 'open-junk-file)
(setq open-junk-file-format "~/.junk/%y/%m/%d-%h%m%s.")
(global-set-key (kbd "C-x C-z") 'open-junk-file)

;;== lispxmp.el ==========
;; 式の評価結果を注釈する
;;========================
(require 'lispxmp)
(define-key emacs-lisp-mode-map (kbd "C-c C-d") 'lispxmp)

;;== paredit.el ================
;; 括弧の対応を保持して編集する
;;==============================
(require 'paredit)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hooc 'enable-paredit-mode)
(add-hook 'ielm-mode-hook 'enable-paredit-mode)

;;== sdic ============
;; emacs 上で動く辞書
;;====================
;;; sdic-mode 用の設定
(autoload 'sdic-describe-word
  "sdic" "英単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word)
(autoload 'sdic-describe-word-at-point
  "sdic" "カーソルの位置の英単語の意味を調べる" t nil)
(global-set-key "\C-cw" 'sdic-describe-word-at-point)
(setq sdic-eiwa-dictionary-list
      ;;英和検索で使用する辞書
      '( (sdicf-client "/usr/local/share/dict/gene.sdic"))
      ;; 和英検索で使用する辞書
      sdic-waei-dictionary-list
      '((sdicf-client "/usr/local/share/dict/jedict.sdic")))
;; 文字色
(setq sdic-face-color "pink")

;;== js2-mode ===========================
;; javascript を書くためのマイナーモード
;;=======================================
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

;;== hiwin =================================================
;; アクティブウィンドウを目立たせる
;;    色見本: http://suiten.wig.nu/text/diary/1999/rgb.html
;;==========================================================
(require 'hiwin)
;; hiwin-modeを有効化
(hiwin-activate)
;; 非アクティブウィンドウの背景色を設定
(set-face-background 'hiwin-face "grey48")

;;
;; color-moccur
;;______________________________________________________________________________
(require 'color-moccur)

;;
;; moccur-edit
;;______________________________________________________________________________
(require 'moccur-edit)

;;
;; magit
;;______________________________________________________________________________
(autoload 'magit "magit" t)

;; diffの表示方法を変更
(defun diff-mode-setup-faces ()
  ;; 追加された行は緑で表示
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "dark green")
  ;; 削除された行は赤で表示
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "dark red")
  ;; 文字単位での変更箇所は色を反転して強調
  (set-face-attribute 'diff-refine-change nil
                      :foreground nil :background nil
                      :weight 'bold :inverse-video t))
(add-hook 'diff-mode-hook 'diff-mode-setup-faces)

;; diffを表示したらすぐに文字単位での強調表示も行う
(add-hook 'diff-mode-hook 'diff-mode-refine-automatically)
(add-hook 'diff-mode-hook '(lambda (diff-auto-refine-mode t)))

;; diff関連の設定
(defun magit-setup-diff ()
  ;; diffを表示しているときに文字単位での変更箇所も強調表示する
  ;; 'allではなくtにすると現在選択中のhunkのみ強調表示する
  (setq magit-diff-refine-hunk 'all)
  ;; diff用のfaceを設定する
  (diff-mode-setup-faces)
  ;; diffの表示設定が上書きされてしまうのでハイライトを無効にする
  (set-face-attribute 'magit-item-highlight nil :inherit nil))
(add-hook 'magit-mode-hook 'magit-setup-diff)

;;
;; scala-mode
;; ref: http://d.hatena.ne.jp/tototoshi/20100925/1285420294#
(require 'scala-mode2)
(add-to-list 'auto-mode-alist
             '("\\.scala" . scala-mode2)
             '("\\.sbt\\'" . scala-mode2))

(require 'sstdd)
(add-hook 'scala-mode-hook
	  '(lambda ()
             (local-set-key (kbd "C-c 9")
                            'sstdd-cmd-toggle-testing-pair)
             (local-set-key (kbd "C-c 0")
                            'sstdd-insert-test-only-command-to-eshell)))

;;
;; point-undo
;;
(require 'point-undo)
;;(define-key global-map (kbd "M-[") 'point-undo)
;;(define-key global-map (kbd "M-]") 'point-redo)


;;
;; ファイルの位置にブックマークをつける
;;______________________________________________________________________________
(require 'bm)
(setq-default bm-buffer-persistence nil)
(setq bm-restore-repository-on-load t)
(add-hook 'find-file-hooks 'bm-buffer-restore)
(add-hook 'kill-buffer-hook 'bm-buffer-save)
(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(add-hook 'vc-before-checkin-hook 'bm-buffer-save)
(global-set-key (kbd "M-@") 'bm-toggle)
(global-set-key (kbd "M-[") 'bm-previous)
(global-set-key (kbd "M-]") 'bm-next)

;;
;; quickrun
;;______________________________________________________________________________
(require 'quickrun)
;; 結果の出力バッファと元のバッファを行き来したい場合は
;; ':stick t'の設定をするとよいでしょう
(push '("*quickrun*") popwin:special-display-config)
(global-set-key (kbd "C-c c") 'quickrun)

(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)

;; w.r.t. elisp unit test
(require 'ert-expectations)
(require 'el-mock)

;; tree
(eval-after-load "tree-widget"
  '(if (boundp 'tree-widget-themes-load-path)
       (add-to-list 'tree-widget-themes-load-path "~/.emacs.d/")))
(autoload 'imenu-tree "imenu-tree" "imenu tree" t)
(autoload 'tags-tree "tags-tree" "tags tree" t)

;;
;; multiple-cursors
;;______________________________________________________________________________
(require 'multiple-cursors)
(setq mc/list-file (create-local-file-path ".mc-lists.el"))
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-*") 'mc/mark-all-like-this)

;;
;; expand-region
;;______________________________________________________________________________
(require 'expand-region)
(global-set-key (kbd "C-`") 'er/expand-region)
(global-set-key (kbd "C-M-`") 'er/contract-region)

;;
;; doc view
;;
(add-hook 'doc-view-mode-hook
          (lambda ()
            (local-set-key (kbd "C-t") 'other-window)
            (add-hook 'doc-view-mode-hook 'auto-revert-mode)))

;;
;; grep-deit.el
;;______________________________________________________________________________
(require 'grep-edit)

;;
;; 日本語校正
;;______________________________________________________________________________
(require 'yspel)

;;
;; jump around
;;______________________________________________________________________________
(require 'ace-jump-mode)
(global-set-key (kbd "C-c SPC") 'ace-jump-mode)

;;
;; package
;;______________________________________________________________________________
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;
;; w3m
;;______________________________________________________________________________
(autoload 'w3m "w3m" "w3m mode" t)

;;
;; hatena
;;______________________________________________________________________________
(require 'hatena-diary)
(require 'hatena-markup-mode)
(setq hatena:d:major-mode 'hatena:markup-mode)
(require 'hatena-multi-mode)
(add-hook 'hatena:markup-mode-hook 'hatena:multi-mode)

;;
;; for turtle
;;______________________________________________________________________________
(autoload 'ttl-mode "ttl-mode" "major mode for owl or turtle files" t)
(add-hook 'ttl-mode-hook    ; turn on font lock when in ttl mode
          'turn-on-font-lock)
(setq auto-mode-alist
      (append
       (list
        '("\\.n3" . ttl-mode)
        '("\\.ttl" . ttl-mode))
       auto-mode-alist))

;;
;; for sparql
;;______________________________________________________________________________
(autoload 'sparql-mode "sparql-mode.el"
  "major mode for editing sparql files" t)
(add-to-list 'auto-mode-alist '("\\.sparql$" . sparql-mode))
(add-to-list 'auto-mode-alist '("\\.rq$" . sparql-mode))
;;(add-to-list 'ac-dictionary-files "/path/to/sparql-mode-dir/sparql-mode")
;;(add-hook 'sparql-mode-hook 'auto-complete-mod)e

;;
;; for markdown
;;______________________________________________________________________________
(autoload 'markdown-mode "markdown-mode"
  "major mode for editing markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;;
;; flycheck
;;______________________________________________________________________________
(add-hook 'after-init-hook #'global-flycheck-mode)

;;
;; pomodoro
;;______________________________________________________________________________
(require 'pomodoro)
(setq pomodoro:file "~/dropbox/org/pom.org")

;;; -*- mode:emacs-lisp; coding:utf-8 -*-
;;
;; yasnippet
;;______________________________________________________________________________
(require 'yasnippet-config)
(yas/setup "~/.emacs.d/site-lisp/yasnippet-0.6.1c/")

;; ファイル作成時にスニペットを自動展開するもの
(require 'autoinsert)
(auto-insert-mode)

;; *.h ファイル
(define-auto-insert "\\.h$"
  '(lambda () (insert "cc-header-file-template")(yas/expand)))

;; *.c ファイル
(define-auto-insert "\\.c$"
  '(lambda () (insert "cc-file-template")(yas/expand)))

;; *.tex ファイル
(define-auto-insert "\\.tex$"
  '(lambda () (insert "yatex-template")(yas/expand)))

;; *.java ファイル
(define-auto-insert "\\.java$"
  '(lambda () (insert "java-file-template")(yas/expand)))

;; *Test.java ファイル
(define-auto-insert "\\Test.java$"
  '(lambda () (insert "java-test-file-template")(yas/expand)))

;; *.sh ファイル
(defun insert-sh-template ()
  (interactive)
  (yas/expand-snippet
   "#!/bin/sh

$0

# end of file"
   (point) (point)))
(define-auto-insert "\\.sh$" 'insert-sh-template)

;;
;; org
;;______________________________________________________________________________
(require 'org)

;; org-modeの初期化
(require 'org-install)

;; キーバインドの設定
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cr" 'org-remember)

;; 拡張子がorgのファイルを開いた時，自動的にorg-modeにする
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

;; org-modeでの強調表示を可能にする
(add-hook 'org-mode-hook 'turn-on-font-lock)

;; 見出しの余分な*を消す
(setq org-hide-leading-stars t)

;; org-default-notes-fileのディレクトリ
(setq org-directory "~/Dropbox/org/")

;; org-default-notes-fileのファイル名
(setq org-default-notes-file "tac.org")

;; すぐ開けるように
(key-chord-define-global "fj" (lambda ()
                                (interactive)
                                (find-file "~/Dropbox/org/tac.org")))
;;
;; http://d.hatena.ne.jp/tamura70/20100207/org
;;______________________________________________________________________________
;; TODO状態
(setq org-todo-keywords
      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))
;; DONEの時刻を記録
(setq org-log-done 'time)

;; ===== org-agenda 関連 ====================
;; アジェンダ表示の対象ファイル
(setq org-agenda-files (list org-directory))
;; アジェンダ表示で下線を用いる
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
(setq hl-line-face 'underline)
;; 標準の祝日を利用しない
(setq calendar-holidays nil)

(defun org-mode-insert-upheading (arg)
  "1レベル上の見出しを入力する"
  (interactive "p")
  (org-insert-heading arg)
  (cond ((org-on-heading-p) (org-do-promote))
	((org-at-item-p) (org-indent-item -1))))

(defun org-insert-heading-dwim (arg)
  "現在と同じレベルの見出しを入力する。
C-u をつけると1レベル上、C-u C-u をつけると1レベル下の見出しを入力する。"
  (interactive "p")
  (case arg
    (4 (org-insert-subheading nil))   ; C-u
    (16 (org-insert-upheading nil))   ; C-u C-u
    (t (org-insert-heading nil))))
(define-key org-mode-map (kbd "<C-return>") 'org-insert-heading-dwim)

;;
;; メモを取りやすくする
;;______________________________________________________________________________
(require 'org-remember)
(org-remember-insinuate)

;; メモを保存するorgファイルのパス
(setq org-directory "~/Dropbox/org")
(setq org-default-notes-file (expand-file-name "tac.org" org-directory))

;; 押しやすく
(key-chord-define-global "jk" 'org-remember)

;; テンプレートの設定
(setq org-remember-templates
      '(
        ("Todo"  ?t "** TODO %? %t" nil "Tasks")
        ("Note"  ?n "** %? %t"      nil "Inbox")
        ("Idea"  ?i "** %? %t"      nil "Idea")
        ("Log"   ?l "** %? %t"      nil "Log")
        ("Words" ?w "** %? %t"      nil "Words")
        ))

;;
;; agenda
;;
;; ref: http://d.hatena.ne.jp/tamura70/20100208/org
;;______________________________________________________________________________
;; アジェンダ表示の対象ファイル
(setq org-agenda-files (list org-directory))
;; アジェンダ表示で下線を用いる
(add-hook 'org-agenda-mode-hook '(lambda () (hl-line-mode 1)))
(setq hl-line-face 'underline)
;; 標準の祝日を利用しない
(setq calendar-holidays nil)

;;
;; latex-export に関する設定
;;______________________________________________________________________________
(require 'org-latex)
(setq org-export-latex-coding-system 'utf-8-unix)
(setq org-export-latex-date-format "%Y-%m-%d")
;;(setq org-export-latex-classes nil)
(add-to-list 'org-export-latex-classes
  '("jarticle"
    "
\\documentclass[a4j]{jarticle}
\\AtBeginDvi{\\special{pdf:tounicode EUC-UCS2}}
\\usepackage[dvipdfm,bookmarks=true,bookmarksnumbered=true,bookmarkstype=toc,colorlinks,linkcolor=blue,urlcolor=blue]{hyperref}
\\setlength{\\topmargin}{-3.0\\baselineskip}
\\addtolength{\\textheight}{3.2\\baselineskip}
\\usepackage{amssymb}
\\usepackage[dvipdfmx]{graphicx}
\\usepackage{url}
\\西暦
"
    ("\\section{%s}" . "\\section*{%s}")
    ("\\subsection{%s}" . "\\subsection*{%s}")
    ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
    ("\\paragraph{%s}" . "\\paragraph*{%s}")
    ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(add-to-list 'org-export-latex-classes
             '("publish"
               "\\documentclass{article}"
               ("\\section{%s}" . "\\section*{%s}")
               ("\\subsection{%s}" . "\\subsection*{%s}")
               ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
               ("\\paragraph{%s}" . "\\paragraph*{%s}")
               ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

(setq org-export-latex-inline-image-extensions nil)
(add-to-list 'org-export-latex-inline-image-extensions "eps")

;;
;; yatex
;;______________________________________________________________________________
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(setq auto-mode-alist
      (append '(("\\.tex$" . yatex-mode)
                ("\\.ltx$" . yatex-mode)
                ("\\.cls$" . yatex-mode)
                ("\\.sty$" . yatex-mode)
                ("\\.clo$" . yatex-mode)
                ("\\.bbl$" . yatex-mode)) auto-mode-alist))

(setq YaTeX-inhibit-prefix-letter t
      YaTeX-kanji-code nil
      YaTeX-latex-message-code 'utf-8
      tex-command "latexmk -pdfdvi"
      dvi2-command "evince")

(add-hook 'yatex-mode-hook
	  '(lambda ()
	     (setq auto-fill-function nil)
;	     (setq tex-command "latexmk -pdfdvi -ps")
;	     (setq tex-command "latexmk -pdfdvi")
;	     (setq tex-command "latexmk -pvc")
;	     (setq tex-command "latexmk")
	     ;; デフォルトプレビューアの設定
;	     (setq dvi2-command "xdvi -watchfile 1 -geo +0+0 -s 6")
;             (setq dvi2-command "evince")
;	     (setq YaTeX-use-AMS-LaTeX t)
;	     (setq dviprint-command-format "dvips -f %s | psset -d | lpr")
	     (setq dviprint-command-format
                   (format "texps %s; pslpr %s.ps"
                           (buffer-name)
                           (car (split-string (buffer-name) "\\.tex"))))))

;;
;; binding
;;
(defun next-setion ()
  "Move to next section."
  (interactive)
  (end-of-line)
  (re-search-forward "^[ \t]*\\\\\\(sub\\)?\\(sub\\)?section\\*?{.*}"))

(defun previous-section ()
  "Move to previous section."
  (interactive)
  (beginning-of-line)
  (re-search-backward "^[ \t]*\\\\\\(sub\\)?\\(sub\\)?section\\*?{.*}"))

(defun grep-section ()
  "Search all line with section command."
  (interactive)
  (grep (format "%s %s"
                "grep -nH -E '\\\\(sub|subsub)?section\\*?{.*}|\\\\chapter{.*}'"
                (file-name-nondirectory (buffer-file-name))))
  (pop-to-buffer "*grep*"))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c s") 'grep-section)
             (local-set-key (kbd "M-N") 'next-setion)
             (local-set-key (kbd "M-P") 'previous-section)))

(defvar YaTeX-dvi2-command-ext-alist
  '(("dvips\\|xdvi\\|dvipdfmx" . ".dvi")
    ("ghostview\\|gv" . ".ps")
    ("evince\\|acroread\\|pdf\\|Preview\\|TeXShop" . ".pdf")))

(defun evince-forward-search ()
  (interactive)
  (let* ((ctf (buffer-name))
         (mtf)
         (pf)
         (ln (format "%d" (line-number-at-pos)))
         (cmd "fwdevince")
         (args))
    (if (YaTeX-main-file-p)
        (setq mtf (buffer-name))
      (progn
        (if (equal YaTeX-parent-file nil)
            (save-excursion
              (YaTeX-visit-main t)))
        (setq mtf YaTeX-parent-file)))
    (setq pf (concat (car (split-string mtf "\\.")) ".pdf"))
    (setq args (concat "\"" pf "\" " ln " \"" ctf "\""))
    (message (concat cmd " " args))
    (process-kill-without-query
     (start-process-shell-command "fwdevince" nil cmd args))))

(add-hook 'yatex-mode-hook
          '(lambda ()
             (define-key YaTeX-mode-map (kbd "C-c e") 'evince-forward-search)))

(require 'dbus)

(defun un-urlify (fname-or-url)
  "A trivial function that replaces a prefix of file:/// with just /."
  (if (string= (substring fname-or-url 0 8) "file:///")
      (substring fname-or-url 7)
    fname-or-url))

(defun th-evince-sync (file linecol &rest ignored)
  (let* ((fname (un-urlify file))
 ;        (buf (find-buffer-visiting fname))
         (buf (find-file fname))
         (line (car linecol))
         (col (cadr linecol)))
    (if (null buf)
        (message "[Synctex]: %s is not opened..." fname)
      (switch-to-buffer buf)
      (goto-line (car linecol))
      (unless (= col -1)
        (move-to-column col)))))

(defvar *dbus-evince-signal* nil)

(defun enable-evince-sync ()
  (require 'dbus)
  (when (and
         (eq window-system 'x)
         (fboundp 'dbus-register-signal))
    (unless *dbus-evince-signal*
      (setf *dbus-evince-signal*
            (dbus-register-signal
             :session nil "/org/gnome/evince/Window/0"
             "org.gnome.evince.Window" "SyncSource"
             'th-evince-sync)))))

(add-hook 'yatex-mode-hook 'enable-evince-sync)

;;
;; helm
;;______________________________________________________________________________
(require 'helm-config)
(helm-mode 1)

(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "C-x C-r") 'helm-recentf)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
(define-key global-map (kbd "C-c j")   'helm-mini)

(define-key helm-map (kbd "C-h") 'delete-backward-char)
(define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

;;
;; git-gitter
;;
(global-git-gutter-mode t)

;;
;; sass
;;
(require 'scss-mode)
(add-to-list 'auto-mode-alist '("\\.scss$" . scss-mode))
(defun scss-custom ()
  (and
   (set (make-local-variable 'css-indent-offset) 2)
   (set (make-local-variable 'scss-compile-at-save) nil)))
(add-hook 'scss-mode-hook '(lambda () (scss-custom)))

;;
;; golang
;;
(add-to-list 'exec-path (expand-file-name "~/go/third-party/bin"))
(eval-after-load "go-mode"
  '(progn
     (require 'go-autocomplete)
     (require 'auto-complete-config)
     (setq ac-auto-start 2)
     (setq ac-delay 0.05)
     (setq gofmt-command "goimports")

     (add-hook 'go-mode-hook 'go-eldoc-setup)
     (define-key go-mode-map (kbd "M-.") 'godef-jump)
     (define-key go-mode-map (kbd "M-*") 'pop-tag-mark)
     (define-key go-mode-map (kbd "C-c f") 'gofmt)))

;;
;; for reveal.js with org-mode
;;
(require 'ox-reveal)

;;
;; anzu
;;
(global-anzu-mode +1)
(global-set-key (kbd "M-%") 'anzu-query-replace)
(global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)

;;
;; 開いてるキーバインド
;;
;; C-M-{
;; C-M-}
;;

(provide 'init)

;;; init.el ends here
