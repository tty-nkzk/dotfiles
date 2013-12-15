
;; ~/.emas.d/elisp ディレクトリをロードパスに追加
;; add-to-load-path関数を作成なのでいらない
;; (add-to-list 'load-path "~/.emacs.d/elisp")

;; Emacs 23 より前のヴァーションなら,
;; user-emacs-directory変数が未定義のため次の設定を追加
(when (> emacs-major-version 23)
  (defvar user-emacs-directory "~/.emacs.d"))

;; load-path を追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory
	      (expand-file-name (concat user-emacs-directory path))))
	(add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
	    (normal-top-level-add-subdirs-to-load-path))))))

;; 引数のディレクトリとそのサブディレクトリをload-pathに追加
(add-to-load-path "elisp" "conf" "public_repos")

;; 行番号を常に表示
(global-linum-mode t)

;;ricty
(set-frame-font "ricty-12")
