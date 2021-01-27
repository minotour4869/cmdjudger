@echo off

:init
set home=%cd%
chcp 65001>nul
set total=0
set pass=0

:input
set /p user="Enter username: "
if not exist .\submits\%user% (
	echo [[91mERROR[0m] Invalid username.
	pause 0
	exit /b 1
)
set /p prob="Problem: "
if not exist .\problems\%prob% (
	echo [[91mERROR[0m] Invalid problem.
	pause 0
	exit /b 1
)
if not exist .\submits\%user%\%prob%.cpp (
	echo [[91mERROR[0m] User haven't submited this problem yet.
	pause 0
	exit /b 1
)

:judge
rem **compile file, setup for judging**
echo [[93mJury[0m] Judging problem %prob% from user %user%...
if exist result.log del /q result.log
cd submits\%user%
g++ %prob%.cpp -o %prob%.o -std=c++14 -O2
if not errorlevel 0 (
	echo [91mERROR[0m Compile failed...
	pause 0
	exit /b 1
)
copy %prob%.o "%home%">nul
cd %home%\problems\%prob%\tests
for /d %%i in (*) do (
	set /a total+=1
	echo [[93mJury[0m] Test %%i...
	cd %%i
	copy *.txt %home%>nul
	cd %home%
	ren out.txt ans.txt
	echo Test %%i: >>result.log
	%prob%.o
	fc /a /w out.txt ans.txt>nul
	if not errorlevel 0 echo Wrong Answer.>>result.log else ( 
		echo Correct.>>result.log
		set /a pass+=1
	)
	echo.>>result.log
	del /q *.txt
	cd %home%\problems\%prob%\tests
)
cd %home%
echo [[92mOK[0m] Judging completed, user passed %pass%/%total% test(s), please check result.log for more detail.
del /q %prob%.o
pause 0

