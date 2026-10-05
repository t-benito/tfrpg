@echo off
setlocal

echo Compiling and deploying...
echo.

:: Define the target plugins folder (one directory up from 'scripting', then into 'plugins')
set "TARGET_PLUGINS_DIR=%~dp0..\plugins"

if not defined SP_COMPILER (
    where spcomp.exe >nul 2>&1
    if %ERRORLEVEL%==0 (
        set "SP_COMPILER=spcomp.exe"
    ) else (
        echo Error: spcomp.exe not found in PATH or environment.
        exit /b 2
    )
)

:: Ensure the target plugins folder actually exists before compiling
if not exist "%TARGET_PLUGINS_DIR%" (
    echo Target plugins directory does not exist. Creating it at:
    echo %TARGET_PLUGINS_DIR%
    mkdir "%TARGET_PLUGINS_DIR%"
)

:: Loop and compile directly into the plugins directory
for /r "%~dp0" %%F in (*.sp) do (
    echo Compiling %%~nxF -> plugins\%%~nF.smx
    
    :: The -o flag tells spcomp exactly where to save the compiled file
    "%SP_COMPILER%" "%%~fF" -o "%TARGET_PLUGINS_DIR%\%%~nF.smx"
    
    if ERRORLEVEL 1 (
        echo.
        echo Compiler returned error for "%%~fF"
        exit /b 1
    )
)

echo.
echo All .sp files compiled and deployed successfully to:
echo %TARGET_PLUGINS_DIR%
endlocal
