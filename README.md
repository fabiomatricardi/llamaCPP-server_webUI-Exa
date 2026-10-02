# llama-server WebUI is all you needed

A local AI, with built in free Web-search and web-fetch.

2 Options:
- [BROWSER ONLY](https://github.com/fabiomatricardi/llamaCPP-server_webUI-Exa/blob/main/BROWSER_GUIDE.md)
- [LLAMASERVER_MCP](https://github.com/fabiomatricardi/llamaCPP-server_webUI-Exa/blob/main/LLAMASERVER_MCP_GUIDE.md)

---


## llama.cpp Web UI with Exa search and fetch

Run a local llama.cpp server and use its built-in Web UI. The UI can connect to Exa for web search and fetch.

### Windows quick start (Vulkan)

Requirements: Windows 10 or later, an internet connection, and a Vulkan-capable GPU with a current driver.

1. Run [`download-llama.bat`](download-llama.bat). It downloads the llama.cpp `b11342` Vulkan build and the `LFM2.5-1.2B-Instruct-Q6_K.gguf` model. Files are placed in `llamaCPP\` and `llamaCPP\model\`. Existing `llama-server.exe` and model files are skipped.
2. When the download script finishes, run [`start-llama.bat`](start-llama.bat).
3. The launcher starts `llama-server.exe` in a separate console window with the configured options, waits 15 seconds, and opens <http://localhost:11434> in your browser. If the model is still loading, wait for the server to finish and refresh the page.
4. Keep the server console open while using the Web UI. Close that window or press **Ctrl+C** in it to stop the server.

### Batch files

| File | Purpose |
| --- | --- |
| [`download-llama.bat`](download-llama.bat) | Creates the install folders, downloads and extracts the Vulkan build, and downloads the GGUF model. Existing executable/model files are reused. |
| [`start-llama.bat`](start-llama.bat) | Checks that the executable and model exist, starts the server in a new window with the configured flags, then opens the Web UI after 15 seconds. |

The scripts use their own folder as the install location, so you can run them by double-clicking or from a terminal without changing the working directory.

## Configure Exa in the Web UI

After the server starts, use the Web UI's chat composer **+** menu and choose **MCP Servers**. Add the recommended Exa server. To use its tools in a chat, open **+ → Tools** and enable Exa's tools.

For detailed setup instructions, see:

- [Browser-only Exa setup](BROWSER_GUIDE.md)
- [Run local MCP servers](LLAMASERVER_MCP_GUIDE.md)

## Server options

`start-llama.bat` launches the server with the following settings:

- Model: `LFM2.5-1.2B-Instruct-Q6_K.gguf`
- Port: `11434`
- Context: `16384`
- Alias: `lfm2.5-1.2b`
- Vulkan offload: up to `99` layers
- Flash attention and `q4_0` KV cache
- Web UI MCP proxy enabled
- Sampling: temperature `0.1`, top-k `50`, repeat penalty `1.05`

Edit the `start` command in `start-llama.bat` if you want to change these options.
