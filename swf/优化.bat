@echo off

set fuckBAT=���õļӸ��ո񶼲���.............

set garden=bin\module\botanicalgarden\garden.swf
set market=bin\module\market\MarketMain.swf
set slave=bin\module\slave\slaveFLA.swf

:start
@echo Ҫ�Ż��ĸ�?

@echo 1: ��ֲ԰
@echo 2: �̳�
@echo 3: ū��
@echo 4: All

set /p input=���ѡ��:  
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
FOR %%i IN (%garden%,%market%,%slave%) DO call �����Ż�.bat %%i
pause
exit

:run
call �����Ż�.bat %target%
pause
exit
