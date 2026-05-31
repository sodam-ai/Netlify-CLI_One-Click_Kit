@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Netlify CLI - Safe Uninstaller

REM ====================================================
REM   This file will REMOVE Netlify CLI from your PC.
REM   It is safe. Your projects will NOT be deleted.
REM ====================================================

REM --- Step 0: Get admin power ---
net session >nul 2>&1
if %errorlevel% neq 0 goto :NEED_ADMIN
goto :HAVE_ADMIN

:NEED_ADMIN
echo.
echo Windows will ask for permission.
echo Please click YES.
echo.
powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b 0

:HAVE_ADMIN
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

REM --- Add npm global folder to PATH for this session ---
set "NPM_PREFIX="
for /f "delims=" %%i in ('call npm config get prefix 2^>nul') do set "NPM_PREFIX=%%i"
if defined NPM_PREFIX set "PATH=!NPM_PREFIX!;!PATH!"


:MAIN_PROMPT
cls
echo.
echo ==================================================
echo    NETLIFY CLI - SAFE UNINSTALLER
echo ==================================================
echo.
echo  Pick what you want to do:
echo.
echo   [1]  Show what would be removed (safe preview)
echo   [2]  Really remove Netlify CLI (needs YES)
echo   [0]  Exit (change nothing)
echo.

set "PICK="
set /p PICK="  Type a number and press Enter: "

if "!PICK!"=="0" goto :CANCELLED
if "!PICK!"=="1" goto :PREVIEW
if "!PICK!"=="2" goto :CONFIRM
goto :MAIN_PROMPT


:PREVIEW
cls
echo.
echo ==================================================
echo    PREVIEW MODE - NOTHING WILL BE REMOVED
echo ==================================================
echo.
echo  These things WILL be removed when you say YES:
echo.

echo  [1] The netlify-cli npm package
where netlify >nul 2>&1
if %errorlevel%==0 goto :PREVIEW_HAS_NL
echo       (not found - already gone)
goto :PREVIEW_DIRS

:PREVIEW_HAS_NL
for /f "delims=" %%i in ('call netlify --version 2^>nul') do echo       Found: %%i

:PREVIEW_DIRS
echo.
echo  [2] These folders (if they exist):
set "DIR_A=%APPDATA%\netlify"
set "DIR_B=%LOCALAPPDATA%\netlify"
set "DIR_C=%USERPROFILE%\.netlify"

if exist "!DIR_A!" echo       FOUND:   !DIR_A!
if not exist "!DIR_A!" echo       (none)   !DIR_A!
if exist "!DIR_B!" echo       FOUND:   !DIR_B!
if not exist "!DIR_B!" echo       (none)   !DIR_B!
if exist "!DIR_C!" echo       FOUND:   !DIR_C!
if not exist "!DIR_C!" echo       (none)   !DIR_C!

echo.
echo  These things will NOT be touched:
echo    - Your website files
echo    - Your Node.js and npm
echo    - Any other programs
echo.
echo  Nothing has been changed yet.
echo.
pause
goto :MAIN_PROMPT


:CONFIRM
cls
echo.
echo ==================================================
echo    REMOVE NETLIFY CLI - CONFIRM
echo ==================================================
echo.
echo  This will remove Netlify CLI from your computer.
echo.
echo  What will be REMOVED:
echo    - The netlify command
echo    - Your saved login key for Netlify
echo    - Netlify cache and settings
echo.
echo  What will NOT be touched:
echo    - Your website files
echo    - Your Node.js and npm
echo    - Any other programs
echo.
echo  To go ahead, type   YES   (in capital letters).
echo  To stop, just close this window.
echo.

set "CONFIRM="
set /p CONFIRM="  Type YES to remove Netlify CLI: "

if not defined CONFIRM goto :CANCELLED
if not "!CONFIRM!"=="YES" goto :CANCELLED

REM Tally what we remove
set "REMOVED_COUNT=0"

echo.
echo --------------------------------------------------
echo.

REM --- Step 1: Log out (if logged in) ---
echo [Step 1 of 5] Logging you out of Netlify...
where netlify >nul 2>&1
if %errorlevel% neq 0 goto :SKIP_LOGOUT
call netlify logout >nul 2>&1
echo               Logged out [OK]
goto :STEP2

