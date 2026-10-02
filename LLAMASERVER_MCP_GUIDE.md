# Web Search and Fetch with llama-server, Public SearXNG, and MCP

This Windows-oriented guide connects llama.cpp Web UI to:

- A **public SearXNG instance** for web search.
- An MCP fetch server for retrieving webpage content.

You do not run or install SearXNG yourself. A small MCP adapter runs locally and translates between llama-server's MCP interface and the public SearXNG search API. `uvx` downloads and runs that adapter for you. The fetch server is a second MCP package.

## How the pieces fit together

- **SearXNG instance:** A community-operated search service on the internet. Its availability and policies are set by its operator.
- **MCP:** A standard interface through which llama-server discovers and calls tools.
- **MCP adapter:** The small `mcp-searxng` program that converts MCP search requests into SearXNG HTTP API requests.
- **uv / uvx:** `uv` is a package and Python-environment manager. `uvx` runs a package in an isolated environment, downloading it the first time and reusing its cache afterward. You do not manually install the MCP packages.

The SearXNG adapter supplies search only. The separate `mcp-server-fetch` package supplies page fetching.

## 1. Choose and test a public SearXNG instance

1. Open the [SearXNG public instance directory](https://searx.space/).
2. Pick an instance shown as online.
3. In a browser, test its JSON endpoint by replacing `INSTANCE-HOST` with its domain:

   ```text
   https://INSTANCE-HOST/search?q=llama.cpp&format=json
   ```

4. A usable endpoint should display JSON containing search results. If it returns `403 Forbidden`, a CAPTCHA, or an HTML page, try a different instance.

For the configuration below, copy only the instance's base address, such as `https://search.example.org`. Do not include `/search`, `?q=...`, or other query parameters. The SearXNG documentation warns that many public instances disable JSON output, which is required by this adapter.

## 2. Install uv on Windows

1. Open **PowerShell**.
2. Install uv with Windows Package Manager:

   ```powershell
   winget install --id=astral-sh.uv -e
   ```

   If PowerShell says `winget` is not recognized, follow the Windows installation instructions on the [official uv installation page](https://docs.astral.sh/uv/getting-started/installation/).

3. Close PowerShell and open a new PowerShell window so it refreshes its list of available commands.
4. Check that both commands are available:

   ```powershell
   uv --version
   uvx --version
   ```

`uvx` will create an isolated environment and download the MCP package when llama-server first starts it. The `mcp-searxng` package requires Python 3.12 or newer; uv can manage a compatible Python version when needed.

## 3. Create `mcp.json`

1. Open Notepad.
2. Paste the following configuration:

   ```json
   {
     "mcpServers": {
       "searxng": {
         "command": "uvx",
         "args": ["mcp-searxng"],
         "env": {
           "SEARXNG_URL": "https://INSTANCE-HOST"
         }
       },
       "fetch": {
         "command": "uvx",
         "args": ["mcp-server-fetch"],
         "env": {
           "PYTHONIOENCODING": "utf-8"
         }
       }
     }
   }
   ```

3. Replace `https://INSTANCE-HOST` with the base address of the instance you tested. For example:

   ```json
   "SEARXNG_URL": "https://search.example.org"
   ```

4. In Notepad, choose **File → Save As**. Name the file `mcp.json` and save it somewhere easy to locate, such as the folder containing `llama-server.exe`.
5. In the Save As dialog, set **Save as type** to **All files** so Notepad does not name it `mcp.json.txt`.

The config format is JSON: keep the quotation marks, and do not add comments or a comma after the final entry.

## 4. Start llama-server with the MCP configuration

Stop llama-server if it is running already. In PowerShell, change to the folder containing `llama-server.exe` and `mcp.json`. For example, replace the path below with that folder's actual path:

```powershell
cd "C:\path\to\llama-folder"
```

Then start the server with the path to your model:

```powershell
.\llama-server.exe -m "C:\path\to\your-model.gguf" --mcp-servers-config ".\mcp.json"
```

Replace `C:\path\to\your-model.gguf` with the real path to your GGUF model. If you already use other server options, keep them and add:

```text
--mcp-servers-config ".\mcp.json"
```

If you start llama-server through another launcher, add the option to that launcher's llama-server arguments instead. The first start may take longer while `uvx` downloads the MCP packages and their dependencies.

You do not need `--tools all` to use MCP. llama-server launches the configured MCP processes and exposes their tools to its Web UI. MCP processes run with the same operating-system privileges as llama-server, so use packages and URLs you trust.

## 5. Enable and test the tools

1. Open the Web UI, usually at <http://localhost:8080>.
2. Open the chat's tools controls and enable the SearXNG search and fetch tools. Their displayed names may be prefixed with the MCP server names, for example `searxng_search` and `fetch_fetch`.
3. Ask the model:

   > Search the web for recent llama.cpp news and show me the result URLs.

4. Then ask it to fetch one of the results:

   > Fetch this page and summarize its contents: [paste a result URL]

The model must be able to use tool calls for this workflow. If the tools appear but are not called, check that they are enabled and try a model with good tool-calling support.

## Troubleshooting

### Search gives a 403, HTML, or a CAPTCHA

The selected SearXNG operator may have disabled JSON output or may block automated requests. Test a different instance from [searx.space](https://searx.space/). A successful browser test does not guarantee the instance will accept the adapter's requests.

### `uvx` is not found

Close and reopen PowerShell after installing uv. If llama-server is launched by a desktop application, restart that application too so it sees the updated PATH.

### The MCP tools do not appear

- Confirm that `mcp.json` is valid JSON and was saved as `mcp.json`, not `mcp.json.txt`.
- Confirm that the command includes the correct `--mcp-servers-config` file path.
- Look at llama-server's startup output for MCP startup or discovery errors.
- Check that `SEARXNG_URL` is only the instance base URL.

## Costs, privacy, and limitations

This arrangement has no SearXNG hosting bill or API key, but the public instance can change its availability, impose limits, or stop allowing JSON requests. The instance operator receives search queries and the network address of the machine making the request. Check the operator's privacy policy and do not include sensitive queries.

The fetch server is separate from SearXNG. Its maintainers warn it can access local or internal network addresses; use it only with a llama-server setup you trust.

## References

- [SearXNG public instance directory](https://searx.space/)
- [SearXNG Search API](https://docs.searxng.org/dev/search_api.html)
- [mcp-searxng adapter](https://github.com/SecretiveShell/MCP-searxng)
- [MCP fetch server](https://github.com/modelcontextprotocol/servers/tree/main/src/fetch)
- [uv installation](https://docs.astral.sh/uv/getting-started/installation/)
- [llama-server MCP configuration](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)
