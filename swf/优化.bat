@echo off

set fuckBAT=他妹的加个空格都不行.............

set garden=bin\module\botanicalgarden\garden.swf
set market=bin\module\market\MarketMain.swf
set slave=bin\module\slave\slaveFLA.swf

:start
@echo 要优化哪个?

@echo 1: 种植园
@echo 2: 商城
@echo 3: 奴隶
@echo 4: All

set /p input=你的选择:  
goto %input%

:1
set target=%garden%
goto run
:2
set target=%market%
goto run
:3
set target=%slave%
goto run
:4
FOR %%i IN (%garden%,%market%,%slave%) DO call 各种优化.bat %%i
pause
exit

:run
call 各种优化.bat %target%
pause
exit
