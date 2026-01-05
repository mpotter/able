#!/usr/bin/env bun

/**
 * Creates a GitHub App using the manifest flow.
 *
 * This script:
 * 1. Starts a local server to receive the OAuth redirect
 * 2. Opens the browser to GitHub with the manifest
 * 3. Exchanges the code for app credentials
 * 4. Outputs the App ID and private key
 */

const manifest = {
  name: "Able Terraform",
  description: "GitHub App for Able infrastructure management via Terraform",
  url: "https://github.com/mpotter/able",
  hook_attributes: { active: false },
  public: false,
  default_permissions: {
    administration: "write",
    contents: "read",
    environments: "write",
    metadata: "read",
    pull_requests: "write",
    actions: "write",
  },
  default_events: [],
};

const PORT = 8374;
const REDIRECT_URL = `http://localhost:${PORT}/callback`;

// HTML page that auto-submits the manifest to GitHub
const fullManifest = { ...manifest, redirect_url: REDIRECT_URL };
const manifestJson = JSON.stringify(fullManifest);

const formHtml = `
<!DOCTYPE html>
<html>
<head><title>Creating GitHub App...</title></head>
<body>
  <p>Redirecting to GitHub...</p>
  <form id="form" action="https://github.com/settings/apps/new" method="post">
    <input type="hidden" name="manifest" id="manifest">
  </form>
  <script>
    document.getElementById('manifest').value = ${JSON.stringify(manifestJson)};
    document.getElementById('form').submit();
  </script>
</body>
</html>
`;

console.log("Starting GitHub App creation flow...\n");

const server = Bun.serve({
  port: PORT,
  async fetch(req) {
    const url = new URL(req.url);

    // Serve the form that redirects to GitHub
    if (url.pathname === "/") {
      return new Response(formHtml, {
        headers: { "Content-Type": "text/html" },
      });
    }

    // Handle the callback from GitHub
    if (url.pathname === "/callback") {
      const code = url.searchParams.get("code");

      if (!code) {
        return new Response("Error: No code received from GitHub", { status: 400 });
      }

      // Exchange code for app credentials
      const response = await fetch(
        `https://api.github.com/app-manifests/${code}/conversions`,
        {
          method: "POST",
          headers: {
            Accept: "application/vnd.github+json",
          },
        }
      );

      if (!response.ok) {
        const error = await response.text();
        console.error("GitHub API error:", error);
        return new Response(`Error exchanging code: ${error}`, { status: 500 });
      }

      const appData = await response.json();

      console.log("\n✅ GitHub App created successfully!\n");
      console.log(`App ID: ${appData.id}`);
      console.log(`App Name: ${appData.name}`);
      console.log(`\nPrivate key saved to: able-terraform-private-key.pem`);

      // Save the private key
      await Bun.write("able-terraform-private-key.pem", appData.pem);

      console.log("\n📋 Next steps:\n");
      console.log("1. Install the app on your repository:");
      console.log(`   ${appData.html_url}/installations/new\n`);
      console.log("2. Set the secrets:");
      console.log(`   gh secret set GH_APP_ID --body "${appData.id}"`);
      console.log("   gh secret set GH_APP_PRIVATE_KEY < able-terraform-private-key.pem\n");

      // Shutdown after a delay
      setTimeout(() => {
        console.log("Done!");
        process.exit(0);
      }, 1000);

      return new Response(
        `<html><body>
          <h1>✅ GitHub App Created!</h1>
          <p><strong>App ID:</strong> ${appData.id}</p>
          <p><strong>Name:</strong> ${appData.name}</p>
          <p>Private key saved to <code>able-terraform-private-key.pem</code></p>
          <h2>Next steps:</h2>
          <ol>
            <li><a href="${appData.html_url}/installations/new" target="_blank">Install the app on your repository</a></li>
            <li>Run these commands:
              <pre>gh secret set GH_APP_ID --body "${appData.id}"
gh secret set GH_APP_PRIVATE_KEY < able-terraform-private-key.pem</pre>
            </li>
          </ol>
          <p>You can close this window.</p>
        </body></html>`,
        { headers: { "Content-Type": "text/html" } }
      );
    }

    return new Response("Not found", { status: 404 });
  },
});

console.log(`Local server started on http://localhost:${PORT}`);
console.log("Opening browser...\n");

// Open browser
const proc = Bun.spawn(["open", `http://localhost:${PORT}`]);
await proc.exited;
