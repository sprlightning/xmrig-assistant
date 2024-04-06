@echo off
rem 关闭echo命令显示

chcp 65001
rem 强制开启UTF-8，以支持中文显示

rem 为本脚本获取管理员权限
ver | findstr "10\.[0-9]\.[0-9]*" >nul && goto powershellAdmin

:mshtaAdmin
rem 原理是利用mshta运行vbscript脚本给bat文件提权
rem 这里使用了前后带引号的%~dpnx0来表示当前脚本，比原版的短文件名%~s0更可靠
rem 这里使用了两次Net session，第二次是检测是否提权成功，如果提权失败则跳转到failed标签
rem 这有效避免了提权失败之后bat文件继续执行的问题
Net session >nul 2>&1 || mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c ""%~dpnx0""","","runas",1)(window.close)&&exit
Net session >nul 2>&1 || goto failed
goto Admin

:powershellAdmin
rem 原理是利用powershell给bat文件提权
rem 这里使用了两次Net session，第二次是检测是否提权成功，如果提权失败则跳转到failed标签
rem 这有效避免了提权失败之后bat文件继续执行的问题
Net session >nul 2>&1 || powershell start-process \"%0\" -verb runas && exit
Net session >nul 2>&1 || goto failed
goto Admin

:failed
echo 提权失败，可能是杀毒软件拦截了提权操作，或者您没有同意UAC提权申请。
echo 建议您右键点击此脚本，选择“以管理员身份运行”。
echo 按任意键退出。
pause >nul
exit

:Admin
echo 本脚本处理所在路径：%0
echo 已获取管理员权限！
ping 127.0.0.1 -n 1 > nul
echo 如果此窗口标题处显示“管理员”字样，那就说明提权成功了。

echo 尝试将工作目录转移到软件目录...
cd /d %~dp0
rem 切换软件工作目录到软件所在文件夹
ping 127.0.0.1 -n 1 > nul
echo 目录转移成功！

rem 在后台运行本脚本
if "%1" == "h" goto begin
mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin

rem 在这里设置目标程序
set executable=xmrig.exe
set brother=HadesXmrig-background[1.4].bat
set /a counter=0
set TITLE=GaiaXmrig-background-admin[1.4]

rem 设置标题
title %TITLE%

echo -------------------------------------------------------------------------------- > %TITLE%.log
echo [%DATE%%TIME:~0,8%]本脚本[%TITLE%]正在以管理员模式运行！ >> %TITLE%.log
echo 本脚本用于守护%executable%，保证其始终处于高效运行状态 >> %TITLE%.log
echo 更新于：2024年3月30日，by HPL. >> %TITLE%.log
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo: >> %TITLE%.log
echo:
echo --------------------------------------------------------------------------------
echo [%DATE%%TIME:~0,8%]本脚本[%TITLE%]正在以管理员模式运行！
ping 127.0.0.1 -n 1 > nul
echo 本脚本用于守护%executable%，保证其始终处于高效运行状态
ping 127.0.0.1 -n 1 > nul
echo 更新于：2024年3月30日，by HPL.
echo --------------------------------------------------------------------------------
echo:

start %brother%
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo [%DATE%%TIME:~0,8%][已开启%brother%用于关闭异常的目标程序%executable%] >> %TITLE%.log
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo: >> %TITLE%.log
echo --------------------------------------------------------------------------------
echo [%DATE%%TIME:~0,8%][已开启%brother%用于关闭异常的目标程序%executable%]
echo --------------------------------------------------------------------------------
echo:

echo [%DATE%%TIME:~0,8%]目标程序扫描中... >> %TITLE%.log
echo: >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]目标程序扫描中...
echo:


:checkrun
tasklist|findstr /i "%executable%"
if errorlevel 1 (
echo [%DATE%%TIME:~0,8%]未检测到正在运行的%executable%，准备开启%executable%... >> %TITLE%.log
echo counter[%counter%] >> %TITLE%.log
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]未检测到正在运行的%executable%，准备开启%executable%...
echo counter[%counter%]
echo --------------------------------------------------------------------------------
goto start
)
if errorlevel 0 (
echo [%DATE%%TIME:~0,8%]已找到%executable%，循环扫描中[5s]...
echo counter[%counter%]
echo --------------------------------------------------------------------------------
timeout 5
goto checkrun
)
timeout 5

:start
echo: >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]正在以后台模式开启%executable%... >> %TITLE%.log
echo:
echo [%DATE%%TIME:~0,8%]正在以后台模式开启%executable%...
rem 使用powershell在后台运行xmrig
powershell -command "& {Start-Process %executable% -WindowStyle Hidden}"

rem 前台运行xmrig（测试用）
::start %executable%
ping 127.0.0.1 -n 1 > nul
echo:
echo [%DATE%%TIME:~0,8%]已成功开启%executable%！ >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]已成功开启%executable%！
echo counter[%counter%] >> %TITLE%.log
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo: >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]5s后进入运行状态检测checkrun... >> %TITLE%.log
echo: >> %TITLE%.log
echo:
echo [%DATE%%TIME:~0,8%]5s后进入运行状态检测checkrun...
timeout 5
set /a counter+=1
goto checkrun
