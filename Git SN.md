# Git 學習筆記
>[name= Donseking]
>[time= 2025.10.22 三 19:45]

#### 1. 基本設定 & 初始化
---

    > git --version
        : 查看當前 git 版本編號

    > git config --global user.name
        : 設定使用者姓名

    > git config --global user.email
        : 設定使用者電子郵件

    > git init
        : 初始化 git 專案資料夾

#### 2. git 檔案狀態
---

    > git status
        : 檢查當前目錄每個檔案的狀態
            Untracked 未追蹤
            Tracked   已追蹤
            Staged    已暫存
            committed 已提交

    > git add < filername > / < . >
        filename
        : 將指定的未追蹤檔案加入追蹤清單
        .
        : 將當前目錄所有檔案加入追蹤清單
    
    > git commit -m " ... "
        : 提交檔案
            -m " 這裡撰寫要提交的訊息 "
    > git log ( --oneline )
        : 列出提交的歷史紀錄
        : 在按下 q 則退出檢視模式 ( vim 模式下 )
        : --oneline --> 簡易閱讀模式