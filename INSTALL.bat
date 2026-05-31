@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion
title Netlify CLI - One-Click Installer

REM ====================================================
REM   Hi! This file will install Netlify CLI for you.
REM   Just wait a few minutes. Don't close this window.
REM ====================================================

REM --- Step 0: Get admin power (Windows will ask, click YES) ---
net session >nul 2>&1
if %errorlevel% neq 0 goto :NEED_ADMIN
goto :HAVE_ADMIN

:NEED_ADMIN
echo.
echo Windows will now ask for permission.
echo Please click YES so the installer can work.
echo.
powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b 0

:HAVE_ADMIN
REM --- Set up paths (works on any computer, any folder) ---
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
cd /d "%SCRIPT_DIR%"

cls
echo.
echo ==================================================
echo    NETLIFY CLI - ONE-CLICK INSTALLER
echo ==================================================
echo.
echo  Folder: %SCRIPT_DIR%
echo  User:   %USERNAME%
echo.
echo  Hi^! This will install Netlify CLI on your PC.
echo  It is safe. Please wait until you see "ALL DONE".
echo.
echo --------------------------------------------------
echo.

REM --- Step 1: Check Windows version (info only) ---
echo [Step 1 of 6] Checking Windows version...
ver | findstr /i "10\." >nul && set "WIN_OK=1"
ver | findstr /i "11\." >nul && set "WIN_OK=1"
if defined WIN_OK goto :WIN_OK_OUT
echo               (Info) Could not detect Windows 10 or 11.
echo               Install will still try to continue.
goto :STEP2

:WIN_OK_OUT
echo               Windows looks OK [OK]

:STEP2
echo.

REM --- Step 2: Check Node.js (major AND minor AND patch) ---
echo [Step 2 of 6] Looking for Node.js...
where node >nul 2>&1
if %errorlevel% neq 0 goto :NO_NODE

set "NODE_PATH="
for /f "delims=" %%i in ('where node 2^>nul') do (
    if not defined NODE_PATH set "NODE_PATH=%%i"
)
set "NODE_VER="
for /f "delims=" %%i in ('node -v') do set "NODE_VER=%%i"
echo               Found Node.js !NODE_VER!
echo               Location: !NODE_PATH!

set "NODE_NUM=!NODE_VER:v=!"
for /f "tokens=1,2,3 delims=." %%a in ("!NODE_NUM!") do (
    set "NODE_MAJOR=%%a"
    set "NODE_MINOR=%%b"
    set "NODE_PATCH=%%c"
)

REM Required: 20.12.2 or higher
if !NODE_MAJOR! GTR 20 goto :NODE_VER_OK
if !NODE_MAJOR! LSS 20 goto :OLD_NODE
REM Major is exactly 20
if !NODE_MINOR! GTR 12 goto :NODE_VER_OK
if !NODE_MINOR! LSS 12 goto :OLD_NODE
REM Minor is exactly 12
if !NODE_PATCH! GEQ 2 goto :NODE_VER_OK
goto :OLD_NODE

:NODE_VER_OK
echo               Node.js version is OK [OK]
echo.

REM --- Step 3: Check npm ---
echo [Step 3 of 6] Looking for npm...
where npm >nul 2>&1
if %errorlevel% neq 0 goto :NO_NPM

set "NPM_PATH="
for /f "delims=" %%i in ('where npm 2^>nul') do (
    if not defined NPM_PATH set "NPM_PATH=%%i"
)
set "NPM_VER="
for /f "delims=" %%i in ('call npm -v 2^>nul') do set "NPM_VER=%%i"
echo               Found npm v!NPM_VER!
echo               Location: !NPM_PATH! [OK]
echo.

REM --- Step 4: Find the npm global folder and add it to PATH ---
echo [Step 4 of 6] Setting up PATH...
set "NPM_PREFIX="
for /f "delims=" %%i in ('call npm config get prefix 2^>nul') do set "NPM_PREFIX=%%i"
if not defined NPM_PREFIX goto :NO_PREFIX
echo               npm global folder: !NPM_PREFIX!
set "PATH=!NPM_PREFIX!;!PATH!"
echo               PATH ready [OK]
echo.

REM --- Step 5: Quick internet test using Windows ping (3s timeout) ---
REM    NOTE: We do NOT use `npm ping` here because it can hang
REM    for many seconds behind firewalls or proxies, with no
REM    client-side timeout. Windows `ping` is fast and safe.
echo [Step 5 of 6] Testing internet connection (3 seconds)...
ping -n 1 -w 3000 registry.npmjs.org >nul 2>&1
if %errorlevel% equ 0 goto :NET_OK
echo               (Internet check could not confirm - that is OK)
echo               (We will still try to install. If it fails,
echo                check your firewall, proxy, or Wi-Fi.)
goto :STEP6

