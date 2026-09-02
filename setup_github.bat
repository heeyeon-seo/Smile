@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ============================================
echo   GitHub upload prep
echo ============================================
echo.

REM --- Detect project type ---
set "PROJTYPE="
if exist "pubspec.yaml" set "PROJTYPE=Flutter"
if exist "settings.gradle" set "PROJTYPE=Android"
if exist "settings.gradle.kts" set "PROJTYPE=Android"

if "%PROJTYPE%"=="" (
  echo [ERROR] No project file found in this folder.
  echo Expected pubspec.yaml ^(Flutter^) or settings.gradle ^(Android^).
  echo Put this script in your project's top folder and run it there.
  echo.
  pause
  exit /b 1
)
echo [OK] %PROJTYPE% project detected.

REM --- Check prepared files ---
if not exist ".gitignore" (
  echo [ERROR] .gitignore not found. Copy it into this folder first.
  pause
  exit /b 1
)
if not exist "README.md" (
  echo [WARN] README.md not found. Uploading without one is fine,
  echo        but a README makes the project much easier to review.
  echo.
)
echo [OK] .gitignore is in place.
echo.

REM --- Locate git ---
set "GITEXE=git"
where git >nul 2>&1
if errorlevel 1 (
  set "FOUND="
  for /d %%D in ("%LOCALAPPDATA%\GitHubDesktop\app-*") do (
    if exist "%%D\resources\app\git\cmd\git.exe" (
      set "GITEXE=%%D\resources\app\git\cmd\git.exe"
      set "FOUND=1"
    )
  )
  if not defined FOUND (
    echo [ERROR] git was not found on this computer.
    echo Install GitHub Desktop first, then run this again.
    pause
    exit /b 1
  )
)
echo [OK] git found.
echo.

REM --- Initialise repo ---
if not exist ".git" (
  "%GITEXE%" init -b main >nul
  echo [OK] Repository initialised.
) else (
  echo [OK] Repository already exists.
)
echo.

REM --- Stage and commit ---
"%GITEXE%" add -A
"%GITEXE%" -c user.name="heeyeon-seo" -c user.email="heeyeon-seo@users.noreply.github.com" commit -m "Initial commit" >nul 2>&1
if errorlevel 1 (
  echo [INFO] Nothing new to commit, or a commit already exists.
) else (
  echo [OK] Commit created.
)
echo.

echo ============================================
echo   Files staged for upload:
echo ============================================
"%GITEXE%" ls-files
echo.
echo --- Sanity check ---
echo If you see build/, .dart_tool/, local.properties,
echo google-services.json or *.jks above, STOP and fix
echo .gitignore before publishing.
echo.
echo ============================================
echo   NEXT STEPS
echo   1. Open GitHub Desktop
echo   2. File - Add an Existing Repository
echo   3. Choose this folder
echo   4. Click "Publish repository"
echo      (uncheck "Keep this code private")
echo ============================================
echo.
pause
