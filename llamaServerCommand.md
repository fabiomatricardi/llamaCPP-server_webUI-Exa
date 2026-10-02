### Llama-cpp server command options
Windows

```bash
.\llama-server.exe -m .\models\LFM2.5-1.2B-Thinking-Q8_0.gguf \
--port 11434 -c 16384 \
--alias lfm2.5-1.2b \
-np 1 \
-ctk q4_0 \
-ctv q4_0 \
--jinja \
-lm mmap \
-ngl 99 \
-t 3 \
--reasoning-effort low \
-fa on \
-b 2048 \
-ub 2048 \
--ui-mcp-proxy
```

in one liner

```bash
.\llama-server.exe -m .\models\LFM2.5-1.2B-Thinking-Q8_0.gguf --port 11434 -c 16384 --alias lfm2.5-1.2b -np 1 -ctk q4_0 -ctv q4_0 --jinja -lm mmap -ngl 99 -t 3 --reasoning-effort low -fa on -b 2048 -ub 2048 --ui-mcp-proxy
```