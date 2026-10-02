# Add Exa Web Search and Fetch to llama.cpp Web UI

This guide connects the bundled llama.cpp Web UI to Exa's hosted MCP server. Exa provides web search and webpage-fetch tools through one remote MCP connection. You do not need to install SearXNG or a local MCP package.

## What you need

- A llama.cpp `llama-server` build with the current Web UI and its MCP server manager.
- Internet access from the browser.
- A model that can make tool calls reasonably well.

Exa's hosted MCP server currently allows anonymous use with rate limits, so you can try it without an API key or account. Availability and rate limits are controlled by Exa and may change.

## Connect from the Web UI

1. Start `llama-server` normally and open its UI, usually at <http://localhost:8080>.
2. In the chat composer, click the round **+** button to the left of the message box. This opens the add-actions menu.
3. Choose **MCP Servers** near the bottom of that menu. On a phone or narrow screen, the **+** button opens a sheet instead of a desktop dropdown; choose **MCP Servers** there.
4. In the MCP Servers dialog, choose **Add New MCP Server**.
5. In **Recommended Servers**, select **Exa**. The server URL should be:

   ```text
   https://mcp.exa.ai/mcp
   ```

6. Leave the authorization and custom-header fields empty for anonymous access, then select **Add**.
7. Connect to the Exa server if it is not connected automatically. Confirm that the available tools include `web_search_exa` and `web_fetch_exa`.
8. To enable the tools for a chat, click the composer **+** button again, open **Tools**, and enable Exa's tools.

The `b11333` release includes the Exa recommendation, but the MCP controls are in the chat composer menu rather than the main sidebar. Older `llama-server` binaries may ship an older UI without the Exa recommendation.

## Try it

Ask for a search, for example:

> Search the web for recent llama.cpp server changes. Give me a few result titles and links.

Then ask the model to fetch one of the results:

> Fetch this page and summarize its main points: https://example.org/article

The Exa MCP server's default tools include web search and fetching full page content as clean Markdown. The model may make more than one tool call before answering. Results depend on the model's tool-calling behavior and Exa's service availability.

## If the connection fails with a CORS error

The browser may block a cross-origin request between the llama.cpp UI and Exa. First retry the connection. If the UI reports a CORS or browser network error:

1. Stop `llama-server`.
2. Start it again with the experimental MCP proxy option:

   ```text
   --ui-mcp-proxy
   ```

   For example, add that option to your existing `llama-server` command. Do not add `--agent` just for this proxy.

3. Return to **MCP Servers**, edit the Exa connection, enable **Use llama-server proxy**, and reconnect.

Keep llama-server bound to localhost for this setup. The proxy is experimental and should not be exposed to untrusted users or the public internet.

## Privacy and limits

Exa is a hosted service, not a local search engine. Search requests and URLs you ask it to fetch are sent to Exa; the anonymous service is rate-limited. Do not send sensitive queries or private URLs unless you are comfortable sharing them with the service.

## References

- [Exa MCP server](https://github.com/exa-labs/exa-mcp-server)
- [llama.cpp recommended MCP servers](https://github.com/ggml-org/llama.cpp/blob/master/tools/ui/src/lib/constants/recommended-mcp-servers.constants.ts)
- [llama.cpp MCP server form and proxy control](https://github.com/ggml-org/llama.cpp/blob/master/tools/ui/src/lib/components/app/mcp/McpServerForm.svelte)
- [llama.cpp server options](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md)
