@echo off
chcp 949 >nul
setlocal EnableDelayedExpansion
title Netlify CLI - Easy Menu (쉬운 메뉴)

REM ====================================================
REM   Hi! This menu lets you use Netlify CLI easily.
REM   Just type a number and press Enter.
REM ====================================================

REM --- Set up paths (works on any computer) ---
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM --- Add npm global folder to PATH for this window ---
set "NPM_PREFIX="
for /f "delims=" %%i in ('call npm config get prefix 2^>nul') do set "NPM_PREFIX=%%i"
if defined NPM_PREFIX set "PATH=!NPM_PREFIX!;!PATH!"

REM --- Check Netlify CLI is installed ---
where netlify >nul 2>&1
if %errorlevel% neq 0 goto :NOT_INSTALLED

REM --- Cache version at startup so the menu header can show it ---
set "NF_VER=(unknown)"
for /f "delims=" %%i in ('call netlify --version 2^>nul') do set "NF_VER=%%i"


:MAIN_MENU
cls
echo.
echo ==================================================
echo    NETLIFY CLI - EASY MENU  (쉬운 메뉴)
echo ==================================================
echo  Version: !NF_VER!
echo  Folder:  %SCRIPT_DIR%
echo ==================================================
echo.
echo  Type a number and press Enter.  (번호를 누르고 Enter)
echo.
echo  --- BASIC (기본) ---
echo   [1]  Show my Netlify CLI version            (내 버전 보기)
echo   [2]  Update Netlify CLI to newest version   (최신으로 업데이트)
echo   [3]  Run full diagnostic (find problems)    (문제 진단)
echo.
echo  --- ACCOUNT (계정) ---
echo   [4]  Log in to Netlify                       (로그인)
echo   [5]  Log out from Netlify                    (로그아웃)
echo   [6]  Show login status                       (로그인 상태)
echo   [7]  Switch to another account              (계정 전환)
echo.
echo  --- MY WEBSITES (내 사이트) ---
echo   [8]  Show all my websites                    (사이트 목록)
echo   [9]  Start a new Netlify website here (init) (이 폴더로 새 사이트)
echo   [10] Link this folder to a website          (폴더를 사이트에 연결)
echo   [11] Unlink this folder from a website      (연결 해제)
echo   [12] Create a brand new empty website       (빈 사이트 새로 만들기)
echo.
echo  --- DEVELOP (개발) ---
echo   [13] Start local dev server (netlify dev)   (로컬 미리보기 서버)
echo   [14] Build the project (netlify build)      (빌드)
echo   [15] Show functions list                    (함수 목록)
echo   [16] Run functions locally                  (함수 로컬 실행)
echo.
echo  --- DEPLOY (배포) ---
echo   [17] Deploy PREVIEW (safe draft)            (미리보기 배포 - 안전)
echo   [18] Deploy to PRODUCTION (LIVE^!)           (진짜 공개 - 주의)
echo   [19] Watch recent deploys                   (최근 배포 보기)
echo.
echo  --- ENV VARS (환경변수) ---
echo   [20] List all env vars                       (환경변수 목록)
echo   [21] Set an env var                          (환경변수 설정)
echo   [22] Remove an env var                       (환경변수 삭제)
echo.
echo  --- OPEN IN BROWSER (브라우저로 열기) ---
echo   [23] Open my live website                    (내 사이트 열기)
echo   [24] Open Netlify dashboard (admin)         (대시보드 열기)
echo.
echo  --- ADVANCED (고급) ---
echo   [25] Show all netlify commands (help)       (전체 명령 도움말)
echo   [26] Type my own netlify command            (직접 명령 입력)
echo.
echo   [0]  Exit                                    (끝내기)
echo.
echo ==================================================

set "CHOICE="
set /p CHOICE="  Type a number / 번호 입력: "

if not defined CHOICE goto :MAIN_MENU
if "!CHOICE!"=="0" goto :END
if "!CHOICE!"=="1" goto :VERSION
if "!CHOICE!"=="2" goto :UPDATE
if "!CHOICE!"=="3" goto :DIAGNOSTIC
if "!CHOICE!"=="4" goto :LOGIN
if "!CHOICE!"=="5" goto :LOGOUT
if "!CHOICE!"=="6" goto :STATUS
if "!CHOICE!"=="7" goto :SWITCH
if "!CHOICE!"=="8" goto :SITES_LIST
if "!CHOICE!"=="9" goto :INIT
if "!CHOICE!"=="10" goto :LINK
if "!CHOICE!"=="11" goto :UNLINK
if "!CHOICE!"=="12" goto :SITES_CREATE
if "!CHOICE!"=="13" goto :DEV
if "!CHOICE!"=="14" goto :BUILD
if "!CHOICE!"=="15" goto :FUNC_LIST
if "!CHOICE!"=="16" goto :FUNC_SERVE
if "!CHOICE!"=="17" goto :DEPLOY_PREVIEW
if "!CHOICE!"=="18" goto :DEPLOY_PROD
if "!CHOICE!"=="19" goto :WATCH
if "!CHOICE!"=="20" goto :ENV_LIST
if "!CHOICE!"=="21" goto :ENV_SET
if "!CHOICE!"=="22" goto :ENV_UNSET
if "!CHOICE!"=="23" goto :OPEN_SITE
if "!CHOICE!"=="24" goto :OPEN_ADMIN
if "!CHOICE!"=="25" goto :HELP
if "!CHOICE!"=="26" goto :CUSTOM

