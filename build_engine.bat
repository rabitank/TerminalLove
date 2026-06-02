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

echo [BUILD] Building release...
cd /d "%ENGINE_DIR%"
call cargo build --release -p tmj_terminal -p tmj_egui
if errorlevel 1 (
    echo [ERROR] Build failed
    exit /b %errorlevel%
)

set "RELEASE_DIR=%ENGINE_DIR%\target\release"
set "OK=0"

if exist "%RELEASE_DIR%\tmj_terminal.exe" (
    copy /y "%RELEASE_DIR%\tmj_terminal.exe" "%SCRIPT_DIR%\tmj.exe" > nul
    if not errorlevel 1 (
        echo [OK] tmj_terminal.exe -^> tmj.exe
        set "OK=1"
    ) else (
        echo [ERROR] Failed to copy tmj_terminal.exe
    )
) else (
    echo [ERROR] tmj_terminal.exe not found
)

if exist "%RELEASE_DIR%\tmj_egui.exe" (
    copy /y "%RELEASE_DIR%\tmj_egui.exe" "%SCRIPT_DIR%\tmj_gui.exe" > nul
    if not errorlevel 1 (
        echo [OK] tmj_egui.exe -^> tmj_gui.exe
        set "OK=1"
    ) else (
        echo [ERROR] Failed to copy tmj_egui.exe
    )
) else (
    echo [ERROR] tmj_egui.exe not found
)

if "%OK%"=="0" (
    echo [ERROR] No artifacts were copied
    exit /b 1
)

echo [DONE] Artifacts output to: %SCRIPT_DIR%
