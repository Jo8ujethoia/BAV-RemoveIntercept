@echo off
title Restore BAVInterception by Jo8ujethoia
setlocal

:: Check for administrative privileges
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo Please run this program as an administrator.
    pause
    exit /b
)

:menu
cls
echo ================================
echo   Restore BAVInterception
echo ================================
echo.
echo Warning: This cannot be restored. After this BAV will no longer be able
echo to enable BAVInterception.
echo Note: If you do not want to uninstall BAVInterception, close this Window.
pause

:: Confirmation prompt
set /p confirm="Are you sure you want to proceed? (Y/N): "
if /i not "%confirm%"=="Y" (
    echo Operation canceled.
    exit /b
)

cls
echo Backing up current registry settings...
mkdir "%~dp0Backup" >nul 2>&1
for %%A in ("batfile" "cmdfile" "exefile" "VBSFile" "VBEfile" "JSFile" "JSEfile" "comfile" "mscfile" "WSFFile" "WSHFile") do (
    reg export "HKEY_CLASSES_ROOT\%%~A" "%~dp0Backup\%%~A_backup.reg" >nul 2>&1
)

echo Removing Batch Antivirus protection...
for %%A in ("batfile" "cmdfile" "exefile" "VBSFile" "VBEfile" "JSFile" "JSEfile" "comfile" "mscfile" "WSFFile" "WSHFile") do (
    reg delete "HKEY_CLASSES_ROOT\%%~A\shell\open\command" /f >nul 2>&1 && (
        echo Protection removed for '%%~A'
    ) || (
        echo Failed to remove protection for '%%~A'
    )
)

echo Removing Batch Antivirus from context menu...
reg delete "HKEY_CLASSES_ROOT\*\shell\BatchAntivirus" /f >nul 2>&1 && (
    echo Batch Antivirus removed from context menu.
) || (
    echo Failed to remove Batch Antivirus from context menu.
)

echo Restoring registry backups...
for %%A in ("batfile" "cmdfile" "exefile" "VBSFile" "VBEfile" "JSFile" "JSEfile" "comfile" "mscfile" "WSFFile" "WSHFile") do (
    if exist "%~dp0RegBackup\%%~A_backup.reg" (
        reg import "%~dp0RegBackup\%%~A_backup.reg" >nul 2>&1
        if %errorLevel%==0 (
            echo Restored backup for '%%~A'.
        ) else (
            echo Failed to restore backup for '%%~A'.
        )
    ) else (
        echo No backup found for '%%~A'.
    )
)

if exist "%~dp0RegBackup\shell_backup.reg" (
    reg import "%~dp0RegBackup\shell_backup.reg" >nul 2>&1
    if %errorLevel%==0 (
        echo Restored context menu backup.
    ) else (
        echo Failed to restore context menu backup.
    )
) else (
    echo No context menu backup found.
)

echo.
echo ================================
echo   Restore BAVInterception
echo ================================
echo.
echo Thank you for using my software!
echo [!] You can see the log above.
echo.
pause
exit
