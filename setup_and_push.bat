@echo off
echo ==========================================================
echo   Pushing Repositories Online (Main & Submodule) to GitHub
echo ==========================================================
powershell -ExecutionPolicy Bypass -File "%~dp0setup_and_push.ps1" %*
pause
