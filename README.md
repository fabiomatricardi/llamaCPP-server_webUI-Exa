# llama-server WebUI is all you needed

A local AI, with built in free Web-search and web-fetch.

2 Options:
- [BROWSER ONLY](https://github.com/fabiomatricardi/llamaCPP-server_webUI-Exa/raw/main/BROWSER_GUIDE.md)
- [LLAMASERVER_MCP](https://github.com/fabiomatricardi/llamaCPP-server_webUI-Exa/raw/main/LLAMASERVER_MCP_GUIDE.md)

---

## Objective
- Help the user connect Exa to the llama.cpp Web UI, then clarify why the MCP controls are not visible in build `llama-b11333-bin-win-vulkan-x64`.
- The user previously requested two beginner-friendly guides, which have been created in the workspace.

## Important Details
- User reports there is no visible option called **MCP** or **Add MCP** in their build.
- Inspected upstream source at tag `b11333`:
  - `tools/ui/src/lib/constants/recommended-mcp-servers.constants.ts` includes Exa at `https://mcp.exa.ai/mcp`.
  - `tools/ui/src/lib/constants/routes.constants.ts` defines `ROUTES.MCP_SERVERS` as `#/mcp-servers`.
  - `ChatForm.svelte` imports `DialogMcpServers`.
  - `ChatFormActions.svelte` accepts `onMcpSettingsClick`.
  - `McpActiveServersAvatars.svelte` displays an MCP Servers control.
- Thus, MCP appears present in the `b11333` source; the exact UI location or why it is missing in the user's binary remains unresolved.
- `git status --short` failed with `fatal: not a git repository (or any of the parent directories): .git`.

## Work State
### Completed
- Created and reviewed `BROWSER_GUIDE.md` for connecting the Web UI to hosted Exa.
- Created and reviewed `LLAMASERVER_MCP_GUIDE.md` for Windows setup using `uvx`, public SearXNG, and an MCP fetch server.
- Confirmed the upstream `b11333` source contains Exa's recommended MCP server entry and MCP UI components/routes.

### Active
- Investigating where the MCP server manager is opened in the `b11333` UI, and why the user's downloaded binary does not show an MCP option.
- Relevant source inspection reached `ChatForm.svelte`, `ChatFormActions.svelte`, and `McpActiveServersAvatars.svelte`; the exact click path has not yet been established.

### Blocked
- Cannot verify the user's local UI or binary directly; no screenshot or startup details provided.
- Git commands cannot be used because the workspace is not a Git repository.

## Next Move
1. Inspect `ChatForm.svelte` and related components to find where `DialogMcpServers` opens and identify the visible button/icon users should click; consider testing the `#/mcp-servers` route directly.
2. Explain the discovered navigation path and, if needed, troubleshoot whether the binary serves a stale/different UI or whether browser cache/UI state is involved.

## Relevant Files
- `C:\myAI\20261002.llamaCPP-tools\BROWSER_GUIDE.md`: Exa Web UI setup guide.
- `C:\myAI\20261002.llamaCPP-tools\LLAMASERVER_MCP_GUIDE.md`: Windows `uvx`/SearXNG/fetch guide.
- `tools/ui/src/lib/constants/recommended-mcp-servers.constants.ts` at `b11333`: Exa recommendation definition.
- `tools/ui/src/lib/constants/routes.constants.ts` at `b11333`: MCP manager route constant `#/mcp-servers`.
- `tools/ui/src/lib/components/app/chat/ChatForm/ChatForm.svelte` at `b11333`: imports `DialogMcpServers`.
- `tools/ui/src/lib/components/app/chat/ChatForm/ChatFormActions/ChatFormActions.svelte` at `b11333`: has `onMcpSettingsClick` callback.
- `tools/ui/src/lib/components/app/mcp/McpActiveServersAvatars.svelte` at `b11333`: renders an MCP Servers control.

---