:NET_OK
echo               Internet looks good [OK]

:STEP6
echo.

REM --- Step 6: Install Netlify CLI (with auto-retry on failure) ---
echo [Step 6 of 6] Installing Netlify CLI...
echo               This part can take 3 to 10 minutes.
echo               Please be patient. Do not close this window.
echo.
call npm install -g netlify-cli
if %errorlevel% equ 0 goto :INSTALL_OK

echo.
echo               First try did not finish. Will try once more.
echo               Cleaning npm cache first...
call npm cache clean --force >nul 2>&1
echo               Cache cleaned. Trying install again...
echo.
call npm install -g netlify-cli
if %errorlevel% equ 0 goto :INSTALL_OK
goto :INSTALL_FAILED

:INSTALL_OK
echo.
echo               Install command finished [OK]
echo.

REM --- Final: Verify ---
echo [Verify] Checking that Netlify CLI works...

set "NPM_PREFIX="
for /f "delims=" %%i in ('call npm config get prefix 2^>nul') do set "NPM_PREFIX=%%i"
if defined NPM_PREFIX set "PATH=!NPM_PREFIX!;!PATH!"

where netlify >nul 2>&1
if %errorlevel% neq 0 goto :NOT_FOUND_AFTER

set "NF_PATH="
for /f "delims=" %%i in ('where netlify 2^>nul') do (
    if not defined NF_PATH set "NF_PATH=%%i"
)
set "NF_VER="
for /f "delims=" %%i in ('call netlify --version 2^>nul') do set "NF_VER=%%i"
echo          Netlify CLI is ready: !NF_VER! [OK]
echo          Location: !NF_PATH!
echo.

echo ==================================================
echo    ALL DONE^!  NETLIFY CLI IS INSTALLED.
echo ==================================================
echo.
echo  Next steps:
echo    1. Close this window.
echo    2. Double-click RUN.bat
echo    3. From the menu, pick "Log in to Netlify"
echo    4. Have fun building websites^!
echo.
echo  Quick tip: You can also type   netlify   in any
echo             Command Prompt window from now on.
echo.
pause
exit /b 0


REM ============= ERROR HANDLERS =============

:NO_NODE
echo.
echo [PROBLEM] Node.js is NOT on this computer.
echo.
echo  How to fix:
echo    1. Open your web browser.
echo    2. Go to: https://nodejs.org
echo    3. Click the big green button to download.
echo    4. Pick the "LTS" version (number 20 or higher).
echo    5. Open the file you downloaded and install it.
echo    6. Close this window.
echo    7. Run INSTALL.bat again.
echo.
pause
exit /b 2

:OLD_NODE
echo.
echo [PROBLEM] Your Node.js is TOO OLD.
echo           You have:    !NODE_VER!
echo           Need:        v20.12.2 or higher
echo.
echo  How to fix:
echo    1. Go to: https://nodejs.org
echo    2. Download the latest LTS version.
echo    3. Install it (it will replace the old one).
echo    4. Close this window.
echo    5. Run INSTALL.bat again.
echo.
pause
exit /b 2

:NO_NPM
echo.
echo [PROBLEM] npm is missing from this computer.
echo           npm comes with Node.js.
echo.
echo  How to fix:
echo    1. Re-install Node.js from https://nodejs.org
echo    2. Run INSTALL.bat again.
echo.
pause
exit /b 2

:NO_PREFIX
echo.
echo [PROBLEM] Could not find the npm global folder.
echo           Your npm setup may be broken.
echo.
echo  How to fix:
echo    1. Open Command Prompt.
echo    2. Type: npm config get prefix
echo    3. If it shows an error, re-install Node.js.
echo.
pause
exit /b 3

:INSTALL_FAILED
echo.
echo [PROBLEM] The install did not finish (tried twice).
echo.
echo  This usually means one of these:
echo    1. No internet (open a web browser, try a website).
echo    2. A firewall is blocking npm.
echo    3. A virus scanner is blocking files.
echo    4. Not enough disk space.
echo    5. Your antivirus quarantined files.
echo.
echo  Try this:
echo    1. Pause your antivirus for 10 minutes.
echo    2. Open Command Prompt as Administrator.
echo    3. Type:  npm install -g netlify-cli --force
echo    4. If that works, you are done.
echo.
pause
exit /b 3

:NOT_FOUND_AFTER
echo.
echo [INFO] The install ran, but Windows still cannot find
echo        the netlify command in THIS window.
echo.
echo  This is normal. Just do this:
echo    1. Close this window.
echo    2. Open a NEW window (or just restart your PC).
echo    3. Then run RUN.bat
echo.
pause
exit /b 0
