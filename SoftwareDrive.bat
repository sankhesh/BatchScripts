@echo off
rem Automated evaluation of the best drive to install software like clink, conemu
REM  cls
echo Checking software drive for system
setlocal enableextensions enabledelayedexpansion
set "_DRIVE.LETTERS.FREE=Z Y X W V U T S R Q P O N M L K J I H G F E D C B A "
for /f "skip=1 tokens=1,2 delims=: " %%a in ('wmic logicaldisk get deviceid') do (
   set "_DRIVE.LETTERS.USED=!_DRIVE.LETTERS.USED!%%a,%%b"
   set "_DRIVE.LETTERS.FREE=!_DRIVE.LETTERS.FREE:%%a =!"
)
set _DRIVE.LETTERS.USED=%_DRIVE.LETTERS.USED:~0,-2%
set _DRIVE.LETTERS.USED=%_DRIVE.LETTERS.USED:,@=, @%

set /A _FOLDER_COUNT = 0
for %%i in (%_DRIVE.LETTERS.USED:, =%) do (
  set SOFTF=%%i:\Software
  set /p var="Testing !SOFTF!..." <nul
  if EXIST !SOFTF! (
    echo exists
    set _SOFTWARE_FOLDER=!_SOFTWARE_FOLDER!;%%i
    set /A _FOLDER_COUNT += 1
  ) else (
    echo doesn't exist
  )
)

if defined _SOFTWARE_FOLDER (
  set _SOFTWARE_FOLDER=!_SOFTWARE_FOLDER:~1!
  set DRIVETOUSE=!_SOFTWARE_FOLDER!
  if %_FOLDER_COUNT% GTR 1 (
    echo Multiple possible software drives found. Please choose one:
    set /A cnt = 1
    call :iterate "!_SOFTWARE_FOLDER!"
    goto :final
    :iterate
    set list=%1
    for /f "tokens=1* delims=;" %%a in ("!list!") do (
      set ac=%%a
      echo     !cnt!] !ac:"=!
      set /A cnt += 1
      if not "%%b" == "" ( 
        call :iterate %%b
      ) else (
        call :input
      )
    )
    goto :final
    :input
    set /p chosenpath="Choose number from above: "
    if /I !chosenpath! GEQ !cnt! (
      goto :input
    )
    if /i !chosenpath! LEQ 0 (
      goto :input
    )
    set _TMP=!_SOFTWARE_FOLDER:;=!
    set /A chosenpath -= 1
    set DRIVETOUSE=!_TMP:~%chosenpath%,1!
    goto :final
  )
) else (
  echo INFO: Couldn't find `Software` folder in any drive. Defaulting to drive C
  set DRIVETOUSE=C
)
:final
endlocal & set "DRIVETOUSE=%DRIVETOUSE%"
set DRIVETOUSE
REM  set _DRIVE.LETTERS
