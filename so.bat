@echo off
setLocal enabledelayedexpansion

set /p "tmp_p=Enter Disk label<A-Z>: "
set "tmp_p=%tmp_p%:\"

call :GetTopSizeDir %tmp_p%

dir /b "%_return%"

:confirm_loop
set /p "confirm=Do You want to delete all file under '%_return%'?<Y/N>"

if not defined confirm set "confirm=Y"

if "%confirm%" equ "Y" (
    forfiles /p "%_return%" /s /d -1 /c "cmd /c del /q @file"
) else if "%confirm%" equ "y" (
    forfiles /p "%_return%" /s /d -1 /c "cmd /c del /q @file"
) else if "%confirm%" equ "N" (
    pause
    goto :eof
) else if "%confirm%" equ "n" (
    pause
    goto :eof
) else (
    echo "Error: WRONG INPUT"
    goto :confirm_loop
)

pause
endlocal && goto :eof

:GetTopSizeDir
@echo off
setlocal enabledelayedexpansion

set "tgt=%~1"

:loop
set "largest_dir="
set "max_size=0"

for /d %%a in ("%tgt%\*") do (
    set "dir_path=%%~fa"
    for /f "tokens=3" %%b in ('dir /-c /a /w /s "!dir_path!\*" 2^>nul ^| findstr "File(s)"') do (
        if 1%%b equ +1%%b set "dir_size=%%b"
        if !dir_size! gtr !max_size! (
                set "max_size=!dir_size!"
                set "largest_dir=!dir_path!"
        )
    )
)

if defined largest_dir (
    set "tgt=%largest_dir%"
    goto :loop
)

endlocal && set "_return=%tgt%"
exit /b
:: /GetTopSizeDir



