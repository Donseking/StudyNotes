# Git 學習筆記

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

#### 3. 檢視提交紀錄與檔案還原
---

    > git log ( --oneline )
        : 列出提交的歷史紀錄
        : 在按下 q 則退出檢視模式 ( vim 模式下 )
        : --oneline --> 簡易閱讀模式

    > git diff < 舊版本 ID > < -- filename >
        : 比較新舊版本差異
    
    > git checkout < 舊版本 ID > < -- filename >
        : 將指定檔案還原至指定版本 ( 更動後須重新提交 )
        
    > git reset --hard < 目標版本ID >
        : 將所有檔案還原至指定版本，並刪除存檔紀錄

#### 4. 忽略檔案清單
---
    可將不需上傳的檔案或副檔名存在 .gitnore 檔案中

#### 5. 協作
---
    
    > git clone < url >
        : 將雲端倉庫複製到本地
    
    > git pull
        : 使雲端與本地倉庫同步
    
    > git checkout -b < 分支名稱 >
        : 建立新分支
    
    > git branch
        : 查詢當前分支