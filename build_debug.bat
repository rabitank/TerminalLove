@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "ENGINE_DIR=%SCRIPT_DIR%engine"

if not exist "%ENGINE_DIR%" (
    echo [ERROR] engine directory not found: %ENGINE_DIR%
    exit /b 1
)
if not exist "%ENGINE_DIR%\Cargo.toml" (
    echo [ERROR] Cargo.toml not found in engine directory
    exit /b 1
)

echo [BUILD] Building debug...
cd /d "%ENGINE_DIR%"
call cargo build  -p tmj_terminal
if errorlevel 1 (
    echo [ERROR] Build failed
    exit /b %errorlevel%
)

set "RELEASE_DIR=%ENGINE_DIR%\target\debug"
set "OK=0"

if exist "%RELEASE_DIR%\tmj_terminal.exe" (
    copy /y "%RELEASE_DIR%\tmj_terminal.exe" "%SCRIPT_DIR%\tmj_tdebug.exe" > nul
    if not errorlevel 1 (
        echo [OK] tmj_terminal.exe -^> tmj_tdebug.exe
        set "OK=1"
    ) else (
        echo [ERROR] Failed to copy tmj_terminal.exe
    )
) else (
    echo [ERROR] tmj_terminal.exe not found
)


echo [DONE] Artifacts output to: %SCRIPT_DIR%
