# Dos 指令學習筆記

#### 1. 常用指令
---

    > cls
        : 更新屏幕
    
    > dir < 子資料夾 >
        : 列出當前目錄的子目錄
    
    > ren oldname newname
        : 將檔案重新命名
    
    > cd < .. > < folder >
        : 移動到指定目錄
    
    > md foldername
        : 建立新資料夾
    
    > del < file > < folder >
        : 刪除資料夾或檔案
        
    > tree < path > /f
        : 顯示指定資料夾的樹狀結構


#### 2. Powershell 指令
---

    > Test-Path -Path C:\XXX\XXX.txt
        : 檢查檔案是否存在
        
    > New-Item < folder > < file > -ItemType < "directory" > < "file" >
        : 建立新資料夾或檔案
        : <> --> 可選選項
    
    > Move-Item < folder > < file > -Destination < folder > < file >
        : 搬移檔案或目錄
        : <> --> 可選