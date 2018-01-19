@echo off
setlocal enabledelayedexpansion

set GAMES_FILE_NAME=games.txt
set PROFILES_FILE_NAME=profiles.txt
set PROFILES_LOCATION=profiles
set CURRENT_PROFILE_FILE_NAME=currentProfile.txt

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
		
		for /F "tokens=1,2 delims=# " %%i in (%GAMES_FILE_NAME%) do (
		echo "%%i" and "%%j"
		mkdir %PROFILES_LOCATION%\!profileName!\%%i
		robocopy %%j %PROFILES_LOCATION%\!profileName!\%%i /e /njh /njs /ndl /nc /ns
		)
	)
) else if "%ERRORLEVEL%" == "2" (
	echo write profile name
	set /p profileName=
	echo "!profileName!"
	set /p currentProfile=<%CURRENT_PROFILE_FILE_NAME%
	
	>nul find "!profileName!" %PROFILES_FILE_NAME% && (
		for /F "tokens=1,2 delims=# " %%i in (%GAMES_FILE_NAME%) do (
			echo "%%i" and "%%j"
			robocopy %%j %PROFILES_LOCATION%\!currentProfile!\%%i /e /njh /njs /ndl /nc /ns
			robocopy %PROFILES_LOCATION%\!profileName!\%%i %%j /e /njh /njs /ndl /nc /ns
		)
		echo !profileName!>%CURRENT_PROFILE_FILE_NAME%
	) || (
		echo profile "!profileName!" doesn't exist
	)
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
		robocopy !savesLocation! %PROFILES_LOCATION%\%%A\!gameName! /e /njh /njs /ndl /nc /ns
	) 
)
:comment
PAUSE