echo.
echo   That number is not on the menu. Try again.  (메뉴에 없는 번호예요.)
timeout /t 2 >nul
goto :MAIN_MENU


:VERSION
cls
echo.
echo ==== Show my Netlify CLI version ====
echo.
echo Netlify CLI:
call netlify --version
echo.
echo Node.js:
call node -v
echo.
echo npm:
call npm -v
echo.
pause
goto :MAIN_MENU


:UPDATE
cls
echo.
echo ==== Update Netlify CLI to newest version ====
echo.
echo Current version:
call netlify --version
echo.
echo This will install the newest version.
echo It may take a few minutes. Please wait.
echo.
call npm install -g netlify-cli@latest
echo.
echo Done. New version:
call netlify --version
echo.
REM Refresh the cached version
set "NF_VER=(unknown)"
for /f "delims=" %%i in ('call netlify --version 2^>nul') do set "NF_VER=%%i"
pause
goto :MAIN_MENU


:DIAGNOSTIC
cls
echo.
echo ==== Full diagnostic ====
echo.
echo --- Computer ---
echo  User folder: %USERPROFILE%
echo  App data:    %APPDATA%
echo.
echo --- Node.js ---
call node -v
where node
echo.
echo --- npm ---
call npm -v
echo  npm prefix: !NPM_PREFIX!
echo.
echo --- Netlify CLI ---
call netlify --version
where netlify
echo.
echo --- Login status ---
call netlify status
echo.
echo --- Done ---
echo If everything above shows numbers and your name,
echo your setup is healthy.
echo.
pause
goto :MAIN_MENU


:LOGIN
cls
echo.
echo ==== Log in to Netlify ====
echo.
echo Your web browser will open in a moment.
echo Please log in there, then come back here.
echo.
call netlify login
echo.
pause
goto :MAIN_MENU


:LOGOUT
cls
echo.
echo ==== Log out from Netlify ====
echo.
call netlify logout
echo.
pause
goto :MAIN_MENU


:STATUS
cls
echo.
echo ==== Show login status ====
echo.
call netlify status
echo.
pause
goto :MAIN_MENU


:SWITCH
cls
echo.
echo ==== Switch to another account ====
echo.
call netlify switch
echo.
pause
goto :MAIN_MENU


:SITES_LIST
cls
echo.
echo ==== Show all my websites ====
echo.
call netlify sites:list
echo.
pause
goto :MAIN_MENU


:INIT
cls
echo.
echo ==== Start a new Netlify website here ====
echo.
echo Folder: %SCRIPT_DIR%
echo.
call netlify init
echo.
pause
goto :MAIN_MENU


:LINK
cls
echo.
echo ==== Link this folder to a website ====
echo.
call netlify link
echo.
pause
goto :MAIN_MENU


:UNLINK
cls
echo.
echo ==== Unlink this folder from a website ====
echo.
call netlify unlink
echo.
pause
goto :MAIN_MENU


:SITES_CREATE
cls
echo.
echo ==== Create a brand new empty website ====
echo.
echo This will make a new empty Netlify site
echo on your account. You can deploy to it later.
echo.
call netlify sites:create
echo.
pause
goto :MAIN_MENU


:DEV
cls
echo.
echo ==== Start local dev server ====
echo.
echo The server will run on your computer.
echo To STOP the server, press Ctrl+C.
echo.
call netlify dev
echo.
pause
goto :MAIN_MENU


:BUILD
cls
echo.
echo ==== Build the project ====
echo.
call netlify build
echo.
pause
goto :MAIN_MENU


:FUNC_LIST
cls
echo.
echo ==== Show functions ====
echo.
call netlify functions:list
echo.
pause
goto :MAIN_MENU


:FUNC_SERVE
cls
echo.
echo ==== Run functions locally ====
echo.
echo To STOP the function server, press Ctrl+C.
echo.
call netlify functions:serve
echo.
pause
goto :MAIN_MENU


