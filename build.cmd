@echo off
setlocal EnableExtensions DisableDelayedExpansion
rem GeniaClipboard 0.5.9 RC1 - isolated portable Windows build.
rem Run from the extracted full SOURCE ZIP. Does NOT execute the built EXE.
rem Does not change any existing GeniaClipboard Vault, Data or install.
rem Restore uses the official NuGet v3 feed for missing .NET 8 targeting packs.
rem Keep this .cmd in Windows CRLF format; Github source ZIP keeps raw bytes.

cd /d "%~dp0"
if errorlevel 1 goto :bad_directory

set "PROJECT=%CD%\GeniaClipboard.csproj"
set "OUT=%CD%\TEST_PUBLISH"
set "NUGET_FEED=https://api.nuget.org/v3/index.json"

echo.
echo === GeniaClipboard 0.5.9 RC1 - Windows source build ===
echo Source: %CD%
echo Output: %OUT%
echo Mode: isolated / no EXE execution
echo.

if not exist "%PROJECT%" goto :missing_project
findstr /L /C:"<Version>0.5.9-rc.1</Version>" "%PROJECT%" >nul
if errorlevel 1 goto :bad_version
where dotnet >nul 2>nul
if errorlevel 1 goto :missing_dotnet

rem Avoid overwriting any previous test build, including its local Data/Vault.
if exist "%OUT%\" goto :existing_output

echo [1/4] Installed .NET SDK
dotnet --version
if errorlevel 1 goto :failed

echo.
echo [2/4] Restore using official NuGet feed
echo Source: %NUGET_FEED%
dotnet restore "%PROJECT%" --source "%NUGET_FEED%" --nologo
if errorlevel 1 goto :restore_failed

echo.
echo [3/4] Release self-contained x64 single-file publish
dotnet publish "%PROJECT%" -c Release --no-restore -o "%OUT%" --nologo
if errorlevel 1 goto :failed

if not exist "%OUT%\GeniaClipboard.exe" goto :missing_exe

echo.
echo [4/4] SHA-256 of built EXE
certutil -hashfile "%OUT%\GeniaClipboard.exe" SHA256
if errorlevel 1 goto :failed

echo.
echo RESULT=BUILD_PASS_EXE_NOT_EXECUTED
echo NOTE: Review the built EXE with Windows Security before running it.
echo NOTE: This build does not prove that the new feature passes desktop QA.
echo EXE=%OUT%\GeniaClipboard.exe
set "CODE=0"
goto :finish

:missing_project
echo ERROR: GeniaClipboard.csproj is missing. Extract the entire source ZIP.
goto :failed

:bad_version
echo ERROR: Expected GeniaClipboard 0.5.9-rc.1 source project.
goto :failed

:missing_dotnet
echo ERROR: .NET SDK is not installed or is missing from PATH.
goto :failed

:existing_output
echo ERROR: TEST_PUBLISH already exists. It will NOT be overwritten.
echo Move the entire isolated TEST_PUBLISH directory aside before rebuilding.
goto :failed

:bad_directory
echo ERROR: Cannot open the source directory.
goto :failed

:restore_failed
echo ERROR: NuGet restore failed.
echo The project targets .NET 8. Missing ref/runtime packs may require access
echo to the official https://api.nuget.org/v3/index.json source.
echo Check Internet/TLS/proxy settings. Do not disable Windows security.
goto :failed

:missing_exe
echo ERROR: Publish ended without GeniaClipboard.exe.
goto :failed

:failed
echo.
echo RESULT=BUILD_FAIL
set "CODE=1"
goto :finish

:finish
echo.
if /I not "%CI%"=="true" pause
exit /b %CODE%
