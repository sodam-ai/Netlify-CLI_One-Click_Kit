@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Netlify CLI - Easy Menu

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
echo    NETLIFY CLI - EASY MENU
echo ==================================================
echo  Version: !NF_VER!
echo  Folder:  %SCRIPT_DIR%
echo ==================================================
echo.
echo  Type a number and press Enter.
echo.
echo  --- BASIC ---
echo   [1]  Show my Netlify CLI version
echo   [2]  Update Netlify CLI to newest version
echo   [3]  Run full diagnostic (find problems)
echo.
echo  --- ACCOUNT ---
echo   [4]  Log in to Netlify
echo   [5]  Log out from Netlify
echo   [6]  Show login status
echo   [7]  Switch to another account
echo.
echo  --- MY WEBSITES ---
echo   [8]  Show all my websites
echo   [9]  Start a new Netlify website here (init)
echo   [10] Link this folder to a website
echo   [11] Unlink this folder from a website
echo   [12] Create a brand new empty website
echo.
echo  --- DEVELOP ---
echo   [13] Start local dev server (netlify dev)
echo   [14] Build the project (netlify build)
echo   [15] Show functions list
echo   [16] Run functions locally
echo.
echo  --- DEPLOY ---
echo   [17] Deploy PREVIEW (safe draft)
echo   [18] Deploy to PRODUCTION (LIVE^!)
echo   [19] Watch recent deploys
echo.
echo  --- ENV VARS ---
echo   [20] List all env vars
echo   [21] Set an env var
echo   [22] Remove an env var
echo.
echo  --- OPEN IN BROWSER ---
echo   [23] Open my live website
echo   [24] Open Netlify dashboard (admin)
echo.
echo  --- ADVANCED ---
echo   [25] Show all netlify commands (help)
echo   [26] Type my own netlify command
echo.
echo   [0]  Exit
echo.
echo ==================================================

set "CHOICE="
set /p CHOICE="  Type a number and press Enter: "

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
echo   That number is not on the menu. Try again.
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
echo ==== Deploy to PRODUCTION ====
echo.
echo  *** WARNING ***
echo  This will put your code on the LIVE website.
echo  Real visitors will see it right away.
echo.
set "CONFIRM_PROD="
set /p CONFIRM_PROD="  Type YES to deploy to production: "
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
echo ==================================================
echo.
echo  Netlify CLI is not on this computer yet.
echo.
echo  How to fix:
echo    1. Close this window.
echo    2. Double-click INSTALL.bat
echo    3. Wait until you see "ALL DONE".
echo    4. Then run RUN.bat again.
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
