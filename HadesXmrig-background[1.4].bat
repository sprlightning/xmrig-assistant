@echo off
rem 关闭echo命令显示

chcp 65001
rem 强制开启UTF-8，以支持中文显示

echo 尝试将工作目录转移到软件目录...
cd /d %~dp0
rem 切换软件工作目录到软件所在文件夹
ping 127.0.0.1 -n 1 > nul
echo 目录转移成功！

rem 在后台运行本脚本
if "%1" == "h" goto begin
mshta vbscript:createobject("wscript.shell").run("""%~nx0"" h",0)(window.close)&&exit
:begin

rem 设置目标程序，复查间隔；stoplevel为CPU最小占用率，低于该值认为目标程序工作异常
set executable=xmrig.exe
set recheckseconds=600
set stoplevel=30
set /a counter=0
set TITLE=HadesXmrig-background[1.4]

rem 设置标题
title %TITLE%

echo -------------------------------------------------------------------------------- > %TITLE%.log
echo [%DATE%%TIME:~0,8%]本脚本[%TITLE%]由GaiaXmrig-background-admin[1.4]启动 >> %TITLE%.log
echo 用于关闭卡住的%executable%进程 >> %TITLE%.log
echo 更新于：2024年3月30日，by HPL. >> %TITLE%.log
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo: >> %TITLE%.log
echo:
echo --------------------------------------------------------------------------------
echo [%DATE%%TIME:~0,8%]本脚本[%TITLE%]GaiaXmrig-background-admin[1.4]启动
echo 用于关闭卡住的%executable%进程
ping 127.0.0.1 -n 1 > nul
echo 更新于：2024年3月30日，by HPL.
echo --------------------------------------------------------------------------------
echo:

echo 目标程序扫描中... >> %TITLE%.log
echo: >> %TITLE%.log
echo 目标程序扫描中...
echo:

:checkrun
rem 用于检测目标程序是否在运行
tasklist|findstr /i "%executable%"
if errorlevel 1 (
echo [%DATE%%TIME:~0,8%]未检测到正在运行的%executable%，循环扫描中[5s]...
echo counter[%counter%]
echo --------------------------------------------------------------------------------
timeout 5
goto checkrun
)
if errorlevel 0 (
echo [%DATE%%TIME:~0,8%]已找到%executable%，将在5s后判断是否关闭%executable%！
echo --------------------------------------------------------------------------------
timeout 5
goto checkerror
)

:checkerror
rem 用于依据CPU占用率判断目标程序是否正确运行，由此决定是否关闭目标程序
:checklevel1
rem 判断CPU占用率是否低于阈值，低于则认为目标程序第一次出错，等待%recheckseconds%s进入第二次判断；否则认为程序正常运行，返回运行状态检测checkrun
rem 运行wmic命令并捕获输出CPU占用率
for /f "tokens=2 delims==" %%a in ('wmic path Win32_PerfFormattedData_PerfOS_Processor get PercentProcessorTime /value^|findstr "PercentProcessorTime"') do (
set CPU_USAGE=%%a
)

if %CPU_USAGE% lss %stoplevel% (
echo [%DATE%%TIME:~0,8%][checklevel1]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%. >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]%executable%工作异常，准备在%recheckseconds%s后进行第二次判断 >> %TITLE%.log
echo: >> %TITLE%.log
echo [%DATE%%TIME:~0,8%][checklevel1]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%.
echo [%DATE%%TIME:~0,8%]%executable%工作异常，准备在%recheckseconds%s后进行第二次判断
timeout %recheckseconds%
goto checklevel2
) else (
echo [%DATE%%TIME:~0,8%][checklevel1]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%.
echo [%DATE%%TIME:~0,8%]%executable%工作正常，5s后返回运行状态检测checkrun
echo --------------------------------------------------------------------------------
echo:
ping 127.0.0.1 -n 5 > nul
goto checkrun
)

:checklevel2
rem 判断CPU占用率是否低于阈值，低于则认为目标程序第二次出错，等待%recheckseconds%s进入第三次判断；否则认为程序正常运行，返回运行状态检测checkrun
rem 运行wmic命令并捕获输出CPU占用率
for /f "tokens=2 delims==" %%a in ('wmic path Win32_PerfFormattedData_PerfOS_Processor get PercentProcessorTime /value^|findstr "PercentProcessorTime"') do (
set CPU_USAGE=%%a
)

if %CPU_USAGE% lss %stoplevel% (
echo [%DATE%%TIME:~0,8%][checklevel2]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%. >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]%executable%工作异常，准备在%recheckseconds%s后进行第三次判断 >> %TITLE%.log
echo: >> %TITLE%.log
echo [%DATE%%TIME:~0,8%][checklevel2]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%.
echo [%DATE%%TIME:~0,8%]%executable%工作异常，准备在%recheckseconds%s后进行第三次判断
timeout %recheckseconds%
goto checklevel3
) else (
echo [%DATE%%TIME:~0,8%][checklevel2]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%. >> %TITLE%.log
echo [%DATE%%TIME:~0,8%][checklevel2]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%.
echo [%DATE%%TIME:~0,8%]%executable%工作正常，5s后返回运行状态检测checkrun >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]%executable%工作正常，5s后返回运行状态检测checkrun
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo: >> %TITLE%.log
echo --------------------------------------------------------------------------------
echo:
ping 127.0.0.1 -n 5 > nul
goto checkrun
)

:checklevel3
rem 判断CPU占用率是否低于阈值，低于则认为目标程序第三次出错，5s后关闭目标程序；否则认为程序正常运行，返回运行状态检测checkrun
rem 运行wmic命令并捕获输出CPU占用率
for /f "tokens=2 delims==" %%a in ('wmic path Win32_PerfFormattedData_PerfOS_Processor get PercentProcessorTime /value^|findstr "PercentProcessorTime"') do (
set CPU_USAGE=%%a
)

if %CPU_USAGE% lss %stoplevel% (
echo [%DATE%%TIME:~0,8%][checklevel3]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%. >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]%executable%工作异常，准备在5s后关闭目标程序%executable%! >> %TITLE%.log
echo: >> %TITLE%.log
echo [%DATE%%TIME:~0,8%][checklevel3]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%.
echo [%DATE%%TIME:~0,8%]%executable%工作异常，准备在5s后关闭目标程序%executable%!
goto stop
) else (
echo [%DATE%%TIME:~0,8%][checklevel3]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%. >> %TITLE%.log
echo [%DATE%%TIME:~0,8%][checklevel3]当前CPU占用率为：%CPU_USAGE%%%，阈值为%stoplevel%%%.
echo [%DATE%%TIME:~0,8%]%executable%工作正常，5s后返回运行状态检测checkrun >> %TITLE%.log
echo [%DATE%%TIME:~0,8%]%executable%工作正常，5s后返回运行状态检测checkrun
echo -------------------------------------------------------------------------------- >> %TITLE%.log
echo: >> %TITLE%.log
echo --------------------------------------------------------------------------------
echo:
ping 127.0.0.1 -n 5 > nul
goto checkrun
)

:stop
timeout 5 >> %TITLE%.log
taskkill /f /im %executable%
ping 127.0.0.1 -n 1 > nul
echo:
echo [%DATE%%TIME:~0,8%]已成功关闭%executable%！ >> %TITLE%.log
echo --------------------------------------------------------------------------------
echo [%DATE%%TIME:~0,8%]已成功关闭%executable%！
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
