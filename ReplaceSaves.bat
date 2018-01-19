@echo off
setlocal enabledelayedexpansion

set GAMES_FILE_NAME=games.txt
set PROFILES_FILE_NAME=profiles.txt
set PROFILES_LOCATION=profiles

echo 1 create profile
echo 2 change profile
echo 3 add game
	
choice /C 123 /n
if "%ERRORLEVEL%" == "1" (
	echo write profile name
	set /p profileName=
	echo "!profileName!"
	echo %PROFILES_FILE_NAME%

	>nul find "!profileName!" %PROFILES_FILE_NAME% && (
		echo profile !profileName! already exists
	) || (
		echo !profileName! created.
		
		echo !profileName!>>%PROFILES_FILE_NAME%
		mkdir %PROFILES_LOCATION%\!profileName!
	)
) else if "%ERRORLEVEL%" == "2" (
	echo two
) else if "%ERRORLEVEL%" == "3" (
	echo write game name
	set /p gameName=
	echo !gameName!

	echo write saves location
	set /p savesLocation=
	echo !savesLocation!
	(
		echo ^#!gameName! ^#!savesLocation!
	) >> %GAMES_FILE_NAME%
	
	for /F "tokens=*" %%A in (%PROFILES_FILE_NAME%) do (
		echo "%%A"
		mkdir %PROFILES_LOCATION%\%%A\!gameName!
		robocopy !savesLocation! %PROFILES_LOCATION%\%%A\!gameName! /e
	) 
)
goto comment 
mkdir %gameName%
mkdir %~dp0\%gameName%\%profileName%
robocopy %savesLocation% %~dp0\%gameName%\%profileName% /e
:comment
PAUSE