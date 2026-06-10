@echo off
setlocal

:: 获取脚本所在目录 (%~dp0 末尾自带反斜杠，为兼容 wt 需去掉)
set "SCRIPT_DIR=%~dp0"
set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"
set "EXE_PATH=%SCRIPT_DIR%\tmj.exe"

:: 检查文件是否存在
if not exist "%EXE_PATH%" (
    echo [错误] 找不到程序: "%EXE_PATH%"
    echo 请确保 tmj.exe 和此脚本在同一文件夹内。
    pause
    exit /b
)

:: 核心修复：添加 -- 分隔符，明确告诉 wt 后面是要执行的命令，不是 wt 自身的参数
wt -d "%SCRIPT_DIR%" -- cmd.exe /k ""%EXE_PATH%""

:: 如果 wt 启动失败（如未安装），自动降级到系统默认控制台
if errorlevel 1 (
    echo [提示] Windows Terminal 启动异常，正在使用默认控制台运行...
    start "" cmd.exe /k ""%EXE_PATH%""
)