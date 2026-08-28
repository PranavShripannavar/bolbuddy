@echo off
setlocal
cd /d "%~dp0"
where py >nul 2>nul
if %errorlevel%==0 (
  set "BOLBUDDY_PYTHON=py"
) else (
  set "BOLBUDDY_PYTHON=C:\Users\shrip\.cache\codex-runtimes\codex-primary-runtime\dependencies\python\python.exe"
)
where node >nul 2>nul
if errorlevel 1 (
  echo Node.js is required to run BolBuddy.
  pause
  exit /b 1
)
start "BolBuddy server" /min cmd /c "node server.js"
timeout /t 2 /nobreak >nul
start "BolBuddy" http://127.0.0.1:4173
endlocal
