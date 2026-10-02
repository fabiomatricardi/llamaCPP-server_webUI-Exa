@echo off
setlocal

set "ROOT=%~dp0"
set "LLAMA_DIR=%ROOT%llamaCPP"
set "SERVER_EXE=%LLAMA_DIR%\llama-server.exe"
set "MODEL_FILE=%LLAMA_DIR%\model\LFM2.5-1.2B-Instruct-Q6_K.gguf"

if not exist "%SERVER_EXE%" (
    echo ERROR: "%SERVER_EXE%" was not found.
    echo Run download-llama.bat first.
    pause
    exit /b 1
)

if not exist "%MODEL_FILE%" (
    echo ERROR: "%MODEL_FILE%" was not found.
    echo Run download-llama.bat first.
    pause
    exit /b 1
)

echo Starting llama-server in a separate window...
start "llama-server" /D "%LLAMA_DIR%" "%SERVER_EXE%" -m model/LFM2.5-1.2B-Instruct-Q6_K.gguf --port 11434 -c 16384 --alias lfm2.5-1.2b -np 1 -ctk q4_0 -ctv q4_0 --jinja -lm mmap -ngl 99 -t 3 -fa on -b 2048 -ub 2048 --ui-mcp-proxy --temp 0.1 --top-k 50 --repeat-penalty 1.05

echo Waiting 15 seconds, then opening the Web UI...
timeout /t 15 /nobreak >nul
start "" "http://localhost:11434"
exit /b 0
