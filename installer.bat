@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

:: Check for admin rights (needed to write to C:\)
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo This installer must be run as Administrator.
    pause
    exit /b 1
)

:prompt
set /p "choice=Do you want to install CoreNul? (Y/N): "
if /i "!choice!"=="N" exit /b 0
if /i "!choice!" NEQ "Y" goto prompt

if not exist "corenul.pkg" (
    echo Error: corenul.pkg not found in this folder.
    echo Looking in: %cd%
    pause
    exit /b 1
)

echo Installing CoreNul...
tar -xf "corenul.pkg" -C "C:\"
if %errorlevel% neq 0 (
    echo tar exited with code %errorlevel%
    pause
    exit /b 1
)

if not exist "C:\corenul\CoreNul.lnk" (
    echo Error: installation appears incomplete ^(shortcut not found^).
    pause
    exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "$desktop = [System.Environment]::GetFolderPath('Desktop'); Copy-Item 'C:\corenul\CoreNul.lnk' -Destination $desktop -Force"
if %errorlevel% neq 0 (
    echo Error: could not create desktop shortcut.
    pause
    exit /b 1
)

echo CoreNul installed successfully.

:: Self-destruct sequence
(goto) 2>nul & del "%~f0"