:SKIP_LOGOUT
echo               Skipped (netlify command not found)

:STEP2
echo.

REM --- Step 2: Remove the global npm package ---
echo [Step 2 of 5] Removing the netlify-cli package...
where npm >nul 2>&1
if %errorlevel% neq 0 goto :NO_NPM_UNINSTALL
call npm uninstall -g netlify-cli
set /a REMOVED_COUNT=!REMOVED_COUNT! + 1
echo               Package removed [OK]
goto :STEP3

:NO_NPM_UNINSTALL
echo               Could not find npm. Skipping this step.

:STEP3
echo.

REM --- Step 3: Clean config files in AppData ---
echo [Step 3 of 5] Cleaning settings in AppData...
set "DIR_A=%APPDATA%\netlify"
if exist "!DIR_A!" goto :REMOVE_A
echo               Nothing to clean in AppData
goto :STEP4_PRE

:REMOVE_A
rd /s /q "!DIR_A!" >nul 2>&1
if exist "!DIR_A!" goto :REMOVE_A_FAIL
set /a REMOVED_COUNT=!REMOVED_COUNT! + 1
echo               Removed: !DIR_A! [OK]
goto :STEP4_PRE

:REMOVE_A_FAIL
echo               Could not remove: !DIR_A!
echo               (You can delete it by hand later.)

:STEP4_PRE
echo.

REM --- Step 4: Clean cache in LocalAppData and user home ---
echo [Step 4 of 5] Cleaning cache files...
set "DIR_B=%LOCALAPPDATA%\netlify"
if exist "!DIR_B!" goto :REMOVE_B
echo               Nothing to clean in LocalAppData
goto :STEP4B

:REMOVE_B
rd /s /q "!DIR_B!" >nul 2>&1
if exist "!DIR_B!" goto :REMOVE_B_FAIL
set /a REMOVED_COUNT=!REMOVED_COUNT! + 1
echo               Removed: !DIR_B! [OK]
goto :STEP4B

:REMOVE_B_FAIL
echo               Could not remove: !DIR_B!
echo               (You can delete it by hand later.)

:STEP4B
set "DIR_C=%USERPROFILE%\.netlify"
if exist "!DIR_C!" goto :REMOVE_C
echo               Nothing to clean in user home
goto :STEP5

:REMOVE_C
rd /s /q "!DIR_C!" >nul 2>&1
if exist "!DIR_C!" goto :REMOVE_C_FAIL
set /a REMOVED_COUNT=!REMOVED_COUNT! + 1
echo               Removed: !DIR_C! [OK]
goto :STEP5

:REMOVE_C_FAIL
echo               Could not remove: !DIR_C!
echo               (You can delete it by hand later.)

:STEP5
echo.

REM --- Step 5: Check that netlify command is really gone ---
echo [Step 5 of 5] Checking the netlify command is gone...

REM Refresh PATH from current npm prefix
set "NPM_PREFIX="
for /f "delims=" %%i in ('call npm config get prefix 2^>nul') do set "NPM_PREFIX=%%i"
if defined NPM_PREFIX set "PATH=!NPM_PREFIX!;!PATH!"

where netlify >nul 2>&1
if %errorlevel%==0 goto :STILL_THERE
echo               The netlify command is gone [OK]

echo.
echo ==================================================
echo    ALL DONE^!  NETLIFY CLI WAS REMOVED.
echo ==================================================
echo.
echo  Total things removed: !REMOVED_COUNT!
echo.
echo  Your projects and files are safe.
echo  You may close this window now.
echo.
echo  Tip: Restart your computer to be 100%% sure
echo       all leftover bits are gone.
echo.
pause
exit /b 0


:STILL_THERE
echo               [WARNING] The netlify command is still here.
echo.
echo  What to do:
echo    1. Close ALL open Command Prompt windows.
echo    2. Restart your computer (best option).
echo    3. Then run UNINSTALL.bat one more time.
echo.
pause
exit /b 1


:CANCELLED
cls
echo.
echo ==================================================
echo    CANCELLED - NOTHING WAS CHANGED
echo ==================================================
echo.
echo  Netlify CLI is still on your computer.
echo  Your files are safe.
echo.
pause
exit /b 0
