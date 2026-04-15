@echo off
setlocal enabledelayedexpansion

REM 获取脚本所在目录
set "SCRIPT_DIR=%~dp0"
set "ENGINE_DIR=%SCRIPT_DIR%engine"

REM 检查 engine 目录和 Cargo.toml
if not exist "%ENGINE_DIR%" (
    echo [错误] 找不到 engine 目录: %ENGINE_DIR%
    exit /b 1
)
if not exist "%ENGINE_DIR%\Cargo.toml" (
    echo [错误] engine 目录下没有 Cargo.toml
    exit /b 1
)

echo [编译] 正在编译 engine 的 release 版本...
cd /d "%ENGINE_DIR%"
call cargo build --release
if errorlevel 1 (
    echo [错误] 编译失败
    exit /b %errorlevel%
)

REM 从 Cargo.toml 获取包名
set "PACKAGE_NAME="
for /f "tokens=2 delims== " %%a in ('findstr /i "^name =" Cargo.toml') do (
    set "PACKAGE_NAME=%%~a"
    goto :found
)
:found
if "%PACKAGE_NAME%"=="" (
    set "PACKAGE_NAME=engine"
)

set "EXE_NAME=%PACKAGE_NAME%.exe"
set "SOURCE_PATH=%ENGINE_DIR%\target\release\%EXE_NAME%"
set "DEST_PATH=%SCRIPT_DIR%%EXE_NAME%"

if exist "%SOURCE_PATH%" (
    copy /y "%SOURCE_PATH%" "%DEST_PATH%" > nul
    echo [成功] 可执行文件已输出至: %DEST_PATH%
) else (
    echo [错误] 未找到编译产物: %SOURCE_PATH%
    echo        请检查项目是否生成了 %EXE_NAME%
    exit /b 1
)
