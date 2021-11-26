# Amazon AppStream2.0

# Elastic Fleets の Windows 用スクリプト  
## プロジェクトの配置例
```
C:\AppStream\AppBlocks\
 + [F] setup.ps1
 + [F] work_start.ps1
 + [F] work_complete.ps1
 + [F] app.sample1.vhdx
 + [F] app.sample2.vhdx
 + [F] app.sample3.vhdx
```
↓ マウント
```
C:\AppStream\AppBlocks\app.sample1\*.exe
C:\AppStream\AppBlocks\app.sample2\*.exe
C:\AppStream\AppBlocks\app.sample3\*.exe
```
AppStream2.0 で展開されるフォルダ名と同じになる  
ローカル環境と AppStream2.0 のパス環境をあわせることで動作を確認しやすくする  

## スクリプト  
- setup.ps1  
    仮想ハードディスク(VHD) のマウント用スクリプト  
    フォルダ内にある [app.*.vhdx] を [app.*] フォルダーとしてマウントする  
      
    AppStreams 2.0 の設定：
    - [マネージメントコンソール] - [AppStream 2.0] - [Applications]
        - [App blocks]  
            - [Create app block]  
                - [App block details]  
                    - [Name]  
                        [app.*.vhdx] ファイル名 `app.*` を設定  
                - [Script settings]  
                    - [Setup script object in S3]  
                        `setup.ps1` を S3 バケットにアップロードして URI を設定  
                    - [Setup script executable]  
    `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe` を設定  
                    - [Setup script executable arguments]  
                        `C:\AppStream\AppBlocks\{[App block details]-[Name]}\setup.ps1` を設定  
  
    - [マネージメントコンソール] - [AppStream 2.0] - [Applications]
        - [Applications]  
            - [Create application]  
                - [Application settings]  
                    - [Application executable launch path]  
                        `C:\AppStream\AppBlocks\{[App block details]-[Name]}\{vhdxのファイル名}\{実行ファイル}.exe` を設定  
  
- work_start.ps1  
    仮想ハードディスク(VHD)の作業用スクリプト  
    このスクリプトのあるフォルダー内にある仮想ハードディスク(VHD)をファイル名でマウントする  
    `app.*.vhdx` を `app.*` としてマウントする  
      
    配置例：  
    ```
    C:\AppStream\AppBlocks\
    + [F] work_start.ps1
    + [F] work_complete.ps1
    + [F] app.sample.vhdx
    ```
    　↓  
    ```
    C:\AppStream\AppBlocks\
    + [F] work_start.ps1
    + [F]work_complete.ps1
    + [F] app.sample.vhdx
    + [D] app.sample\
    ```
    [app.sample] フォルダーに [app.sample.vhdx] の中身がマウントされる  
    このフォルダ内にアプリケーションを設置して動作テストを行う  

- work_complete.ps1  
    仮想ハードディスク(VHD)の作業用スクリプト  
    このスクリプトのあるフォルダー内にある仮想ハードディスク(VHD)のマウントを解除して圧縮する  
    `app.*.vhdx` がマウントされている `app.*` のマウントを解除してマウントポイントを削除  
      
    配置例：  
    ※ vhdx 内にゴミ箱フォルダー `$Recycle. Bin` がある場合、中身を空にする  
    ```
    C:\AppStream\AppBlocks\
    + [F] work_start.ps1
    + [F] work_complete.ps1
    + [F] app.sample.vhdx
    + [D] app.sample\
    ```
    ↓  
    ```
    C:\AppStream\AppBlocks\
    + [F] work_start.ps1
    + [F] work_complete.ps1
    + [F] app.sample.vhdx
    ```
    [app.sample] フォルダーのマウントポイントが削除され [app.sample.vhdx] が圧縮される  