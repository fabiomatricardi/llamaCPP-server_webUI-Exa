@echo off
setlocal

set "ROOT=%~dp0"
set "LLAMA_DIR=%ROOT%llamaCPP"
set "MODEL_DIR=%LLAMA_DIR%\model"
set "SERVER_EXE=%LLAMA_DIR%\llama-server.exe"
set "MODEL_FILE=%MODEL_DIR%\LFM2.5-1.2B-Instruct-Q6_K.gguf"
set "LLAMA_ZIP_URL=https://github.com/ggml-org/llama.cpp/releases/download/b11342/llama-b11342-bin-win-vulkan-x64.zip"
set "MODEL_URL=https://huggingface.co/LiquidAI/LFM2.5-1.2B-Instruct-GGUF/resolve/main/LFM2.5-1.2B-Instruct-Q6_K.gguf"
set "ZIP_FILE=%TEMP%\llama-b11342-%RANDOM%-%RANDOM%.zip"

where.exe curl.exe >nul 2>&1
if errorlevel 1 (
    echo ERROR: curl.exe was not found. Windows 10 or later is required.
    goto :fail
)

if not exist "%MODEL_DIR%" mkdir "%MODEL_DIR%"
if errorlevel 1 (
    echo ERROR: Could not create "%MODEL_DIR%".
    goto :fail
)

if exist "%SERVER_EXE%" (
    echo Found existing llama-server.exe; skipping the llama.cpp download.
) else (
    echo Downloading the llama.cpp Vulkan build...
    curl.exe --fail --location --retry 3 --retry-delay 2 --output "%ZIP_FILE%" "%LLAMA_ZIP_URL%"
    if errorlevel 1 (
        del /q "%ZIP_FILE%" >nul 2>&1
        echo ERROR: The llama.cpp download failed.
        goto :fail
    )

    echo Extracting llama.cpp into "%LLAMA_DIR%"...
    set "LLAMA_ZIP=%ZIP_FILE%"
    powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "try { Expand-Archive -LiteralPath $env:LLAMA_ZIP -DestinationPath $env:LLAMA_DIR -Force -ErrorAction Stop; exit 0 } catch { Write-Error $_; exit 1 }"
    if errorlevel 1 (
        del /q "%ZIP_FILE%" >nul 2>&1
        echo ERROR: Could not extract the llama.cpp archive.
        goto :fail
    )
    del /q "%ZIP_FILE%" >nul 2>&1

    if not exist "%SERVER_EXE%" (
        echo ERROR: llama-server.exe was not found in the extracted archive.
        goto :fail
    )
)

if exist "%MODEL_FILE%" (
    echo Found existing model; skipping the model download.
) else (
    echo Downloading the GGUF model. This file is large and may take a while...
    curl.exe --fail --location --retry 3 --retry-delay 2 --output "%MODEL_FILE%.part" "%MODEL_URL%"
    if errorlevel 1 (
        del /q "%MODEL_FILE%.part" >nul 2>&1
        echo ERROR: The model download failed.
        goto :fail
    )
    move /y "%MODEL_FILE%.part" "%MODEL_FILE%" >nul
    if errorlevel 1 (
        echo ERROR: Could not save the downloaded model to "%MODEL_FILE%".
        goto :fail
    )
)

echo.
echo Setup complete. Files are in "%LLAMA_DIR%".
pause
exit /b 0

:fail
echo.
echo Setup did not complete successfully.
pause
exit /b 1