:DEPLOY_PREVIEW
cls
echo.
echo ==== Deploy a PREVIEW ====
echo.
echo This is SAFE. It is just a draft.
echo Nothing on your live website will change.
echo.
call netlify deploy
echo.
pause
goto :MAIN_MENU


:DEPLOY_PROD
cls
echo.
echo ==== Deploy to PRODUCTION (진짜 공개 배포) ====
echo.
echo  *** WARNING (주의) ***
echo  This will put your code on the LIVE website.
echo  (지금 폴더의 내용을 인터넷에 진짜로 공개합니다.)
echo  Real visitors will see it right away.
echo  (방문자가 곧바로 보게 됩니다.)
echo.
set "CONFIRM_PROD="
set /p CONFIRM_PROD="  Type YES to deploy / 공개하려면 YES 입력: "
if /i not "!CONFIRM_PROD!"=="YES" goto :CANCEL_PROD
echo.
call netlify deploy --prod
echo.
pause
goto :MAIN_MENU

:CANCEL_PROD
echo.
echo Production deploy cancelled.
echo.
pause
goto :MAIN_MENU


:WATCH
cls
echo.
echo ==== Watch recent deploys ====
echo.
echo This will show new deploys as they happen.
echo Press Ctrl+C to stop watching.
echo.
call netlify watch
echo.
pause
goto :MAIN_MENU


:ENV_LIST
cls
echo.
echo ==== List all env vars ====
echo.
call netlify env:list
echo.
pause
goto :MAIN_MENU


:ENV_SET
cls
echo.
echo ==== Set an env var ====
echo.
echo Step 1 of 2: Type the env var NAME (example: API_KEY)
set "ENV_NAME="
set /p ENV_NAME="  Name: "
if not defined ENV_NAME goto :ENV_SET_CANCEL
echo.
echo Step 2 of 2: Type the VALUE
set "ENV_VALUE="
set /p ENV_VALUE="  Value: "
if not defined ENV_VALUE goto :ENV_SET_CANCEL
echo.
call netlify env:set "!ENV_NAME!" "!ENV_VALUE!"
echo.
pause
goto :MAIN_MENU

:ENV_SET_CANCEL
echo.
echo Cancelled. No env var was set.
echo.
pause
goto :MAIN_MENU


:ENV_UNSET
cls
echo.
echo ==== Remove an env var ====
echo.
echo Type the env var name to remove (example: API_KEY)
set "ENV_NAME2="
set /p ENV_NAME2="  Name: "
if not defined ENV_NAME2 goto :ENV_UNSET_CANCEL
echo.
call netlify env:unset "!ENV_NAME2!"
echo.
pause
goto :MAIN_MENU

:ENV_UNSET_CANCEL
echo.
echo Cancelled. No env var was removed.
echo.
pause
goto :MAIN_MENU


:OPEN_SITE
cls
echo.
echo ==== Open my live website ====
echo.
call netlify open:site
echo.
pause
goto :MAIN_MENU


:OPEN_ADMIN
cls
echo.
echo ==== Open Netlify dashboard ====
echo.
call netlify open:admin
echo.
pause
goto :MAIN_MENU


:HELP
cls
echo.
echo ==== Show all netlify commands ====
echo.
call netlify help
echo.
pause
goto :MAIN_MENU


:CUSTOM
cls
echo.
echo ==== Type your own netlify command ====
echo.
echo Just type the part AFTER the word "netlify".
echo Example: type   deploy --prod
echo Example: type   env:list
echo To go back to the menu, type:  back
echo.
set "CUSTOM_CMD="
set /p CUSTOM_CMD="  netlify "
if not defined CUSTOM_CMD goto :MAIN_MENU
if /i "!CUSTOM_CMD!"=="back" goto :MAIN_MENU
echo.
call netlify !CUSTOM_CMD!
echo.
pause
goto :MAIN_MENU


:NOT_INSTALLED
cls
echo.
echo ==================================================
echo    OH NO - NETLIFY CLI IS NOT INSTALLED
echo    (앗 - Netlify CLI가 아직 설치 안 됨)
echo ==================================================
echo.
echo  Netlify CLI is not on this computer yet.
echo  (이 컴퓨터에 아직 설치되지 않았어요.)
echo.
echo  How to fix (해결 방법):
echo    1. Close this window.             (이 창을 닫기)
echo    2. Double-click INSTALL.bat       (INSTALL.bat 더블클릭)
echo    3. Wait until you see "ALL DONE". (ALL DONE 나올 때까지 대기)
echo    4. Then run RUN.bat again.        (다시 RUN.bat 실행)
echo.
pause
exit /b 2


:END
cls
echo.
echo ==================================================
echo    GOODBYE^!
echo ==================================================
echo.
echo  Thanks for using Netlify CLI.
echo  Have a great day^!
echo.
timeout /t 2 >nul
exit /b 0
