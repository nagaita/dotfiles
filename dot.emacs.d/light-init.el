;;; light-init.el

;;=================
;; ウィンドウの設定
;;=================
;;メニューバー非表示
(menu-bar-mode nil)
;;ツールバー非表示
(tool-bar-mode nil)
;;スクロールバー非表示
(scroll-bar-mode nil)

;;=================
;; そのほかいろいろ
;;=================
;;バックアップファイルを作らない
(setq backup-inhibited t)
;;終了時にオートセーブファイルを消す
(setq delete-auto-save-files t)

;;=============
;; キーバインド
;;=============
(define-key global-map (kbd "C-h") 'delete-backward-char)

;; end of file
